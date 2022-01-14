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

)

# Run the given build tool command name and subcommand
__b() {
	local subcmd="${build_cmd_map["$1:$2"]}"
	if [ -n "$subcmd" ]; then
		"$1" "$subcmd" "${@:3}"
	else
		>&2 echo "Command not found for $1:$2"
	fi
}

# Run the given subcommand
__b_sub() {
	if [ -f gulpfile.js ]; then
		__b gulp "$1" "${@:2}"
	elif [ -f webpack.config.js ]; then
		__b webpack "$1" "${@:2}"
	elif [ -f gatsby-config.js ]; then
		__b gatsby "$1" "${@:2}"
	else
		>&2 echo "Project type not recognized"
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
