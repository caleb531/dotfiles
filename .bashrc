### .bashrc
### Caleb Evans

# If PATH does not begin with /usr/local/bin
if [[ $PATH != /usr/local/bin* ]]; then
	# Prefer Homebrew packages over system packages
	export PATH=/usr/local/bin:$PATH
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

# Set vim as default text editor
export EDITOR='vim'
# Set less as default text viewer
export PAGER='less'
# Number of lines of command history to keep in memory
export HISTSIZE=100
# Number of lines of command history to keep in file
export HISTFILESIZE=250
# Prevent duplicate entries in command history
export HISTCONTROL=ignoredups:erasedups

# Create aliases to long git commands for use in PS1
alias _get_git_dir='git rev-parse --git-dir &> /dev/null'
alias _get_git_branch='git rev-parse --abbrev-ref HEAD 2> /dev/null'

# Set a succinct and useful interactive prompt
# Escape sequences: http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html
PS1='\W$( _get_git_dir && echo " ": $(_get_git_branch) ) : \$ '

# If dynamic Bash completions exist
if [ -f /usr/local/etc/bash_dyncompletion ]; then
	# Load dynamic Bash completions
	source /usr/local/etc/bash_dyncompletion
fi

# Update history file before presenting prompt
PROMPT_COMMAND=$PROMPT_COMMAND'history -a;'

## Limitations on system resources

# Increase open files limit
ulimit -n 1024 2> /dev/null
# Increase available processes limit
ulimit -u 1024 2> /dev/null

## Aliases

# Enable aliases to be run as root
alias sudo='sudo '
# Reloads shell
alias reload='exec $SHELL -l'
# Outputs permissions for file/directory in octal format
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
	# Colorize diff output
	alias diff='colordiff'
fi
# If tree package is installed
if type tree &> /dev/null; then
	# Colorize tree output
	alias tree='tree -C'
fi
