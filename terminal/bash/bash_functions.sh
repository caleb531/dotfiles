#!/bin/bash
# bash_functions.sh
# Caleb Evans

# Reloads entire shell, including .bash_profile and any activated virtualenv
reload() {
	deactivate 2> /dev/null
	exec $SHELL -l
}

# Make new Python virtualenv in designated virtualenv home
mkenv() {
	local env_name="$(basename "$PWD")"
	pushd "$WORKON_HOME" &> /dev/null
	virtualenv -p "$1" "$env_name"
	popd &> /dev/null
}

# Remove an existing Python virtualenv
rmenv() {
	rm -r "$WORKON_HOME"/"$(basename "$PWD")"
}
