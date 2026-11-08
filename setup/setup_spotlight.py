#!/usr/bin/env python3
"""Exclude folders from Spotlight using the patterns in your exclusions file"""

import argparse
import ctypes
import fnmatch
import functools
import os
import stat
import subprocess
import sys
import time
import unicodedata

# The existing pattern file shared by the manual and native workflows
DEFAULT_EXCLUSIONS_LIST_PATH = os.path.expanduser(
    "~/dotfiles/private/setup/spotlight-exclusions.txt"
)


# Call the same private Metadata functions as SpotlightPreferenceExtension
# These aren't a public API; fail if macOS removes or changes them
# https://gist.github.com/pudquick/f150b59dd68500099a56184dc25f1300
class Spotlight:
    # Load the frameworks and declare their native argument and return types
    def __init__(self):
        # The system libraries; ctypes resolves these from the dyld shared cache
        self.metadata = ctypes.CDLL(
            "/System/Library/Frameworks/CoreServices.framework/"
            "Frameworks/Metadata.framework/Metadata"
        )
        self.core = ctypes.CDLL(
            "/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation"
        )
        # The native functions; explicit pointer types avoid address truncation
        self.copy_exclusions = self.bind(
            self.metadata, "_MDCopyExclusionList", [], ctypes.c_void_p
        )
        self.set_exclusion = self.bind(
            self.metadata, "_MDSetExclusion",
            [ctypes.c_void_p, ctypes.c_uint], ctypes.c_int
        )
        self.array_count = self.bind(
            self.core, "CFArrayGetCount", [ctypes.c_void_p], ctypes.c_long
        )
        self.array_value = self.bind(
            self.core, "CFArrayGetValueAtIndex",
            [ctypes.c_void_p, ctypes.c_long], ctypes.c_void_p
        )
        self.create_string = self.bind(
            self.core, "CFStringCreateWithCString",
            [ctypes.c_void_p, ctypes.c_char_p, ctypes.c_uint32], ctypes.c_void_p
        )
        self.string_length = self.bind(
            self.core, "CFStringGetLength", [ctypes.c_void_p], ctypes.c_long
        )
        self.string_bytes = self.bind(
            self.core, "CFStringGetCString",
            [ctypes.c_void_p, ctypes.c_void_p, ctypes.c_long, ctypes.c_uint32],
            ctypes.c_bool
        )
        self.release = self.bind(
            self.core, "CFRelease", [ctypes.c_void_p], None
        )

    # Declare a native function so pointer values aren't truncated to integers
    @staticmethod
    def bind(library, name, arguments, result):
        # The function exported by the given system library
        function = getattr(library, name)
        function.argtypes = arguments
        function.restype = result
        return function

    # Return the live service's exclusion paths without requiring sudo
    def exclusions(self):
        # The owned CFArray returned by Metadata; its strings are borrowed
        array = self.copy_exclusions()
        if not array:
            raise RuntimeError("Spotlight didn't return an exclusion list")
        try:
            # The paths returned by the service, rather than search results
            paths = set()
            # Each borrowed CFString in the native array
            for index in range(self.array_count(array)):
                # The path and enough space for its UTF-8 representation
                value = self.array_value(array, index)
                buffer = ctypes.create_string_buffer(
                    self.string_length(value) * 4 + 1
                )
                if not self.string_bytes(value, buffer, len(buffer), 0x08000100):
                    raise RuntimeError("Couldn't decode a Spotlight path")
                paths.add(normalize_path(buffer.value.decode("utf-8")))
            return paths
        finally:
            self.release(array)

    # Add or remove the given path through the native Spotlight service
    def set_excluded(self, path, excluded):
        # A native UTF-8 string; 0x08000100 is kCFStringEncodingUTF8
        value = self.create_string(
            None, normalize_path(path).encode("utf-8"), 0x08000100
        )
        if not value:
            raise RuntimeError("Couldn't create a native path string")
        try:
            # Settings uses 1 to add an exclusion and 0 to remove one
            status = self.set_exclusion(value, int(excluded))
            if status != 0:
                raise RuntimeError(
                    f"Spotlight rejected {path} (status {status})"
                )
        finally:
            self.release(value)


# Resolve symlinks as Settings does; compare macOS's decomposed Unicode paths
def normalize_path(path):
    return unicodedata.normalize("NFD", os.path.realpath(path))


