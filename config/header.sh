#!/bin/bash

# Prevent header code from running more than once
if [ -z $header_ran ]; then

	header_ran=1

	# Prompt for admin password upfront
	sudo -v

	# Remember admin password for lifetime of script
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

	# Prevent system sleep for lifetime of script
	caffeinate -w "$$" &

fi
