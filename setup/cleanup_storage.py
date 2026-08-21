#!/usr/bin/env python3

import glob
import json
import os
import shlex
import shutil
import stat
import subprocess
import sys
import time
from dataclasses import dataclass
from pathlib import Path
from typing import Optional, Union


# Defines a cleanup that executes a program with an explicit argument vector
@dataclass(frozen=True)
class CommandCleanup:
    # Human-readable text shown during selection and status reporting
    description: str
    # Executable and arguments passed directly to subprocess
    args: tuple[str, ...]
    # Application that must exit before the cleanup begins
    app: Optional[str] = None


# Defines a cleanup that removes paths matching a glob pattern
@dataclass(frozen=True)
class PathCleanup:
    # Human-readable text shown during selection and status reporting
    description: str
    # Expanded home-relative pattern whose matches will be removed
    pattern: str
    # Application that must exit before the cleanup begins
    app: Optional[str] = None


# Represents either supported cleanup definition shape
Cleanup = Union[CommandCleanup, PathCleanup]

# Locates the definitions relative to this script rather than the working directory
DEFINITIONS_PATH = Path(__file__).with_name("cleanup-definitions.json")


# Reports malformed or unreadable cleanup definitions
class DefinitionError(Exception):
    pass


# Loads and validates cleanup definitions from JSON
def load_cleanups() -> tuple[Cleanup, ...]:
    try:
        # Raw cleanup objects decoded from the definitions file
        definitions = json.loads(DEFINITIONS_PATH.read_text())
    except (OSError, json.JSONDecodeError) as error:
        raise DefinitionError(f"Could not load {DEFINITIONS_PATH}: {error}") from error

    if not isinstance(definitions, list):
        raise DefinitionError("Cleanup definitions must be a JSON list")

    # Validated runtime cleanup objects in display order
    cleanups: list[Cleanup] = []
    # One-based index and raw object used to produce helpful validation errors
    for index, definition in enumerate(definitions, start=1):
        if not isinstance(definition, dict):
            raise DefinitionError(f"Cleanup definition {index} must be an object")

        # Human-readable description shared by both union members
        description = definition.get("description")
        # Optional application dependency shared by both union members
        app = definition.get("app")
        # Command discriminator used to choose the runtime record type
        has_command = "command" in definition
        # Path discriminator used to choose the runtime record type
        has_path = "path" in definition
        if not isinstance(description, str) or not description:
            raise DefinitionError(
                f"Cleanup definition {index} has an invalid description"
            )
        if app is not None and not isinstance(app, str):
            raise DefinitionError(f"Cleanup definition {index} has an invalid app")
        # The presence of one action field is the discriminator for the union
        if has_command == has_path:
            raise DefinitionError(
                f"Cleanup definition {index} must contain either command or path"
            )

        if has_command:
            # Shell-like command text from the command union member
            command = definition["command"]
            if not isinstance(command, str) or not command:
                raise DefinitionError(
                    f"Cleanup definition {index} has an invalid command"
                )
            try:
                # Parse shell-style quoting without invoking a shell during execution
                args = tuple(shlex.split(command))
            except ValueError as error:
                raise DefinitionError(
                    f"Cleanup definition {index} has an invalid command: {error}"
                ) from error
            if not args:
                raise DefinitionError(
                    f"Cleanup definition {index} has an empty command"
                )
            cleanups.append(CommandCleanup(description, args, app))
        else:
            # Home-relative glob text from the path union member
            pattern = definition["path"]
            if not isinstance(pattern, str) or not pattern:
                raise DefinitionError(f"Cleanup definition {index} has an invalid path")
            # Keep glob metacharacters intact while resolving the user's home directory
            cleanups.append(PathCleanup(description, os.path.expanduser(pattern), app))

    return tuple(cleanups)


# Verifies that unconditional external dependencies are available
def check_requirements() -> bool:
    # Utilities missing from the current executable search path
    missing = [utility for utility in ("fzf", "osascript") if not shutil.which(utility)]
    # Individual missing utility reported to the user
    for utility in missing:
        print(f"Required utility not found: {utility}", file=sys.stderr)
    return not missing


