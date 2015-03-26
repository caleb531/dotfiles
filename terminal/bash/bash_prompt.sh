#!/bin/bash
# bash_prompt.sh
# Caleb Evans

# Output ANSI escape sequence for the given color code
__set_color() {
	echo -n "\[\e[${1}m\]"
}

# Reset color escape sequences
__reset_color() {
	__set_color 0
}

# Outputs a succinct and useful interactive prompt
# Escape sequences: http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html
__output_ps1() {

	# Output name of current working directory (with ~ denoting HOME)
	__set_color $PURPLE_BOLD
	echo -n "\W"
	__set_color $WHITE_BOLD
	echo -n " : "

	# If working directory is (or resides in) a git repository
	if git rev-parse --git-dir &> /dev/null; then

		# Output name of current branch
		__set_color $PURPLE_BOLD
		echo -n "$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
		__set_color $WHITE_BOLD
		echo -n " : "

	fi

	# Output $ for user and # for root
	__set_color $PURPLE_BOLD
	echo -n "\$ "
	__reset_color

}

# Run the following for each new command
__update_prompt_command() {

	PS1="$(__output_ps1)"
	# Write in-memory command history to file
	history -a
	# Ensure that current working directory is updated as needed
	update_terminal_cwd

}
PROMPT_COMMAND="__update_prompt_command"
