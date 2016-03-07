#!/usr/bin/env bash
# functions.sh
# Caleb Evans

# Reloads entire shell, including .bash_profile and any activated virtualenv
# Usage: reload
reload() {
	deactivate 2> /dev/null
	exec $SHELL -l
}

# Makes new Python virtualenv for current directory
# Usage: mkvirtualenv PYTHON
# PYTHON is the name of a python executable (typically python2 or python3)
mkvirtualenv() {
	virtualenv --python="$1" "$VIRTUAL_ENV_NAME"
	# Activate virtualenv so packages can be installed
	source ./"$VIRTUAL_ENV_NAME"/bin/activate
}

# Removes existing Python virtualenv
# Usage: rmvirtualenv
rmvirtualenv() {
	rm -r ./"$VIRTUAL_ENV_NAME"
}

# Flushes all DNS caches for OS X 10.10.4 and onward
# Usage: flushdns
flushdns() {
	sudo dscacheutil -flushcache
	sudo killall -HUP mDNSResponder
}

# Generates a dummy file of any size
# Usage: genfile --size SIZE FILEPATH
# Size must be an integer ending in 'K' or 'M' (I wouldn't dare try 'G')
genfile() {
	if [ $1 == '--size' ]; then
		local filesize="$2"
		local filepath="$3"
	elif [ "$2" == '--size' ]; then
		local filepath="$1"
		local filesize="$3"
	fi
	dd if=/dev/zero of="$filepath" bs="$filesize" count=1
}

# Lists all local Atom packages on this system (much faster than `apm ls`)
__apm_ls() {
	ls --color=never -1 ~/.atom/packages
}

# Returns a diff between the local Atom package list and the remote package list
__apm_diff() {
	__apm_ls | diff - ~/.atom/packages.txt
}

# Brings local Atom package list into sync with remote package list
# Usage: apm pull
__apm_pull() {
	local pkg_diff="$(__apm_diff)"
	if [ -n "$pkg_diff" ]; then
		# Uninstall local packages that are missing on remote
		local removed_pkgs="$(echo "$pkg_diff" | grep -Po '(?<=\< )[a-z0-9\-]+')"
		while read -r pkg; do
			if [ -n "$pkg" ]; then
				/usr/local/bin/apm uninstall "$pkg"
			fi
		done <<< "$removed_pkgs"
		# Install remote packages that are missing on local
		local added_pkgs="$(echo "$pkg_diff" | grep -Po '(?<=\> )[a-z0-9\-]+')"
		while read -r pkg; do
			if [ -n "$pkg" ]; then
				/usr/local/bin/apm install "$pkg"
			fi
		done <<< "$added_pkgs"
	fi
}

# Pushes list of local Atom packages to the remote package list
# Usage: apm push
__apm_push() {
	# Only push if local package list differs from remote package list
	if [ -n "$(__apm_diff)" ]; then
		echo "Pushing local package list to remote..."
		local remote_pkgs="$(readlink -f ~/.atom/packages.txt)"
		__apm_ls > "$remote_pkgs"
	fi
}

# Override apm command to integrate custom push and pull commands
apm() {
	if [ "$1" == install -o "$1" == uninstall ]; then
		__apm_pull
		/usr/local/bin/apm "$@"
		__apm_push
	elif [ "$1" == pull ]; then
		__apm_pull
	elif [ "$1" == push ]; then
		__apm_push
	else
		/usr/local/bin/apm "$@"
	fi
}
