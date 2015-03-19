#!/bin/bash

CONFIG_ALL=1

cd "$(dirname "$0")"/..
source ./config/helper-functions.sh

echo "Configuring all..."

# Symlink dotfiles into home directory
source ./config/create-symlinks.sh
# Configure OS X preferences
source ./config/set-prefs.sh
# Install Homebrew and necessary packages
source ./config/install-packages.sh
# Install OS X packages, plugins, fonts, etc. using Homebrew Cask
source ./config/install-casks.sh

echo "Done."
