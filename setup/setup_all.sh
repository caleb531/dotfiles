#!/usr/bin/env bash

echo "Configuring all..."

~/dotfiles/setup/create_symlinks.sh
~/dotfiles/setup/set_prefs.sh
~/dotfiles/setup/install_packages.sh
~/dotfiles/setup/install_casks.sh
~/dotfiles/setup/remove_completions.sh
