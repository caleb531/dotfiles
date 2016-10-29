#!/usr/bin/env bash

# Get the name of the nearest non-sourced executing parent script
__get_script_name() {
	echo $(basename "${0/%.sh/}")
}

# Find the nearest .env file and loads it into the current shell;
# the local root is the nearest directory defining an environment via .env
__get_env() {
	local local_root="$PWD"
	# Find nearest .env, searching parent directories until one is found
	while [ ! -f "$local_root"/.env -a "$local_root" != / ]; do
		local_root="$(dirname "$local_root")"
	done
	# If .env file exists at this point (otherwise, no parent has an .env)
	if [ -f "$local_root"/.env ]; then
		echo "$local_root"/.env
	else
		>&2 echo "$(__get_script_name): directory has no remote environment set"
	fi
}

# Source the nearest .env file
__source_env() {
	local current_env="$(__get_env)"
	if [ -n "$current_env" ]; then
		source "$current_env"
		CURRENT_ENV="$current_env"
	fi
}

# Retrieve the corresponding remote PWD (assuming the directory's relevant .env
# has already been sourced)
__get_remote_pwd() {
	if [ -n "$REMOTE_ROOT" ]; then
		local local_root="$(dirname "$CURRENT_ENV")"
		local remote_pwd="${PWD/#$local_root/$REMOTE_ROOT}"
		echo "$remote_pwd"
	else
		>&2 echo "$(__get_script_name): environment has no remote root directory set"
	fi
}
