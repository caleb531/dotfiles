#!/usr/bin/env bash
# exports.sh
# Caleb Evans

# Reset PATH to original value (if shell was reloaded)
if [ -n "$OLDPATH" ]; then
	export PATH="$OLDPATH"
fi
export OLDPATH="$PATH"

# Ensure installed packages are recognized and preferred

# GNU core utilities
export PATH=/usr/local/opt/coreutils/libexec/gnubin:"$PATH"
export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:"$MANPATH"
export PATH=/usr/local/opt/gnupg@2.0/bin:"$PATH"
export PATH=/usr/local/opt/gpg-agent/bin:"$PATH"
# Node
export DEFAULT_NODE_VERSION=12.5.0
export N_PREFIX="$HOME"/n
export PATH="$N_PREFIX"/bin:"$PATH"
export NPM_CONFIG_PREFIX=/usr/local/lib/npm-packages
export PATH="$NPM_CONFIG_PREFIX"/bin:"$PATH"
# Ruby
export PATH=/usr/local/lib/ruby/gems/2.6.0/bin:"$PATH"
export PATH=/usr/local/opt/ruby/bin:"$PATH"
export PKG_CONFIG_PATH=/usr/local/opt/ruby/lib/pkgconfig
# ImageMagick
export PKG_CONFIG_PATH=/usr/local/opt/imagemagick@6/lib/pkgconfig:"$PKG_CONFIG_PATH"
# Setup scripts
export PATH=~/dotfiles/setup:"$PATH"
export PATH=~/dotfiles/private/setup:"$PATH"

# Colorize less
# Color syntax: <http://www.termsys.demon.co.uk/vtansi.htm#colors>
# termcap(5) man page: <http://linux.die.net/man/5/termcap>
export LESS_TERMCAP_md=$'\e[1;34m'	# start bold mode
export LESS_TERMCAP_me=$'\e[1;0m'	# end modes so, us, mb, md, mr
export LESS_TERMCAP_so=$'\e[1;36m'	# start standout mode
export LESS_TERMCAP_se=$'\e[1;0m'	# end standout mode
export LESS_TERMCAP_us=$'\e[1;32m'	# start underlining
export LESS_TERMCAP_ue=$'\e[1;0m'	# end underlining

# Miscellaneous environment variables

# Explicitly declare vim as default text editor
export EDITOR='vim'

# Name of default web browser (useful for `open -a` commands)
export WEB_BROWSER_NAME='Google Chrome'

# Don't clear man page when exiting less
export MANPAGER='less --no-init --quit-if-one-screen --ignore-case'

# Number of lines of command history to keep in memory
export HISTSIZE=250
# Number of lines of command history to keep in file
export HISTFILESIZE=500
# Keep duplicate entries out of command history
export HISTCONTROL='ignoreboth:erasedups'
# Keep potentially dangerous commands out of command history
export HISTIGNORE='clear*:cplastcmd*:cprmlastcmd*:git clean*:git reset --hard*:history*:rmlastcmd*'

# Prevent Python from generating bytecode (*.pyc, __pycache__, etc.)
export PYTHONDONTWRITEBYTECODE=1

# The name of the virtualenv directory (within the respective project directory)
export VIRTUAL_ENV_NAME='.virtualenv'

# Disable notices for npm updates
export NO_UPDATE_NOTIFIER=1

# Ignore select Shellcheck errors/warnings
export SHELLCHECK_OPTS='-e SC1090 -e SC2010 -e SC2120 -e SC2155 -e SC2207'

# Colors
# ANSI color reference: <http://www.termsys.demon.co.uk/vtansi.htm#colors>

# Standard colors
export BLACK='0;30'
export RED='0;31'
export GREEN='0;32'
export YELLOW='0;33'
export BLUE='0;34'
export MAGENTA='0;35'
export CYAN='0;36'
export WHITE='0;37'

# Bold colors
export BLACK_BOLD='1;30'
export RED_BOLD='1;31'
export GREEN_BOLD='1;32'
export YELLOW_BOLD='1;33'
export BLUE_BOLD='1;34'
export MAGENTA_BOLD='1;35'
export CYAN_BOLD='1;36'
export WHITE_BOLD='1;37'

# Use green, underlined text for grep matches
export GREP_COLOR='4;32'
