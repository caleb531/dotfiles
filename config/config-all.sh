#/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

echo "Configuring all..."

# Install Homebrew and necessary packages
./config-packages.sh
# Symlink dotfiles into home directory
./config-symlinks.sh
# Configure OS X preferences
./config-prefs.sh

echo "Done."
