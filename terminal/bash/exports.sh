#!/usr/bin/env bash
# exports.sh
# Caleb Evans

# Reset PATH to original value (if shell was reloaded)
if [ -n "$OLDPATH" ]; then
	export PATH="$OLDPATH"
fi
export OLDPATH="$PATH"
# Re-read .nvmrc when reloading shell
export CURRENT_NODE_AUTO_SWITCH_PWD=

# Ensure installed packages are recognized and preferred

# Homebrew
export PATH=~/homebrew/bin:/opt/homebrew/bin:"$PATH"
if type brew &> /dev/null; then
	export BREW_PREFIX="$(brew --prefix)"
fi
# Guile (used for GPG)
export GUILE_LOAD_PATH="$BREW_PREFIX"/share/guile/site/3.0
export GUILE_LOAD_COMPILED_PATH="$BREW_PREFIX"/lib/guile/3.0/site-ccache
export GUILE_SYSTEM_EXTENSIONS_PATH="$BREW_PREFIX"/lib/guile/3.0/extensions
# GNU core utilities
export PATH="$BREW_PREFIX"/opt/coreutils/libexec/gnubin:"$PATH"
export MANPATH="$BREW_PREFIX"/opt/coreutils/libexec/gnuman:"$MANPATH"
export PATH="$BREW_PREFIX"/opt/gnupg@2.0/bin:"$PATH"
export PATH="$BREW_PREFIX"/opt/gpg-agent/bin:"$PATH"
# pnpm global store
export PNPM_HOME="/Users/caleb/Library/pnpm"
export PATH="$PNPM_HOME":"$PATH"
# Jekyll
export PATH="$BREW_PREFIX"/opt/ruby/bin:"$PATH"
if [ -d "$BREW_PREFIX"/lib/ruby/gems/3.1.0 ]; then
	RUBY_GEMS_DIR="$(ls -d -1 "$BREW_PREFIX"/lib/ruby/gems/3.0.0 | tail -n 1)"
fi
export PATH="$RUBY_GEMS_DIR"/bin:"$PATH"
export PKG_CONFIG_PATH="$BREW_PREFIX"/opt/imagemagick@6/lib/pkgconfig:"$PKG_CONFIG_PATH"
export PKG_CONFIG_PATH="$BREW_PREFIX"/opt/libffi/lib/pkgconfig:"$PKG_CONFIG_PATH"
# MAMP/PHP
export PATH=/Applications/MAMP/bin/php/php8.0.8/bin/:"$PATH"
# Setup scripts
export PATH=~/dotfiles/setup:"$PATH"
export PATH=~/dotfiles/private/setup:"$PATH"

# Miscellaneous environment variables

# Explicitly declare vim as default text editor (Git will fall back to this
# environment variable unless core.editor is set in your .gitconfig)
export EDITOR='vim'

# Name of default web browser (useful for `open -a` commands)
export WEB_BROWSER_NAME='Brave Browser'

# Don't clear man page when exiting less
export MANPAGER='less --no-init --quit-if-one-screen --IGNORE-CASE'
# Use a case-insensitive pager and diff-so-fancy for Git (if available)
if type diff-so-fancy &> /dev/null; then
	export GIT_PAGER='diff-so-fancy | less --tabs=4 -R --no-init --quit-if-one-screen --IGNORE-CASE'
fi

# Architecture-agnostic path to pinentry-mac; if you change this value, remember
# to change the hardcoded reference in gpg/gpg-agent.conf
export GPG_BIN_DIR=~/.gnupg/bin
export GPG_TTY=$(tty)

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

# Ignore select Shellcheck errors/warnings:
# - SC1090: Can't follow non-constant source. Use a directive to specify
#   location.
# - SC2010: Don't use ls | grep. Use a glob or a for loop with a condition to
#   allow non-alphanumeric filenames.
# - SC2120: foo references arguments, but none are ever passed.
# - SC2155: Declare and assign separately to avoid masking return values.
# - SC2207: Prefer mapfile or read -a to split command output (or quote to avoid
#   splitting).
export SHELLCHECK_OPTS='-e SC1090 -e SC2010 -e SC2120 -e SC2155 -e SC2207'

# Colors
# ANSI color reference: <http://www.termsys.demon.co.uk/vtansi.htm#colors>

# Standard colors
export BLACK=$'\e[0;30m'
export RED=$'\e[0;31m'
export GREEN=$'\e[0;32m'
export YELLOW=$'\e[0;33m'
export BLUE=$'\e[0;34m'
export MAGENTA=$'\e[0;35m'
export CYAN=$'\e[0;36m'
export WHITE=$'\e[0;37m'
export RESET_COLOR=$'\e[0m'

# Bold colors
export BLACK_BOLD=$'\e[1;30m'
export RED_BOLD=$'\e[1;31m'
export GREEN_BOLD=$'\e[1;32m'
export YELLOW_BOLD=$'\e[1;33m'
export BLUE_BOLD=$'\e[1;34m'
export MAGENTA_BOLD=$'\e[1;35m'
export CYAN_BOLD=$'\e[1;36m'
export WHITE_BOLD=$'\e[1;37m'
export RESET_BOLD=$'\e[1;0m'

# Use green, underlined text for grep matches
export GREP_COLOR=$'\e[4;32m'
export GREP_COLORS='ms=04;32:mc=04;32:sl=:cx=:fn=35:ln=32:bn=32:se=36'

# Colorize less
# Color syntax: <http://www.termsys.demon.co.uk/vtansi.htm#colors>
# termcap(5) man page: <http://linux.die.net/man/5/termcap>
export LESS_TERMCAP_md="$BLUE_BOLD"	 # start bold mode
export LESS_TERMCAP_me="$RESET_BOLD" # end modes so, us, mb, md, mr
export LESS_TERMCAP_so="$CYAN_BOLD"	 # start standout mode
export LESS_TERMCAP_se="$RESET_BOLD" # end standout mode
export LESS_TERMCAP_us="$GREEN_BOLD" # start underlining
export LESS_TERMCAP_ue="$RESET_BOLD" # end underlining
