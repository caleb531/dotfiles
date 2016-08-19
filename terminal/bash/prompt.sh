#!/usr/bin/env bash
# prompt.sh
# Caleb Evans

# Outputs ANSI escape sequence for the given color code
__set_color() {
	echo -n "\[\e[${1}m\]"
}

# Reset color escape sequences
__reset_color() {
	__set_color 0
}

# Output a succinct and useful interactive prompt
# Escape sequences: http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html
__output_ps1() {

	# Define a local constant for the separator between items in the prompt
	local SEPARATOR=' : '

	# Output name of current working directory (with ~ denoting HOME)
	__set_color $PURPLE_BOLD
	echo -n '\W'
	__set_color $WHITE_BOLD
	echo -n "$SEPARATOR"

	# If working directory is a virtualenv
	if [ -n "$VIRTUAL_ENV" ]; then

		# Output Python version used by virtualenv
		__set_color $PURPLE_BOLD
		if [ -f "$VIRTUAL_ENV"/bin/python3 ]; then
			echo -n "python3"
		elif [ -f "$VIRTUAL_ENV"/bin/python2 ]; then
			echo -n "python2"
		fi
		__set_color $WHITE_BOLD
		echo -n "$SEPARATOR"

	fi

	# If working directory is (or resides in) a git repository
	if [ -n "$IS_GIT_REPO" ]; then

		# Output name of current branch
		__set_color $PURPLE_BOLD
		echo -n "$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
		__set_color $WHITE_BOLD
		echo -n "$SEPARATOR"

	fi

	# Output $ for user and # for root
	__set_color $PURPLE_BOLD
	echo -n '\$ '
	__reset_color

}

# Activate/deactivate Python virtualenv depending on the current directory
__detect_python_virtualenv() {

	local virtualenv=./"$VIRTUAL_ENV_NAME"
	# If current directory has a virtualenv that is not itself
	if [ -d "$virtualenv" -a "$virtualenv" != "$PWD" ]; then
		# Activate virtualenv if it is not already active
		if [ -z "$VIRTUAL_ENV" -o "$VIRTUAL_ENV" != "$virtualenv" ]; then
			source "$virtualenv"/bin/activate
		fi
	else
		# Otherwise, deactivate any active virtualenv
		if [ -n "$VIRTUAL_ENV" ]; then
			deactivate
		fi
	fi

}

# Check if the given directory or one of its parents is a Git repository
__check_if_git_repo() {
	if git rev-parse --git-dir &> /dev/null; then
		IS_GIT_REPO=1
	else
		unset IS_GIT_REPO
	fi
}

# Display reminder to pull if current directory resides in a git repository
# outside of Dropbox
__output_git_pull_reminder() {
	if [ -n "$IS_GIT_REPO" ]; then
		if [ -z "$GIT_PULL_REMINDED" ]; then
			export GIT_PULL_REMINDED="$(date +%s)"
		fi
		# Calculate the time since the last pull reminder was shown
		local time_diff="$(expr "$(date +%s)" - $GIT_PULL_REMINDED)"
		# Display reminder if 10+ minutes have elapsed since last reminder
		if [ "$time_diff" -ge "600" ]; then
			echo "Remember to pull!"
			export GIT_PULL_REMINDED="$(date +%s)"
		fi
	fi
}

# Run the following before each new command
__update_prompt_command() {

	__check_if_git_repo
	__output_git_pull_reminder
	__detect_python_virtualenv
	PS1="$(__output_ps1)"
	# Write in-memory command history to file
	history -a
	# Ensure current working directory carries to new tabs
	update_terminal_cwd 2> /dev/null

}
PROMPT_COMMAND="__update_prompt_command"
