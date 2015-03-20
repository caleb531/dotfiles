#!/bin/bash
# bash_config.sh
# Caleb Evans

# Navigate history matching typed input using up/down arrow keys
bind '"\e[A": history-search-backward' 2> /dev/null
bind '"\e[B": history-search-forward' 2> /dev/null

# If shell is Bash 4 or newer
if [ $BASH_VERSINFO -ge 4 ]; then

	# If Bash Completion is installed
	if [ -f /usr/local/share/bash-completion/bash_completion ]; then
		# Load completions
		source /usr/local/share/bash-completion/bash_completion
	fi

fi

# Limitations on system resources

# Increase open files limit
ulimit -n 1024 2> /dev/null
# Increase available processes limit
ulimit -u 1024 2> /dev/null
