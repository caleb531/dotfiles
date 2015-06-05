#!/bin/bash
# bash_functions.sh
# Caleb Evans

# Make new Python virtualenv in designated virtualenv home
mkenv() {
	pushd "$WORKON_HOME" &> /dev/null
	virtualenv -p "$1" "$(basename "$PWD")"
	popd &> /dev/null
}

# Remove an existing Python virtualenv
rmenv() {
	rm -r "$WORKON_HOME"/"$(basename "$PWD")"
}
