#!/bin/bash

# Prompt for admin password upfront
sudo -v

# Remember admin password for lifetime of script
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Prevent system from sleeping for lifetime of script
caffeinate -w "$$" &