# Expand directory patterns without hiding permission or other discovery errors
def match_directories(directory, components):
    try:
        if not components:
            if stat.S_ISDIR(os.stat(directory).st_mode):
                yield normalize_path(directory)
            return
        # The next path component and the components that follow it
        component, *remaining = components
        if not any(character in component for character in "*?["):
            yield from match_directories(
                os.path.join(directory, component), remaining
            )
            return
        if component == "**":
            yield from match_directories(directory, remaining)
        with os.scandir(directory) as entries:
            # Each filesystem entry considered by this wildcard component
            for entry in entries:
                if entry.name.startswith(".") and not component.startswith("."):
                    continue
                if component == "**":
                    if entry.is_dir():
                        yield from match_directories(entry.path, components)
                elif fnmatch.fnmatchcase(entry.name, component):
                    yield from match_directories(entry.path, remaining)
    except (FileNotFoundError, NotADirectoryError):
        # Missing folders are valid zero matches; other errors must stop sync
        return


# Expand the existing patterns; ignore comments and overlapping matches
def get_exclusion_paths(list_path):
    # Unique existing directories matched by the user's pattern file
    paths = set()
    with open(list_path, encoding="utf-8") as exclusions:
        # Each line is a whole glob pattern, so paths can contain spaces
        for line in exclusions:
            # The pattern after removing surrounding whitespace
            pattern = line.strip()
            if not pattern or pattern.startswith("#"):
                continue
            # Existing folders matching this pattern
            matches = list(match_directories(
                os.path.sep,
                os.path.abspath(os.path.expanduser(pattern)).split(os.path.sep)[1:]
            ))
            if not matches:
                print(f"No matching directories: {pattern}", file=sys.stderr)
            paths.update(matches)
    return sorted(paths)


# Check whether the directory itself or one of its parents is excluded
def is_excluded(path, exclusions):
    return any(
        path == excluded or path.startswith(excluded.rstrip("/") + "/")
        for excluded in exclusions
    )


# Search each parent once per verification, even if several children are excluded
@functools.lru_cache(maxsize=None)
def get_indexed_paths(parent):
    # Query the parent so an excluded scope can't hide stale descendant results
    # Newly imported files can have a display name before an FSName is available
    result = subprocess.run(
        ["/usr/bin/mdfind", "-0", "-onlyin", parent,
         'kMDItemFSName != "" || kMDItemDisplayName != ""'],
        capture_output=True, check=True
    )
    return [os.fsdecode(child) for child in result.stdout.split(b"\0") if child]


# Return indexed descendants; the excluded directory itself may remain visible
def get_indexed_children(path):
    return [
        child for child in get_indexed_paths(os.path.dirname(path))
        if child.startswith(path.rstrip("/") + "/")
    ]


# Check service registration and search results independently for every folder
def verify_exclusions(spotlight, paths, exact=False):
    print("Verifying Spotlight exclusions; this may take a moment...", flush=True)
    # Clear results from an earlier check if the caller changed exclusions
    get_indexed_paths.cache_clear()
    # The current native list and the number of folders that failed verification
    exclusions = spotlight.exclusions()
    failures = 0
    # Each directory requested by the user's patterns
    for path in paths:
        if (path not in exclusions if exact else not is_excluded(path, exclusions)):
            print(f"NOT REGISTERED: {path}", file=sys.stderr)
            failures += 1
            continue
        # Actual indexed descendants, rather than the folder's own entry
        children = get_indexed_children(path)
        if children:
            print(
                f"STILL SEARCHABLE: {path} ({len(children)} descendants; "
                f"e.g. {children[0]})", file=sys.stderr
            )
            failures += 1
    if exact:
        # Saved exclusions that aren't part of the canonical resolved folder set
        unexpected = sorted(exclusions - set(paths))
        # Each extra entry that should have been removed by sync
        for path in unexpected:
            print(f"UNEXPECTED EXCLUSION: {path}", file=sys.stderr)
        failures += len(unexpected)
    print(f"Checked {len(paths)} directories; {failures} failed verification")
    return failures == 0


# Start the same asynchronous index rebuild for explicit and prompted requests
def rebuild_index(check_command):
    print(
        "Starting a Spotlight index rebuild for the Data volume; "
        "sudo may ask for your administrator password.",
        flush=True
    )
    subprocess.run(
        ["/usr/bin/sudo", "/usr/bin/mdutil", "-E", "/System/Volumes/Data"],
        check=True
    )
    # Empty search results during rebuilding aren't proof of working exclusions
    print(
        "The rebuild was requested. Search results may be incomplete until "
        f"it finishes. Afterward, run {check_command} to verify your exclusions."
    )


# Ask before rebuilding; an empty response or closed input means no
def confirm_rebuild():
    while True:
        try:
            # The user's response, with surrounding spaces and case ignored
            answer = input("Rebuild the Spotlight index now? [y/N]: ").strip().lower()
        except EOFError:
            print()
            return False
        if answer in ("y", "yes"):
            return True
        if answer in ("", "n", "no"):
            return False
        print("Please enter y or n.")


