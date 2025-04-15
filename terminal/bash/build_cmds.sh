#!/usr/bin/env bash

# This file contains a series of unified build commands that are project-aware; if you run

# These commands require Bash 4 or newer; for Bash 3 and older, these commands
# simply won't be exposed
if [ "${BASH_VERSINFO[0]}" -ge 4 ]; then

	__get_preferred_node_package_manager() {
		if [ -f pnpm-lock.yaml ]; then
			pnpm "$@"
		elif [ -f yarn.lock ]; then
			yarn "$@"
		else
			npm "$@"
		fi
	}

	declare -A build_cmd_map=(
		['node:start']='__get_preferred_node_package_manager start'
		['node:build']='__get_preferred_node_package_manager run build'
		['node:watch']='__get_preferred_node_package_manager run watch'
		['node:clean']='__get_preferred_node_package_manager run clean'
		['node:develop']='__get_preferred_node_package_manager run dev'
		['node:preview']='__get_preferred_node_package_manager run preview'

		['python:build']='python -m build --sdist --wheel --outdir dist/ .'
	)

	# Run the given build tool command name and subcommand
	__b() {
		local project_type="$1"
		local action="$2"
		local subcmd="${build_cmd_map["$project_type:$action"]}"
		local args=${*:3}
		if [ -n "$subcmd" ]; then
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
			__b python "$action" $args
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
	bpo() {
		bp --open "$@"
	}
	bbp() {
		# shellcheck disable=SC2119
		bb || return 1
		bp "$@"
	}
	bbpo() {
		bbp --open "$@"
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
