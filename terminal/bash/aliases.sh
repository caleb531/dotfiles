#!/usr/bin/env bash
# aliases.sh
# Caleb Evans

# Enable aliases to be run as root
alias sudo='sudo '

# Colorize directory listings
alias ls='ls --color=auto'

# Output the octal permissions for a file or directory
alias octmod='stat -c %a'

# Colorize grep matches (but not for piped output)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Colorize diff output
if type colordiff &> /dev/null; then
	alias diff='colordiff'
fi

# Colorize tree output
if type tree &> /dev/null; then
	alias tree='tree -C'
fi

# Upload to PyPI
alias pypi-upload='python setup.py sdist upload -r pypi'
