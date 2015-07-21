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

# Remake Python virtualenv belonging to CWD and reinstall pip requirements
rmkenv() {
	if [ -f "$VIRTUAL_ENV/bin/python3" ]; then
		local binary=python3
	elif [ -f "$VIRTUAL_ENV/bin/python2" ]; then
		local binary=python2
	fi
	if [ ! -z "$binary" ]; then
		rmenv
		mkenv "$binary"
	fi
}

# Upgrade any and all outdated pip packages
pip-upgrade-all() {
	local pkgs="$(pip list --outdated | awk '{print $1}')"
	if [ ! -z $pkgs ]; then
		pip install --upgrade $pkgs
	fi
}

# Reclone a git repository
git-reclone() {
	# If there are no uncommitted changes
	if [ -z "$(git status --porcelain)" ]; then
		local reponame="$(basename "$PWD")"
		local remote="$(git config --get remote.origin.url)"
		pushd .. > /dev/null
		# Delete and recreate repository directory with same name
		rm -rf "$reponame"
		mkdir "$reponame"
		popd > /dev/null
		# Reclone contents of remote repository into recreated local repository
		git clone "$remote" .
	else
		echo "There are uncommitted changes; please commit and push them before recloning."
	fi
}
