#!/bin/bash
# bash_aliases.sh
# Caleb Evans

# Enable aliases to be run as root
alias sudo='sudo '

# Reloads .bash_profile
alias reload='exec $SHELL -l'

# Colorize directory listings
alias ls='ls --color=auto'

# Colorize grep matches

# --color=auto does not colorize piped output
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# If tree package is installed
if type tree &> /dev/null; then
	# Colorize tree output
	alias tree='tree -C'
fi
