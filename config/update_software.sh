#!/bin/bash

source ./config/header.sh sudo

echo "Updating software..."

# App Store apps
sudo softwareupdate -ia

# Homebrew packages, casks
brew update
brew upgrade --all

# Atom packages
apm update --no-confirm

# Node packages
npm install npm --global
npm update --global

# Ruby gems
sudo gem update
