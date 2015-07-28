#!/bin/bash
# functions.sh
# Caleb Evans

# Reloads entire shell, including .bash_profile and any activated virtualenv
reload() {
	deactivate 2> /dev/null
	exec $SHELL -l
}

# Makes new Python virtualenv for current directory
mkenv() {
	local envname="$(basename "$PWD")"
	pushd "$WORKON_HOME" > /dev/null
	virtualenv -p "$1" "$envname"
	popd > /dev/null
	# Activate virtualenv so packages can be installed
	source "$WORKON_HOME/$envname"/bin/activate
}

# Removes existing Python virtualenv
rmenv() {
	rm -r "$WORKON_HOME"/"$(basename "$PWD")"
}
