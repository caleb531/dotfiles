#!/usr/bin/env bash

# Remember admin password for lifetime of script
while true; do
	sudo -n true
	sleep 60
	kill -0 "$$" || exit
done 2>/dev/null &

# Prevent system sleep for lifetime of script
caffeinate -w "$$" &

# Import helper functions for use by other configuration scripts
source ~/dotfiles/setup/helper_functions.sh
