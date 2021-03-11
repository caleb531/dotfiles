#!/usr/bin/env bash
# prompt.sh
# Caleb Evans

# Detect the node version for this project and switch to it
__detect_node_version() {
	# If an .nvmrc exists in the current directory, switch to that node version
	# if it's not already in use
	if [[ -f .nvmrc && "$(node -v | cut -c2-)" != "$(cat .nvmrc)" ]]; then
		nvm use 2> /dev/null || nvm install "$(cat .nvmrc)"
	fi
}

# Outputs ANSI escape sequence for the given color code
__set_color() {
	echo -n "\[\e[${1}m\]"
}

# Reset color escape sequences
__reset_color() {
	__set_color 0
}

# Output a succinct and useful interactive prompt
# Escape sequences: <https://ss64.com/bash/syntax-prompt.html>
__output_ps1() {

	# Define a local constant for the separator between items in the prompt
	local SEPARATOR=' '

	# Output name of current working directory (with ~ denoting HOME)
	__set_color $CYAN
	echo -n '\W'
	echo -n "$SEPARATOR"

	# If working directory is a virtualenv
	if [ -n "$VIRTUAL_ENV" ]; then

		# Output Python version used by virtualenv
		__set_color $BLUE
		if [ -f "$VIRTUAL_ENV"/bin/python3 ]; then
			echo -n "py3"
			echo -n "$SEPARATOR"
		elif [ -f "$VIRTUAL_ENV"/bin/python2 ]; then
			echo -n "py2"
			echo -n "$SEPARATOR"
		fi

	fi

	# If working directory is a Node-based project
	if [ -f package.json ] && type node &> /dev/null; then

		# Output version of global Node
		__set_color $BLUE
		echo -n "node$(node --version | grep -Po '(?<=v)\d+\.\d+')"
		echo -n "$SEPARATOR"

	fi

	# If working directory is (or resides in) a git repository
	if git rev-parse --git-dir &> /dev/null; then

		# Output name of current branch
		__set_color $BLACK
		echo -n "$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
		echo -n "$SEPARATOR"

	fi

	# Output $ for user and # for root
	__set_color $GREEN
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
	__set_color $GREEN
	echo -ne '❯ '
	__reset_color
}

# Run the following before each new command
__update_prompt_command() {

	if [ -z "$DISABLE_NODE_AUTO_SWITCH" ]; then
		__detect_node_version
	fi
	__detect_python_virtualenv
	PS1="$(__output_ps1)"
	# Append in-memory command history to file
	history -a
	# Ensure current working directory carries to new tabs
	update_terminal_cwd 2> /dev/null

}
PROMPT_COMMAND="__update_prompt_command"
PS2="$(__output_ps2)"
