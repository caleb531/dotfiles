#!/bin/bash

if [ -z "$CONFIG_ALL" ]; then
	cd "$(dirname "$0")"/..
	source ./config/helper-functions.sh
fi

echo "Updating software..."

# Update App Store apps
sudo softwareupdate -i -a

# Update Homebrew packages, casks
brew update
brew upgrade

# Update npm & packages
npm install npm -g
npm update -g
# Update Ruby gems
sudo gem update
