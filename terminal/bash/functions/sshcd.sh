#!/usr/bin/env bash

source ~/dotfiles/terminal/bash/functions/helper_functions.sh

sshcd() {
	if __source_env; then
		local remote_pwd="$(__get_remote_pwd)"
	fi
	if [ -n "$remote_pwd" ]; then
		ssh -tp "$SSH_PORT" "$SSH_USER"@"$SSH_HOSTNAME" "cd $remote_pwd; bash"
	else
		return 1
	fi
}

sshcd
