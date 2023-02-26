#!/usr/bin/env bash
# prompt.sh
# Caleb Evans

# Detect the node version for this project and switch to it
__detect_node_version() {
	local nvmrc_contents="$(cat .nvmrc 2> /dev/null)"
	if [ -z "$nvmrc_contents" ]; then
		nvmrc_contents="$(cat ../.nvmrc 2> /dev/null)"
	fi
	# If an .nvmrc exists in the current directory (that we just entered),
	# switch to that node version if it's not already
	if [[ -n "$nvmrc_contents" && "$(node -v | cut -c2-)" != "$nvmrc_contents" && "$CURRENT_NODE_AUTO_SWITCH_PWD" != "$PWD" ]]; then
		export CURRENT_NODE_AUTO_SWITCH_PWD="$PWD"
		fnm use --silent &> /dev/null
	fi
}

# Outputs the given ANSI color escape sequence
__set_color() {
	printf "\[%s\]" "$1"
}

# Reset color escape sequences
__reset_color() {
	__set_color "$RESET_COLOR"
}

# Output a succinct and useful interactive prompt
# Escape sequences: <https://ss64.com/bash/syntax-prompt.html>
__output_ps1() {

	# Define a local constant for the separator between items in the prompt
	local SEPARATOR=' '

	# Output name of current working directory (with ~ denoting HOME)
	__set_color "$CYAN"
	echo -n '\W'
	echo -n "$SEPARATOR"

	# If working directory is a virtualenv
	if [ -n "$VIRTUAL_ENV" ]; then

		# Output Python version used by virtualenv
		__set_color "$BLUE"
		if [ -f "$VIRTUAL_ENV"/bin/python3 ]; then
			echo -n "py3"
			echo -n "$SEPARATOR"
		elif [ -f "$VIRTUAL_ENV"/bin/python2 ]; then
			echo -n "py2"
			echo -n "$SEPARATOR"
		fi

	fi

	# If working directory is a Node-based project
	if __is_node_project; then

		# Output version of global Node
		__set_color "$BLUE"
		echo -n "node$(node --version | grep -Eo 'v[0-9]+\.[0-9]+' | cut -c 2-)"
		echo -n "$SEPARATOR"

	fi

	# If working directory is (or resides in) a git repository
	if git rev-parse --git-dir &> /dev/null; then

		# Output name of current branch
		__set_color "$BLACK"
		echo -n "$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
		echo -n "$SEPARATOR"

	fi

	# Output $ for user and # for root
	__set_color "$GREEN"
	echo -ne '❯ '
	__reset_color

}

# Activate/deactivate Python virtualenv depending on the current directory
__detect_python_virtualenv() {

	local virtualenv=./"$VIRTUAL_ENV_NAME"
	# If current directory has a virtualenv that is not itself
	if [ -f "$virtualenv"/bin/activate ] && [ "$virtualenv" != "$PWD" ]; then
		# Activate virtualenv if it is not already active
		if [ -z "$VIRTUAL_ENV" ] || [ "$VIRTUAL_ENV" != "$virtualenv" ]; then
			source "$virtualenv"/bin/activate
		fi
	else
		# Otherwise, deactivate any active virtualenv
		if [ -n "$VIRTUAL_ENV" ]; then
			deactivate
		fi
	fi

}

# Output line continuation prompt string
__output_ps2() {
	# Use fancy chevron from PS1
	__set_color "$GREEN"
	echo -ne '❯ '
	__reset_color
}

# Run the following before each new command
__update_prompt_command() {

	# Ensure current working directory carries to new tabs
	update_terminal_cwd 2> /dev/null
	# Append in-memory command history to file
	history -a

	if [ -z "$DISABLE_NODE_AUTO_SWITCH" ]; then
		__detect_node_version
	fi
	__detect_python_virtualenv

	# Normally, we can declare the PS1 once outside the PROMPT_COMMAND function.
	# However, because our PS1 includes dynamic pieces (like the current Git
	# branch name), we must ensure that __output_ps1 is called after every
	# command to ensure the PS1 always up-to-date
	PS1="$(__output_ps1)"
}
PROMPT_COMMAND="__update_prompt_command"
# The PS2 output does not need to be context-aware, meaning we can evaluate it
# once for the lifetime of the shell
PS2="$(__output_ps2)"
