#!/usr/bin/env python3

import argparse
import glob
import json
import os
import re
import shutil
import stat
import subprocess
import sys
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import dataclass
from decimal import Decimal
from pathlib import Path
from typing import Optional, Union


# Defines a cleanup backed by shell commands for sizing and deletion
@dataclass(frozen=True)
class CommandCleanup:
    # Human-readable text shown during selection and status reporting
    description: str
    # Shell command that performs the cleanup
    cleanup_command: str
    # Shell command that reports the reclaimable size
    filesize_command: str
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


# Couples a visible cleanup label with its normalized byte count
@dataclass(frozen=True)
class CleanupMeasurement:
    # Complete text presented in the cleanup picker
    label: str
    # Reclaimable bytes used for sorting; unavailable measurements have no value
    size_bytes: Optional[Decimal]


# Represents either supported cleanup definition shape
Cleanup = Union[CommandCleanup, PathCleanup]

# Locates the definitions relative to this script rather than the working directory
DEFINITIONS_PATH = Path(__file__).with_name("cleanup-definitions.json")

# Shell invocation that enables pipelines while preserving failures from every stage
BASH_COMMAND = ("/bin/bash", "-o", "pipefail", "-c")

# Number of concurrent cleanup measurements used unless the command line overrides it
DEFAULT_WORKER_COUNT = 4

# Accepted command size split into a numeric amount and alphabetic units
SIZE_PATTERN = re.compile(r"^([0-9]+(?:\.[0-9]+)?)([A-Za-z]+)$")

# Decimal and binary unit multipliers used to normalize command-reported sizes
SIZE_MULTIPLIERS = {
    "B": 1,
    "kB": 1000,
    "KB": 1000,
    "MB": 1000**2,
    "GB": 1000**3,
    "TB": 1000**4,
    "PB": 1000**5,
    "EB": 1000**6,
    "KiB": 1024,
    "MiB": 1024**2,
    "GiB": 1024**3,
    "TiB": 1024**4,
    "PiB": 1024**5,
    "EiB": 1024**6,
}


# Reports malformed or unreadable cleanup definitions
class DefinitionError(Exception):
    pass


# Validates a command-line worker count for concurrent measurements
def positive_integer(value: str) -> int:
    try:
        # Parsed integer candidate supplied by the command line
        integer = int(value)
    except ValueError as error:
        raise argparse.ArgumentTypeError("must be a positive integer") from error
    if integer < 1:
        raise argparse.ArgumentTypeError("must be a positive integer")
    return integer


# Parses command-line settings for the interactive cleanup workflow
def parse_arguments() -> argparse.Namespace:
    # Parser describing supported workflow configuration options
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--workers",
        type=positive_integer,
        default=DEFAULT_WORKER_COUNT,
        help=(
            "number of concurrent cleanup size measurements "
            f"(default: {DEFAULT_WORKER_COUNT})"
        ),
    )
    return parser.parse_args()


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
        # Cleanup command discriminator used to choose the runtime record type
        has_cleanup_command = "cleanup_command" in definition
        # Size command required by every command-backed definition
        has_filesize_command = "filesize_command" in definition
        # Path discriminator used to choose the runtime record type
        has_path = "path" in definition
        if not isinstance(description, str) or not description:
            raise DefinitionError(
                f"Cleanup definition {index} has an invalid description"
            )
        if app is not None and not isinstance(app, str):
            raise DefinitionError(f"Cleanup definition {index} has an invalid app")
        # Exactly one cleanup type must be present
        if has_cleanup_command == has_path:
            raise DefinitionError(
                f"Cleanup definition {index} must contain either cleanup_command or path"
            )

        if has_cleanup_command:
            # Shell command that performs the cleanup
            cleanup_command = definition["cleanup_command"]
            # Shell command that reports the reclaimable size
            filesize_command = definition.get("filesize_command")
            if not isinstance(cleanup_command, str) or not cleanup_command:
                raise DefinitionError(
                    f"Cleanup definition {index} has an invalid cleanup_command"
                )
            if (
                not has_filesize_command
                or not isinstance(filesize_command, str)
                or not filesize_command
            ):
                raise DefinitionError(
                    f"Cleanup definition {index} has an invalid filesize_command"
                )
            cleanups.append(
                CommandCleanup(description, cleanup_command, filesize_command, app)
            )
        else:
            if has_filesize_command:
                raise DefinitionError(
                    f"Cleanup definition {index} cannot combine filesize_command and path"
                )
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


