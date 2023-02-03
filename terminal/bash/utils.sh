#!/usr/bin/env bash

# Return code 0 if the current working directory is a Node project or a
# subdirectory thereof; return code 1 otherwise
__is_node_project() {
	if ! type node &> /dev/null; then
		return 1
	fi
	while [ "$PWD" != / ]; do
		if [ -f package.json ]; then
			return 0
		fi
		cd ..
	done
	return 1
}
