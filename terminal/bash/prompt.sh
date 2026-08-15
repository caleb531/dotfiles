#!/usr/bin/env bash
# prompt.sh
# Caleb Evans

# Invoke a function upward until it succeeds or reaches the current Git root
__walk_up_git_repo() {
	local callback="$1"
	local git_root
	local search_dir="$PWD"

	# Establish the inclusive traversal boundary and reject use outside a Git
	# repo
	if ! git_root="$(git rev-parse --show-toplevel 2> /dev/null)"; then
		echo "Cannot walk up Git repository: current directory is not in a Git repository" >&2
		return 1
	fi

	# Check the current directory before the boundary condition to emulate
	# do-while
	while true; do
		# Stop when the callback succeeds or after checking the Git root itself
		if "$callback" "$search_dir" || [[ "$search_dir" == "$git_root" ]]; then
			break
		fi
		search_dir="$(dirname "$search_dir")"
	done
}

# Output the contents of the .nvmrc in the given directory
__get_nvmrc_contents() {
	cat "$1/.nvmrc" 2> /dev/null
}

# Detect the node version for this project and switch to it
__detect_node_version() {
	local nvmrc_contents
	if git rev-parse --git-dir > /dev/null 2>&1; then
		# Search ancestors only when the Git root provides a clear stopping
		# boundary
		nvmrc_contents="$(__walk_up_git_repo __get_nvmrc_contents)"
	else
		# Outside a Git repo, limit detection to the current directory
		nvmrc_contents="$(__get_nvmrc_contents "$PWD")"
	fi
	# If an .nvmrc exists in the current directory (that we just entered), or an
	# ancestor within the current Git repository
	if [[ -n "$nvmrc_contents" && "$(node -v | cut -c2-)" != "$nvmrc_contents" && "$CURRENT_NODE_AUTO_SWITCH_PWD" != "$PWD" ]]; then
		export CURRENT_NODE_AUTO_SWITCH_PWD="$PWD"
		fnm use "$nvmrc_contents"
	# OR.. if the current directory's package.json contains an "engines" field,
	# switch to that resolved node version if it's not already active
	elif [[ "$(cat package.json 2> /dev/null | yq '.engines')" != null && "$CURRENT_NODE_AUTO_SWITCH_PWD" != "$PWD" ]]; then
		export CURRENT_NODE_AUTO_SWITCH_PWD="$PWD"
		fnm use --resolve-engines
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
			echo -n "py$(python --version | grep -Eo 'Python [0-9]+\.[0-9]+' | cut -c 8-)"
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
