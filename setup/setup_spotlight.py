#!/usr/bin/env python3

import argparse
import contextlib
import functools
import glob
import hashlib
import os
import os.path
import shutil
import subprocess
import sys

DEFAULT_EXCLUSIONS_LIST_PATH = os.path.expanduser(
    os.path.join("~", "dotfiles", "private", "setup", "spotlight-exclusions.txt")
)
EXCLUSIONS_SYMLINK_DIR = os.path.expanduser(os.path.join("~", "spotlight-exclusions"))


@functools.lru_cache()
def get_indexed_paths(name):
    return (
        subprocess.check_output(["mdfind", "-name", name])
        .decode("utf-8")
        .strip()
        .split("\n")
    )


def is_indexed(exclusion_path):
    basename = os.path.basename(exclusion_path)
    return exclusion_path in get_indexed_paths(basename)


def get_symlink_checksum(exclusion_path):
    return hashlib.md5(exclusion_path.encode("utf-8")).hexdigest()


def get_symlink_filename(exclusion_path):
    return os.path.join(
        EXCLUSIONS_SYMLINK_DIR,
        "{}-{}".format(
            os.path.basename(exclusion_path), get_symlink_checksum(exclusion_path)
        ),
    )


def process_exclusion(exclusion_glob):
    did_run = False
    exclusion_glob = os.path.expanduser(exclusion_glob)
    for exclusion_path in glob.iglob(exclusion_glob, recursive=True):
        did_run = True
        with contextlib.suppress(OSError):
            if os.path.isdir(exclusion_path) and is_indexed(exclusion_path):
                os.symlink(exclusion_path, get_symlink_filename(exclusion_path))
                print(exclusion_path.replace(os.path.expanduser("~"), "~"))
    if not did_run:
        print(
            "No matches found: {}".format(
                exclusion_glob.replace(os.path.expanduser("~"), "~")
            ),
            file=sys.stderr,
        )


def recreate_symlink_directory():
    shutil.rmtree(EXCLUSIONS_SYMLINK_DIR, ignore_errors=True)
    with contextlib.suppress(OSError):
        os.makedirs(EXCLUSIONS_SYMLINK_DIR)


def process_exclusions(exclusion_globs):
    recreate_symlink_directory()
    for exclusion_glob in exclusion_globs:
        if exclusion_glob.strip():
            process_exclusion(exclusion_glob.strip().rstrip("/"))


def parse_cli_args():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "exclusions_list_path", nargs="?", default=DEFAULT_EXCLUSIONS_LIST_PATH
    )
    return parser.parse_args()


def main():
    cli_args = parse_cli_args()

    with open(cli_args.exclusions_list_path, "r") as exclusions_list_file:
        process_exclusions(exclusions_list_file.readlines())
    if os.listdir(EXCLUSIONS_SYMLINK_DIR):
        subprocess.call(["open", EXCLUSIONS_SYMLINK_DIR])


if __name__ == "__main__":
    main()
