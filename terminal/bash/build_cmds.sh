#!/usr/bin/env bash

# This file contains a series of unified build commands that are project-aware; if you run

declare -A build_cmd_map
build_cmd_map=(
	['gulp:build']='build'
	['gulp:clean']='clean'
	['gulp:develop']='serve'
	['gulp:watch']='watch'

	['gatsby:build']='build'
	['gatsby:clean']='clean'
	['gatsby:develop']='develop'

	['webpack:build']='build'
	['webpack:develop']='serve'
	['webpack:watch']='serve'

	['jekyll:build']='build'
	['jekyll:develop']='serve'
	['jekyll:watch']='build --watch'

	['brunch:build']='build'
	['brunch:develop']='watch --server'
	['brunch:watch']='watch'
)

# Run the given build tool command name and subcommand
__b() {
	local cmd="$1"
	local action="$2"
	local subcmd="${build_cmd_map["$cmd:$action"]}"
	local args="${*:3}"
	if [ -n "$subcmd" ]; then
		# shellcheck disable=2086,2068
		"$cmd" $subcmd $args
	else
		>&2 echo "$action command not found for $cmd"
	fi
}

# Run the given subcommand
__b_sub() {
	local action="$1"
	local args="${*:2}"
	if [ -f gulpfile.js ]; then
		__b gulp "$action" "$args"
	elif [ -f gatsby-config.js ]; then
		__b gatsby "$action" "$args"
	elif [ -f webpack.config.js ]; then
		__b webpack "$action" "$args"
	elif [ -f _config.yml ]; then
		__b jekyll "$action" "$args"
	elif [ -f brunch-config.js ]; then
		__b brunch "$action" "$args"
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
bw() {
	__b_sub watch "$@"
}
bd() {
	__b_sub develop "$@"
}
