#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

echo "Configuring all..."

# Symlink dotfiles into home directory
./config-symlinks.sh
# Configure OS X preferences
./config-prefs.sh
# Install Homebrew and necessary packages
./config-packages.sh

echo "Done."
