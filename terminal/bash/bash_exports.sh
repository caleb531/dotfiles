#!/bin/bash
# bash_exports.sh
# Caleb Evans

# Ensure installed packages are recognized and preferred

# GNU core utilities
if [ -d /usr/local/opt/coreutils/libexec/gnubin ]; then
	export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH
	export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:$MANPATH
fi
# Ruby gems
if [ -d /usr/local/opt/ruby/bin ]; then
	export PATH=/usr/local/opt/ruby/bin:$PATH
fi

# Colorize less
# Color syntax: http://www.termsys.demon.co.uk/vtansi.htm#colors
# termcap(5) man page: http://linux.die.net/man/5/termcap
export LESS_TERMCAP_md=$'\e[1;34m'	# start bold mode
export LESS_TERMCAP_me=$'\e[1;0m'	# end modes so, us, mb, md, mr
export LESS_TERMCAP_so=$'\e[1;31m'	# start standout mode
export LESS_TERMCAP_se=$'\e[1;0m'	# end standout mode
export LESS_TERMCAP_us=$'\e[1;32m'	# start underlining
export LESS_TERMCAP_ue=$'\e[1;0m'	# end underlining

# Miscellaneous environment variables

# Explicitly declare vim as default text editor
export EDITOR='vim'
# Explicitly declare less as default pager
export PAGER='less'

# Number of lines of command history to keep in memory
export HISTSIZE=250
# Number of lines of command history to keep in file
export HISTFILESIZE=500
# Prevent duplicate entries in command history
export HISTCONTROL=ignoredups:erasedups

# Prevent Python from generating bytecode files
export PYTHONDONTWRITEBYTECODE=1

# Use /Applications for apps installed with Homebrew Cask
export HOMEBREW_CASK_OPTS='--appdir=/Applications'

# Colors
# ANSI color reference: http://www.termsys.demon.co.uk/vtansi.htm#colors

# Standard colors
export BLACK='0;30'
export RED='0;31'
export GREEN='0;32'
export YELLOW='0;33'
export BLUE='0;34'
export PURPLE='0;35'
export CYAN='0;36'
export WHITE='0;37'

# Bold colors
export BLACK_BOLD='1;30'
export RED_BOLD='1;31'
export GREEN_BOLD='1;32'
export YELLOW_BOLD='1;33'
export BLUE_BOLD='1;34'
export PURPLE_BOLD='1;35'
export CYAN_BOLD='1;36'
export WHITE_BOLD='1;37'

# Use green, underlined text for grep matches
export GREP_COLOR='4;32'
