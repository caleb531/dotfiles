#!/bin/bash
# bash_functions.sh
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
	# Activate virtualenv and install pip requirements if possible
	source "$WORKON_HOME/$envname"/bin/activate
	pip install -r requirements.txt 2> /dev/null
}

# Removes existing Python virtualenv
rmenv() {
	rm -r "$WORKON_HOME"/"$(basename "$PWD")"
}

# Upgrades any and all outdated pip packages
pip-upgrade-all() {
	local pkgs="$(pip list --outdated | awk '{print $1}')"
	if [ ! -z "$pkgs" ]; then
		pip install --upgrade $pkgs
	fi
}
