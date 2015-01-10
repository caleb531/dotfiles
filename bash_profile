# .bash_profile
# Caleb Evans

# Ensure installed packages are preferred over system packages
if [[ $PATH != /usr/local/bin* ]]; then
	export PATH=/usr/local/bin:$PATH
fi
if [ -d /usr/local/opt/coreutils/libexec/gnubin ]; then
	export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH
	export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:$MANPATH
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

## Environment variables

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

# Navigate history matching typed input using up/down arrow keys
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# If shell was not invoked by another shell
if [ $SHLVL == 1 ]; then

	# Outputs a succinct and useful interactive prompt
	# Escape sequences: http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html
	output_ps1() {
		# Output color variables
		local color_green='\[\e[1;32m\]'
		local color_white='\[\e[1;37m\]'
		local color_reset='\[\e[0m\]'
		# Output name of current working directory (with ~ denoting HOME)
		echo -n "${color_green}\W${color_white} : "
		# If PWD is a git repository (or if resides in one)
		if git rev-parse --git-dir &> /dev/null; then
			echo -n "${color_green}"
			# Output name of current branch
			echo -n "$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
			echo -n "${color_white} : "
		fi
		# Output $ for user and # for root
		echo -n "${color_green}\$${color_reset} "
	}

	update_prompt_command() {
		history -a
		update_terminal_cwd
		# Update PS1 variable for each new command
		PS1="$(output_ps1)"
	}
	PROMPT_COMMAND="update_prompt_command;"

fi

# If shell is Bash 4 or newer
if [ $BASH_VERSINFO -ge 4 ]; then

	# If Bash Completion is installed
	if [ -f /usr/local/share/bash-completion/bash_completion ]; then
		# Load completions
		source /usr/local/share/bash-completion/bash_completion
	fi

fi

## Limitations on system resources

# Increase open files limit
ulimit -n 1024 2> /dev/null
# Increase available processes limit
ulimit -u 1024 2> /dev/null

## Aliases

# Enable aliases to be run as root
alias sudo='sudo '

# Reloads .bash_profile and .inputrc
alias reload='exec $SHELL -l'

# Colorize directory listings
alias ls='ls --color=auto'

# Colorize grep matches
# GREP_COLOR syntax: http://www.termsys.demon.co.uk/vtansi.htm#colors
export GREP_COLOR='04;32'

# --color=auto does not colorize piped output
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# If tree package is installed
if type tree &> /dev/null; then
	# Colorize tree output
	alias tree='tree -C'
fi
