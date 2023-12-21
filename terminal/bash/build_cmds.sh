#!/usr/bin/env bash

# This file contains a series of unified build commands that are project-aware; if you run

# These commands require Bash 4 or newer; for Bash 3 and older, these commands
# simply won't be exposed
if [ "${BASH_VERSINFO[0]}" -ge 4 ]; then

	declare -A build_cmd_map=(
		['gulp:build']='gulp build'
		['gulp:clean']='gulp clean'
		['gulp:develop']='gulp serve'
		['gulp:watch']='gulp build:watch'

		['node:start']='npm start'
		['node:build']='npm run build'
		['node:watch']='npm run watch'
		['node:develop']='npm run dev'
		['node:preview']='npm run preview'

		['jekyll:build']='jekyll build'
		['jekyll:develop']='jekyll serve'
		['jekyll:watch']='jekyll build --watch'

		['python-build:build']='python -m build --sdist --wheel --outdir dist/ .'
	)

	# Run the given build tool command name and subcommand
	__b() {
		local project_type="$1"
		local action="$2"
		local subcmd="${build_cmd_map["$project_type:$action"]}"
		local args=${*:3}
		if [ -n "$subcmd" ]; then
			if [ -n "$args" ]; then
				echo "Running $subcmd -- $args"
			else
				echo "Running $subcmd $args"
			fi
			# shellcheck disable=SC2086
			$subcmd -- $args
		else
			>&2 echo "$action command not found for $project_type"
		fi
	}

	# Run the given subcommand
	__b_sub() {
		local action="$1"
		local args=${*:2}
		if __is_node_project; then
			# shellcheck disable=SC2086
			__b node "$action" $args
		elif __is_python_build_project; then
			# shellcheck disable=SC2086
			__b python-build "$action" $args
		elif [ -f _config.yml ]; then
			# shellcheck disable=SC2086
			__b jekyll "$action" $args
		else
			>&2 echo "project type not recognized"
		fi
	}

	bc() {
		__b_sub clean "$@"
	}
	bb() {
		__b_sub build "$@"
	}
	bp() {
		NODE_ENV=production JEKYLL_ENV=production __b_sub preview "$@"
	}
	bbp() {
		# shellcheck disable=SC2119
		bb
		bp "$@"
	}
	bbpo() {
		bbp --open
	}
	bw() {
		__b_sub watch "$@"
	}
	bd() {
		__b_sub develop "$@"
	}
	bdo() {
		__b_sub develop --open "$@"
	}
	bs() {
		__b_sub start "$@"
	}
	bso() {
		__b_sub start --open "$@"
	}

fi
