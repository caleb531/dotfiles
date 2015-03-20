#!/bin/bash
# bash_exports.sh
# Caleb Evans

# Ensure installed packages are recognized and preferred

# Homebrew and other user-installed packages
if [[ $PATH != /usr/local/bin* ]]; then
	export PATH=/usr/local/bin:$PATH
fi
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

# Environment variables

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

# GREP_COLOR syntax: http://www.termsys.demon.co.uk/vtansi.htm#colors
export GREP_COLOR='04;32'