# Read the CLI options without opening Finder or System Settings
def parse_cli_args():
    # The script's input file and optional preview, check, or rebuild mode
    parser = argparse.ArgumentParser(
        description=__doc__,
        epilog=(
            "With no options, add any missing folder exclusions and check that "
            "their contents no longer appear in Spotlight searches. If "
            "verification fails, offer to rebuild the index."
        )
    )
    parser.add_argument(
        "exclusions_list_path", nargs="?", default=DEFAULT_EXCLUSIONS_LIST_PATH,
        metavar="exclusions-file",
        help="Text file containing folder paths and patterns (default: %(default)s)"
    )
    parser.add_argument(
        "--sync", action="store_true",
        help=(
            "Make Spotlight's exclusion list match the existing folders in "
            "your patterns; remove all other saved exclusions. Combine with "
            "--dry-run to preview or --check to verify without changes"
        )
    )
    # Read-only modes can't also request a change to the index
    modes = parser.add_mutually_exclusive_group()
    modes.add_argument(
        "--dry-run", action="store_true",
        help=(
            "Show which exclusions would be added (and removed with --sync); "
            "don't change anything"
        )
    )
    modes.add_argument(
        "--check", action="store_true",
        help=(
            "Check that matching folders are excluded and their contents no "
            "longer appear in Spotlight searches; don't change anything"
        )
    )
    modes.add_argument(
        "--rebuild-index", action="store_true",
        help=(
            "Add missing folder exclusions, then erase and rebuild the Data "
            "volume's Spotlight index; may ask for your administrator password"
        )
    )
    return parser.parse_args()


# Apply additions and optional removals, then check the resulting search behavior
def main():
    # The requested input, matching directories, and native Spotlight connection
    args = parse_cli_args()
    # The follow-up command that preserves exact checking when sync is selected
    check_command = (
        "setup_spotlight.py --sync --check" if args.sync
        else "setup_spotlight.py --check"
    )
    paths = get_exclusion_paths(args.exclusions_list_path)
    if not paths:
        raise RuntimeError("No directories matched; no exclusions were changed")
    spotlight = Spotlight()
    if args.check:
        return 0 if verify_exclusions(spotlight, paths, exact=args.sync) else 1
    # Existing exclusions remain authoritative, even if a folder is searchable
    exclusions = spotlight.exclusions()
    # The directories not already covered by a saved exclusion
    missing = [
        path for path in paths
        if (path not in exclusions if args.sync
            else not is_excluded(path, exclusions))
    ]
    # Only sync removes exclusions; the default command preserves other entries
    removals = sorted(exclusions - set(paths)) if args.sync else []
    if args.dry_run:
        # Each directory that would be added to Spotlight's live exclusion list
        for path in missing:
            print(f"Would exclude: {path}")
        # Each saved exclusion that sync would remove
        for path in removals:
            print(f"Would remove exclusion: {path}")
        print(
            f"{len(paths)} matched directories; {len(missing)} additions; "
            f"{len(removals)} removals"
        )
        return 0
    # Each missing directory; stop immediately if the service rejects a change
    for path in missing:
        spotlight.set_excluded(path, True)
        if path not in spotlight.exclusions():
            raise RuntimeError(f"Spotlight didn't register the exclusion: {path}")
        # The user's home folder and a shorter path for the status message
        home = os.path.expanduser("~")
        display_path = path
        if path == home or path.startswith(home + "/"):
            display_path = "~" + path[len(home):]
        print(f"Excluded: {display_path}", flush=True)
    # Add the desired children before removing an old parent exclusion
    for path in removals:
        spotlight.set_excluded(path, False)
        if path in spotlight.exclusions():
            raise RuntimeError(f"Spotlight didn't remove the exclusion: {path}")
        print(f"Removed exclusion: {path}", flush=True)
    if args.sync and spotlight.exclusions() != set(paths):
        raise RuntimeError(
            "Spotlight's exclusion list doesn't match the resolved folders; "
            "run setup_spotlight.py --sync --check for details"
        )
    if args.rebuild_index:
        rebuild_index(check_command)
        return 0
    # Let the service process new operations before checking search results
    if missing or removals:
        time.sleep(2)
    if not verify_exclusions(spotlight, paths, exact=args.sync):
        print(
            f"Exclusions haven't taken full effect; run {check_command} later. "
            "No index rebuild or service restart was performed.",
            file=sys.stderr
        )
        if confirm_rebuild():
            rebuild_index(check_command)
            return 0
        return 1
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (OSError, AttributeError, RuntimeError,
            subprocess.CalledProcessError) as error:
        print(f"Spotlight setup failed: {error}", file=sys.stderr)
        sys.exit(1)
