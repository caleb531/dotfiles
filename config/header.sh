#!/bin/bash

setup() {

	# Prompt for admin password upfront
	sudo -v

	# Remember admin password for lifetime of script
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

	# Prevent system sleep for lifetime of script
	caffeinate -w "$$" &

	# Import helper functions for use by other configuration scripts
	source ./config/helper-functions.sh

	# Run teardown function on script exit
	trap teardown EXIT

}

teardown() {

	# Forget admin password persisted by sudo
	sudo -k

}

# Prevent header code from running more than once
if [ -z $header_ran ]; then

	header_ran=1

	setup

fi
