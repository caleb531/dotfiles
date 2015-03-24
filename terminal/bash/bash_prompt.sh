#!/bin/bash
# bash_prompt.sh
# Caleb Evans

# Outputs a succinct and useful interactive prompt
# Escape sequences: http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html
_output_ps1() {

	# Output color variables
	local color_green='\[\e[1;32m\]'
	local color_white='\[\e[1;37m\]'
	local color_reset='\[\e[0m\]'

	# Output name of current working dir (with ~ denoting HOME)
	echo -n "${color_green}\W${color_white} : "

	# If working directory is a git repository (or if it resides in one)
	if git rev-parse --git-dir &> /dev/null; then

		# Output name of current branch
		echo -n "${color_green}"
		echo -n "$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
		echo -n "${color_white} : "

	fi

	# Output $ for user and # for root
	echo -n "${color_green}\$ ${color_reset}"

}

# Run the following for each new command
_update_prompt_command() {

	PS1="$(_output_ps1)"
	# Write in-memory command history to file
	history -a
	# Ensure that current working directory is updated as needed
	update_terminal_cwd

}
PROMPT_COMMAND="_update_prompt_command"
