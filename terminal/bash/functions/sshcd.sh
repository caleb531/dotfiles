#!/usr/bin/env bash

source ~/dotfiles/terminal/bash/functions/helper_functions.sh

sshcd() {
	__source_env
	local remote_pwd="$(__get_remote_pwd)"
	if [ -n "$remote_pwd" ]; then
		ssh -tp "$SSH_PORT" "$SSH_USER"@"$SSH_HOSTNAME" "cd $remote_pwd; bash"
	fi
}

sshcd
