#!/usr/bin/env bash

# Return code 0 if the current working directory is a Node project or a
# subdirectory thereof; return code 1 otherwise
__is_node_project() {
	if ! type node &> /dev/null; then
		return 1
	fi
	local path="$PWD"
	while [[ "$path" != '/' ]]; do
		if [ -f "$path"/package.json ]; then
			return 0
		fi
		path="$(dirname "$path")"
	done
	return 1
}


# Return code 0 if the current working directory is a Python project that uses
# the 'build' package
__is_python_build_project() {
	if ! ls .virtualenv/lib/python*/site-packages/build &> /dev/null; then
		return 1
	fi
	if ! ls .venv/lib/python*/site-packages/uv &> /dev/null; then
		return 1
	fi
	local path="$PWD"
	while [[ "$path" != '/' ]]; do
		if [ -f "$path"/pyproject.toml ] || [ -f "$path"/setup.py ]; then
			return 0
		fi
		path="$(dirname "$path")"
	done
	return 1
}
