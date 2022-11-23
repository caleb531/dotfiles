#!/usr/bin/env bash
# config.sh
# Caleb Evans

# Expand multiple subdirectories using the globstar (**) option
shopt -s globstar 2> /dev/null
# Enable extended glob syntax (like [!])
shopt -s extglob 2> /dev/null
# Ensure that command history is appended to and not overwritten
shopt -s histappend 2> /dev/null

# Navigate command history matching typed input using up/down arrow keys
bind '"\e[A": history-search-backward' 2> /dev/null
bind '"\e[B": history-search-forward' 2> /dev/null
# Automatically add trailing slash to autocompleted directory symlinks
bind 'set mark-symlinked-directories on' 2> /dev/null
# Make autocompletion case-insensitive
bind 'set completion-ignore-case on' 2> /dev/null

# If shell is Bash 4 or newer
if [ "${BASH_VERSINFO[0]}" -ge 4 ]; then

	# If Bash Completion is installed, load completions
	if [ -f "$BREW_PREFIX"/etc/profile.d/bash_completion.sh ]; then
		# Re-enable v1 completions
		export BASH_COMPLETION_COMPAT_DIR="$BREW_PREFIX/etc/bash_completion.d"
		source "$BREW_PREFIX"/etc/profile.d/bash_completion.sh
	fi

fi

source ~/dotfiles/terminal/bash/load_nvm.sh

# tabtab source for packages (used by pnpm)
# uninstall by removing these lines
if [ -f ~/.config/tabtab/bash/__tabtab.bash ]; then
	source ~/.config/tabtab/bash/__tabtab.bash
fi

# Set limitations on system resources (uncomment if you experience issues)

# Increase open files limit
# ulimit -n 1024 2> /dev/null
# Increase available processes limit
# ulimit -u 1024 2> /dev/null
