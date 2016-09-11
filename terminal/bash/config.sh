#!/usr/bin/env bash
# config.sh
# Caleb Evans

# Expand multiple subdirectories using the globstar (**) option
shopt -s globstar 2> /dev/null
# Ensure that command history is appended to and not overwritten
shopt -s histappend

# Navigate command history matching typed input using up/down arrow keys
bind '"\e[A": history-search-backward' 2> /dev/null
bind '"\e[B": history-search-forward' 2> /dev/null

# If shell is Bash 4 or newer
if [ $BASH_VERSINFO -ge 4 ]; then

	# If Bash Completion is installed
	if [ -f /usr/local/share/bash-completion/bash_completion ]; then
		# Load all completions
		source /usr/local/share/bash-completion/bash_completion
	fi

fi

# Set limitations on system resources (uncomment if you experience issues)

# Increase open files limit
# ulimit -n 1024 2> /dev/null
# Increase available processes limit
# ulimit -u 1024 2> /dev/null

# Remember GPG key passphrase

if [ -f ~/.gnupg/.gpg-agent-info -a -n "$(pgrep gpg-agent)" ]; then
	source ~/.gnupg/.gpg-agent-info
	export GPG_AGENT_INFO
else
	eval $(gpg-agent --daemon --write-env-file ~/.gnupg/.gpg-agent-info)
fi
