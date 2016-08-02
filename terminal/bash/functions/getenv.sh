#!/usr/bin/env bash

# Find the nearest .env file and loads it into the current shell;
# the local root is the nearest directory defining an environment via .env
getenv() {
	local local_root="$PWD"
	# Find nearest .env, searching parent directories until one is found
	while [ ! -f "$local_root"/.env -a "$local_root" != / ]; do
		local_root="$(dirname "$local_root")"
	done
	# If .env file exists at this point (otherwise, no parent has an .env)
	if [ -f "$local_root"/.env ]; then
		echo "$local_root"/.env
	fi
}
