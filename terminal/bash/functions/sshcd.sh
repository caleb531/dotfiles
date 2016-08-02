#!/usr/bin/env bash

source ~/.dotfiles/terminal/bash/functions/getenv.sh

sshcd() {
	local current_env="$(getenv)"
	if [ -n "$current_env" ]; then
		source "$current_env"
		if [ -n "$REMOTE_ROOT" ]; then
			local local_root="$(dirname "$current_env")"
			local remote_pwd="${PWD/#$local_root/$REMOTE_ROOT}"
			ssh -tp "$SSH_PORT" "$SSH_USER"@"$SSH_HOSTNAME" "cd $remote_pwd; bash"
		else
			>&2 echo "Directory has no remote counterpart!"
		fi
	else
		>&2 echo "Directory has no remote environment set!"
	fi
}

sshcd
