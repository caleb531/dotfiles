#!/bin/bash

source ./config/header.sh sudo

echo "Updating software..."

# App Store apps
sudo softwareupdate -ia

# Homebrew packages
brew update
brew upgrade --all

# Atom packages
apm update --no-confirm

# Node packages
if is_cmd_installed npm; then
	npm install npm --global
	npm update --global
fi

# Ruby gems
if is_cmd_installed gem; then
	sudo gem update
fi
