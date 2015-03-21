#!/bin/bash

source ./config/header.sh

echo "Updating software..."

# Update App Store apps
sudo softwareupdate -ia

# Update Homebrew packages, casks
brew update
brew upgrade

# Update npm & packages
npm install npm -g
npm update -g
# Update Ruby gems
sudo gem update
