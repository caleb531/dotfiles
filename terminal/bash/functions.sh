#!/usr/bin/env bash
# functions.sh
# Caleb Evans

# Reload entire shell, including .bash_profile and any activated virtualenv
# Usage: reload
reload() {
	deactivate 2> /dev/null
	exec $SHELL -l
}

# Remove last command from Bash history
# Usage: rmlastcmd
rmlastcmd() {
	local last_cmd_offset="$(history | tail -n 1 | awk '{print $1;}')"
	history -d "$last_cmd_offset"
}

# Make new Python virtualenv for current directory
# Usage: mkvirtualenv PYTHON
# PYTHON is the name of a python executable (typically python2 or python3)
mkvirtualenv() {
	virtualenv --python="$1" "$VIRTUAL_ENV_NAME"
	# Activate virtualenv so packages can be installed
	source ./"$VIRTUAL_ENV_NAME"/bin/activate
}

# Remove existing Python virtualenv
# Usage: rmvirtualenv
rmvirtualenv() {
	rm -r ./"$VIRTUAL_ENV_NAME"
}

# Provide convenient access to common PyPI commands
# Usage: pypi [register|test|upload]
pypi() {
	if [ "$1" == 'test' ]; then
		python setup.py register -r pypitest
		python setup.py sdist upload -r pypitest
	elif [ "$1" == 'register' ]; then
		python setup.py register -r pypi
	elif [ "$1" == 'upload' ]; then
		python setup.py sdist upload -r pypi
	fi
}

# Flush all DNS caches for OS X 10.10.4 and onward
# Usage: flushdns
flushdns() {
	sudo dscacheutil -flushcache
	sudo killall -HUP mDNSResponder
}

# Remove public SSH key from server
# Usage: ssh-remove-id -p <port> <user>@<hostname>
ssh-remove-id() {
	# Retrieve local public key and escape relevant regex characters
	local pub_key="$(grep -Po --color=none 'ssh-rsa [A-Za-z0-9\/\+]+' < ~/.ssh/id_rsa.pub)"
	local escaped_pub_key="$(echo "$pub_key" | sed -e 's/[\/+]/\\&/g')"
	# Remove authorized key on server by executing script via SSH
	ssh "$@" bash -s - "$pub_key" < ~/.dotfiles/terminal/bash/functions/ssh-remove-id.sh
}

# Copies changed items in current directory to corresponding directory on remote
# server; an .env file containing the below environment variables must be
# present in said directory or one of its parent directories
# Required environment variables: SSH_USER, SSH_HOSTNAME, SSH_PORT, REMOTE_ROOT
# Usage: deploy
deploy() {
	~/.dotfiles/terminal/bash/functions/deploy.sh
}

# Control MAMP (mainly Apache and MySQL servers)
mamp() {
	if [ -z "$1" -o "$1" == start ]; then
		/Applications/MAMP/bin/start.sh > /dev/null
	elif [ "$1" == stop ]; then
		/Applications/MAMP/bin/stop.sh > /dev/null
	elif [ "$1" == restart ]; then
		/Applications/MAMP/bin/stop.sh > /dev/null
		/Applications/MAMP/bin/start.sh > /dev/null
	fi
}

# Control MAMP's Apache server
apachectl() {
	if [ -z "$@" ]; then
		# Run Apache as foreground process if no arguments are given
		/Applications/MAMP/Library/bin/apachectl -DFOREGROUND
	else
		# Otherwise, run apachectl normally via given arguments
		/Applications/MAMP/Library/bin/apachectl "$@"
	fi
}

# List all local Atom packages on this system (much faster than `apm ls`)
__apm_ls() {
	ls --color=never -1 ~/.atom/packages
}

# Return a diff between the local Atom package list and the remote package list
__apm_diff() {
	__apm_ls | diff - ~/.atom/packages.txt
}

# Bring local Atom package list into sync with remote package list
# Usage: apm pull
__apm_pull() {
	local pkg_diff="$(__apm_diff)"
	if [ -n "$pkg_diff" ]; then
		# Uninstall local packages that are missing on remote
		local removed_pkgs="$(echo "$pkg_diff" | grep -Po '(?<=\< )[a-z0-9\-]+')"
		while read -r pkg; do
			command apm uninstall "$pkg"
		done <<< "$removed_pkgs"
		# Install remote packages that are missing on local
		local added_pkgs="$(echo "$pkg_diff" | grep -Po '(?<=\> )[a-z0-9\-]+')"
		while read -r pkg; do
			command apm install "$pkg"
		done <<< "$added_pkgs"
	fi
}

# Push list of local Atom packages to the remote package list
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
		command apm "$@"
		__apm_push
	elif [ "$1" == pull ]; then
		__apm_pull
	elif [ "$1" == push ]; then
		__apm_push
	else
		command apm "$@"
	fi
}