# Presents all definitions in fzf and returns the accepted selection
def select_cleanups(cleanups: tuple[Cleanup, ...]) -> list[Cleanup]:
    # The hidden index gives each display string a stable identity after fzf filtering
    entries = "".join(
        f"{index}\t{cleanup.description}\n" for index, cleanup in enumerate(cleanups)
    )
    # Completed fzf process containing the accepted rows or cancellation status
    result = subprocess.run(
        (
            "fzf",
            "--multi",
            "--delimiter=\\t",
            "--with-nth=2..",
            "--bind=start:select-all,space:toggle,ctrl-a:select-all,ctrl-d:deselect-all",
            "--prompt=Cleanups> ",
        ),
        input=entries,
        text=True,
        capture_output=True,
        check=False,
    )
    if result.returncode != 0:
        return []

    # Cleanup objects recovered from the accepted row indices
    selected: list[Cleanup] = []
    # Accepted row containing a hidden index and visible description
    for line in result.stdout.splitlines():
        # Parsed index text and delimiter used to validate the row shape
        index_text, separator, _ = line.partition("\t")
        if not separator:
            continue
        try:
            selected.append(cleanups[int(index_text)])
        except (ValueError, IndexError):
            continue
    return selected


# Displays the accepted selection and requests final confirmation
def confirm_cleanups(cleanups: list[Cleanup]) -> bool:
    if not cleanups:
        return False

    print("Selected cleanups:")
    # Cleanup whose description is included in the confirmation summary
    for cleanup in cleanups:
        print(f"  - {cleanup.description}")

    try:
        # User response controlling whether destructive work begins
        answer = input("Run these cleanups? [y/N] ")
    except EOFError:
        return False
    return answer.lower() in {"y", "yes"}


# Escapes a value for use inside a quoted AppleScript string
def apple_script_string(value: str) -> str:
    return value.replace("\\", "\\\\").replace('"', '\\"')


# Queries macOS for the current running state of an application
def app_is_running(app: str) -> bool:
    # Application name escaped for safe AppleScript interpolation
    escaped_app = apple_script_string(app)
    # Completed AppleScript query containing a true or false response
    result = subprocess.run(
        ("osascript", "-e", f'application "{escaped_app}" is running'),
        text=True,
        capture_output=True,
        check=False,
    )
    if result.returncode != 0:
        raise RuntimeError(result.stderr.strip() or "osascript failed")
    # Normalized application state returned by AppleScript
    running = result.stdout.strip()
    if running not in {"true", "false"}:
        raise RuntimeError(f"unexpected osascript response: {running!r}")
    return running == "true"


# Requests a normal application quit and waits until shutdown completes
def wait_for_app(app: str) -> bool:
    try:
        if not app_is_running(app):
            return True
        print(f"Requesting that {app} quit...")
        # Application name escaped for safe AppleScript interpolation
        escaped_app = apple_script_string(app)
        # Completed AppleScript quit request used to detect request failures
        result = subprocess.run(
            ("osascript", "-e", f'tell application "{escaped_app}" to quit'),
            check=False,
        )
        if result.returncode != 0:
            print(f"Could not request that {app} quit", file=sys.stderr)
            return False

        print(f"Waiting for {app} to exit; force-quit it if necessary...")
        # Wait indefinitely so deletion cannot race a slow or unresponsive app shutdown
        while app_is_running(app):
            time.sleep(1)
        return True
    except RuntimeError as error:
        print(f"Could not determine whether {app} is running: {error}", file=sys.stderr)
        return False


# Executes a command cleanup without shell interpretation
def run_command_cleanup(cleanup: CommandCleanup) -> bool:
    try:
        # Completed command process whose status determines cleanup success
        result = subprocess.run(cleanup.args, check=False)
    except OSError as error:
        print(f"{cleanup.description}: cleanup failed: {error}", file=sys.stderr)
        return False

    if result.returncode == 0:
        print(f"{cleanup.description}: cleanup completed successfully")
        return True

    print(f"{cleanup.description}: cleanup failed", file=sys.stderr)
    return False


