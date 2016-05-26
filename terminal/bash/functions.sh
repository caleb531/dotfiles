#!/usr/bin/env bash
# functions.sh
# Caleb Evans

# Reloads entire shell, including .bash_profile and any activated virtualenv
# Usage: reload
reload() {
	deactivate 2> /dev/null
	exec $SHELL -l
}

# Removes last command from Bash history
# Usage: rmlastcmd
rmlastcmd() {
	local last_cmd_offset="$(history | tail -n 1 | awk '{print $1;}')"
	history -d "$last_cmd_offset"
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
			/usr/local/bin/apm uninstall "$pkg"
		done <<< "$removed_pkgs"
		# Install remote packages that are missing on local
		local added_pkgs="$(echo "$pkg_diff" | grep -Po '(?<=\> )[a-z0-9\-]+')"
		while read -r pkg; do
			/usr/local/bin/apm install "$pkg"
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

# Removes public SSH key from server
# Usage: ssh-remove-id -p <port> <user>@<hostname>
ssh-remove-id() {
	# Retrieve local public key and escape relevant regex characters
	local pub_key="$(grep -Po --color=none 'ssh-rsa [A-Za-z0-9\/\+]+' < ~/.ssh/id_rsa.pub)"
	local escaped_pub_key="$(echo "$pub_key" | sed -e 's/[\/+]/\\&/g')"
	# Remove authorized key on server by executing script via SSH
	ssh "$@" bash -s - "$pub_key" < ~/.dotfiles/terminal/bash/ssh-remove-id.sh
}

# Flushes DNS caches
# Usage: flushdns
flushdns() {
	dscacheutil -flushcache
	sudo killall -HUP mDNSResponder
}

# Finds the nearest .env file and loads it into the current shell;
# the local root is the nearest directory defining an environment via .env
# Usage: get-env
get-env() {
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

# Brings the current directory's remote counterpart into sync with said current
# directory; an .env file containing the below environment variables must be
# present in said directory or one of its parent directories
# Required environment variables: SSH_USER, SSH_HOSTNAME, SSH_PORT, REMOTE_ROOT
# Usage: personal-sync
personal-sync() {
	local current_env="$(get-env)"
	if [ -n "$current_env" ]; then
		source "$current_env"
		LOCAL_ROOT="$(dirname "$current_env")"
		local local_pwd="$PWD"
		local remote_pwd="${local_pwd/#$LOCAL_ROOT/$REMOTE_ROOT}"
		rsync \
		  --archive \
		  --checksum \
		  --rsh "ssh -p $SSH_PORT" \
		  --verbose \
		  "$local_pwd"/ \
		  "$SSH_USER"@"$SSH_HOSTNAME":"$remote_pwd"
	fi
}