# Presents all measured definitions in fzf and returns the accepted selection
def select_cleanups(
    cleanups: tuple[Cleanup, ...], measurements: tuple[CleanupMeasurement, ...]
) -> list[Cleanup]:
    # Builds a key that places unavailable sizes after every measured size
    def selection_sort_key(
        indexed_measurement: tuple[int, CleanupMeasurement],
    ) -> tuple[bool, Decimal]:
        # Measurement being ranked for display
        measurement = indexed_measurement[1]
        # Numeric fallback used only when the measurement is unavailable
        sortable_size = (
            measurement.size_bytes if measurement.size_bytes is not None else Decimal(0)
        )
        return measurement.size_bytes is not None, sortable_size

    # Measurements ranked by normalized size while retaining original cleanup indices
    ranked_measurements = sorted(
        enumerate(measurements), key=selection_sort_key, reverse=True
    )
    # The hidden index gives each display string a stable identity after fzf filtering
    entries = "".join(
        f"{index}\t{measurement.label}\n" for index, measurement in ranked_measurements
    )
    # Completed fzf process containing the accepted rows or cancellation status
    result = subprocess.run(
        (
            "fzf",
            "--multi",
            "--delimiter=\\t",
            "--with-nth=2..",
            "--layout=reverse",
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


# Executes a command cleanup through Bash with pipeline failure propagation
def run_command_cleanup(cleanup: CommandCleanup) -> bool:
    try:
        # Completed command process whose status determines cleanup success
        result = subprocess.run(
            (*BASH_COMMAND, cleanup.cleanup_command),
            check=False,
        )
    except OSError as error:
        print(f"{cleanup.description}: cleanup failed: {error}", file=sys.stderr)
        return False

    if result.returncode == 0:
        print(f"{cleanup.description}: cleanup completed successfully")
        return True

    print(f"{cleanup.description}: cleanup failed", file=sys.stderr)
    return False


# Recursively calculates allocated bytes while avoiding hard-link double counting
def allocated_size(path: str, seen_inodes: set[tuple[int, int]]) -> int:
    # Metadata for the raw path string without following symbolic links
    path_stat = os.lstat(path)
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
                size += allocated_size(entry.path, seen_inodes)
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


# Measures all paths currently matched by a path cleanup
def measure_path_cleanup(cleanup: PathCleanup) -> Optional[tuple[str, Decimal]]:
    # Paths produced by expanding the definition's glob pattern
    paths = list(glob.iglob(cleanup.pattern))
    if not paths:
        return format_size(0), Decimal(0)

    try:
        # Filesystem identities already included in the allocation total
        seen_inodes: set[tuple[int, int]] = set()
        # Total allocated bytes across all matches
        size = sum(allocated_size(path, seen_inodes) for path in paths)
    except OSError as error:
        print(f"{cleanup.description}: size unavailable: {error}", file=sys.stderr)
        return None
    return format_size(size), Decimal(size)


# Captures and validates the size reported by a command cleanup
def measure_command_cleanup(cleanup: CommandCleanup) -> Optional[tuple[str, Decimal]]:
    try:
        # Completed size process whose stdout must contain exactly one size value
        result = subprocess.run(
            (*BASH_COMMAND, cleanup.filesize_command),
            text=True,
            capture_output=True,
            check=False,
        )
    except OSError as error:
        print(f"{cleanup.description}: size unavailable: {error}", file=sys.stderr)
        return None

    # Non-empty stdout lines used to reject missing or ambiguous measurements
    lines = [line.strip() for line in result.stdout.splitlines() if line.strip()]
    # Parsed numeric amount and units from the sole output value
    size_match = SIZE_PATTERN.fullmatch(lines[0]) if len(lines) == 1 else None
    if result.returncode != 0 or size_match is None:
        print(f"{cleanup.description}: size unavailable", file=sys.stderr)
        return None

    # Unit multiplier needed to compare differently formatted size values
    multiplier = SIZE_MULTIPLIERS.get(size_match.group(2))
    if multiplier is None:
        print(f"{cleanup.description}: size unavailable", file=sys.stderr)
        return None
    # Exact byte equivalent retained independently from the displayed value
    size_bytes = Decimal(size_match.group(1)) * multiplier
    return lines[0], size_bytes


# Measures a cleanup and builds its sortable selection metadata
def measure_cleanup(cleanup: Cleanup) -> CleanupMeasurement:
    # Reclaimable size reported by the cleanup's measurement strategy
    measurement = (
        measure_command_cleanup(cleanup)
        if isinstance(cleanup, CommandCleanup)
        else measure_path_cleanup(cleanup)
    )
    # Display value used when measurement cannot produce a trustworthy result
    displayed_size = measurement[0] if measurement is not None else "size unavailable"
    # Byte count used to order the picker independently from display formatting
    size_bytes = measurement[1] if measurement is not None else None
    return CleanupMeasurement(f"{cleanup.description} ({displayed_size})", size_bytes)


# Measures all cleanups concurrently while reporting completed work to the terminal
def measure_cleanups(
    cleanups: tuple[Cleanup, ...], workers: int
) -> tuple[CleanupMeasurement, ...]:
    # Total cleanup measurements included in the current progress display
    total = len(cleanups)
    # Ordered slots preserve the definition order after concurrent completion
    measurements: list[Optional[CleanupMeasurement]] = [None] * total
    # Worker pool overlaps independent filesystem and command-backed measurements
    with ThreadPoolExecutor(max_workers=workers) as executor:
        # Associates each submitted measurement with its original definition index
        futures = {
            executor.submit(measure_cleanup, cleanup): index
            for index, cleanup in enumerate(cleanups)
        }
        # Number of completed measurements displayed to the user
        completed = 0
        # Finished measurement future reported in completion order
        for future in as_completed(futures):
            # Original position used to restore definition order after completion
            index = futures[future]
            measurements[index] = future.result()
            completed += 1
            print(
                f"\rCalculating cleanup sizes: {completed}/{total}",
                end="",
                flush=True,
            )
    print(flush=True)
    return tuple(measurement for measurement in measurements if measurement is not None)


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
    paths = list(glob.iglob(cleanup.pattern))
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
            delete_path(Path(path))
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
    # Command-line settings controlling the measurement phase
    arguments = parse_arguments()
    try:
        # Validated cleanup definitions available for interactive selection
        cleanups = load_cleanups()
    except DefinitionError as error:
        print(error, file=sys.stderr)
        return 1

    if not check_requirements():
        return 1

    # Display measurements retain definition order while reporting concurrent progress
    measurements = measure_cleanups(cleanups, arguments.workers)
    # Definitions accepted by the user in fzf
    selected = select_cleanups(cleanups, measurements)
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
