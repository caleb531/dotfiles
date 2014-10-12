### .bash_profile
### Caleb Evans

# Ensure Homebrew packages are given precedence over system packages
export PATH=/usr/local/bin:$PATH

# Colorize less
# Color syntax: http://www.termsys.demon.co.uk/vtansi.htm#colors
# termcap(5) man page: http://linux.die.net/man/5/termcap
export LESS_TERMCAP_md=$(printf "\e[1;34m")	# start bold mode
export LESS_TERMCAP_me=$(printf "\e[1;0m")	# end modes so, us, mb, md, mr
export LESS_TERMCAP_so=$(printf "\e[1;31m")	# start standout mode
export LESS_TERMCAP_se=$(printf "\e[1;0m")	# end standout mode
export LESS_TERMCAP_us=$(printf "\e[1;32m")	# start underlining
export LESS_TERMCAP_ue=$(printf "\e[1;0m")	# end underlining

## Environment variables

# Set vim as default text editor
export EDITOR='vim'
# Set less as default text viewer
export PAGER='less'
# Number of lines of command history to keep in memory
export HISTSIZE=100
# Number of lines of command history to keep in file
export HISTFILESIZE=250
# Keep command history clean by eliminating duplicates
export HISTCONTROL=ignoredups:erasedups

# Create aliases to long git commands for use in PS1
alias _get_git_dir_name='git rev-parse --git-dir 2> /dev/null'
alias _get_current_git_branch='git rev-parse --abbrev-ref HEAD 2> /dev/null'

# Set a succinct and useful interactive prompt
# Escape sequences: http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html
PS1='\W$( [[ $(_get_git_dir_name) ]] && echo " : "$(_get_current_git_branch) ) : \$ '

# Load dynamic Bash completions
if [ -f /usr/local/etc/bash_dyncompletion ]; then
	source /usr/local/etc/bash_dyncompletion
fi

# Increase open files limit
ulimit -n 1024 2> /dev/null
# Increase available processes limit
ulimit -u 1024 2> /dev/null

## Aliases

# Enable aliases to be run via sudo
alias sudo='sudo '
# Reload shell
alias reload='exec $SHELL -l'
# Get permissions for file/directory in octal format
alias octmod='stat -f %Lp'
# Colorize directory listings
# LSCOLORS syntax: http://www.sbras.ru/cgi-bin/www/unix_help/unix-man?ls
export LSCOLORS='excxfxbxhxexexhxhxexex'
alias ls='ls -G'
# Colorize grep matches
# GREP_COLOR syntax: http://www.termsys.demon.co.uk/vtansi.htm#colors
export GREP_COLOR='04;32'
# --color=auto does not colorize piped output
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
# If colordiff package is installed
if type colordiff &> /dev/null; then
	# Colorize diff
	alias diff='colordiff'
fi