# Recursively calculates allocated bytes while avoiding hard-link double counting
def allocated_size(path: Path, seen_inodes: set[tuple[int, int]]) -> int:
    # Metadata for the path itself without following symbolic links
    path_stat = path.lstat()
    # Filesystem identity used to detect repeated hard links
    inode = (path_stat.st_dev, path_stat.st_ino)
    # Match du's hard-link behavior by counting each inode only once
    if inode in seen_inodes:
        return 0
    seen_inodes.add(inode)

    # st_blocks reports allocated 512-byte blocks rather than logical file length
    size = path_stat.st_blocks * 512
    # lstat prevents directory symlinks from being traversed outside the matched tree
    if stat.S_ISDIR(path_stat.st_mode):
        # Directory iterator that includes hidden descendants of a matched directory
        with os.scandir(path) as entries:
            # Child directory entry included in the recursive allocation total
            for entry in entries:
                size += allocated_size(Path(entry.path), seen_inodes)
    return size


# Formats a byte count with decimal units matching GNU numfmt output
def format_size(size: int) -> str:
    # Scaled numeric amount for the unit currently under consideration
    amount = float(size)
    # Decimal storage unit selected from smallest to largest
    for unit in ("B", "kB", "MB", "GB", "TB", "PB"):
        if amount < 1000 or unit == "PB":
            return f"{amount:.1f}{unit}"
        amount /= 1000
    raise AssertionError("unreachable")


# Removes one matched path without following symbolic links
def delete_path(path: Path) -> None:
    try:
        # Metadata used to distinguish real directories from other path types
        path_stat = path.lstat()
    except FileNotFoundError:
        # Mirror rm -f when a matched path disappears between expansion and deletion
        return

    # Symlinks and special files must be unlinked rather than followed
    if stat.S_ISDIR(path_stat.st_mode):
        shutil.rmtree(path)
    else:
        path.unlink()


# Calculates and removes every path matched by a path cleanup
def run_path_cleanup(cleanup: PathCleanup) -> bool:
    # iglob preserves ordinary shell behavior where * excludes hidden children
    paths = [Path(path) for path in glob.iglob(cleanup.pattern)]
    if not paths:
        print(f"{cleanup.description}: already clean")
        return True

    try:
        # Filesystem identities already included in the allocation total
        seen_inodes: set[tuple[int, int]] = set()
        # Total allocated bytes captured immediately before deletion
        size = sum(allocated_size(path, seen_inodes) for path in paths)
    except OSError as error:
        print(
            f"{cleanup.description}: could not calculate cleanup size: {error}",
            file=sys.stderr,
        )
        return False

    try:
        # Matched path removed as an individual rm-style argument
        for path in paths:
            delete_path(path)
    except OSError as error:
        # Do not claim reclaimed space after a failed or partial deletion
        print(f"{cleanup.description}: cleanup failed: {error}", file=sys.stderr)
        return False

    print(f"{cleanup.description}: reclaimed {format_size(size)}")
    return True


# Applies any application requirement and dispatches one cleanup
def run_cleanup(cleanup: Cleanup) -> bool:
    if cleanup.app and not wait_for_app(cleanup.app):
        return False
    if isinstance(cleanup, CommandCleanup):
        return run_command_cleanup(cleanup)
    return run_path_cleanup(cleanup)


# Runs the interactive cleanup workflow and returns its process status
def main() -> int:
    try:
        # Validated cleanup definitions available for interactive selection
        cleanups = load_cleanups()
    except DefinitionError as error:
        print(error, file=sys.stderr)
        return 1

    if not check_requirements():
        return 1

    # Definitions accepted by the user in fzf
    selected = select_cleanups(cleanups)
    if not confirm_cleanups(selected):
        return 0

    # Aggregate failure flag that allows later selected cleanups to continue
    failed = False
    # Selected cleanup currently being executed
    for cleanup in selected:
        if not run_cleanup(cleanup):
            failed = True
    return int(failed)


if __name__ == "__main__":
    sys.exit(main())
