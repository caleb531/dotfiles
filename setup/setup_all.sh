#!/usr/bin/env bash

echo "Configuring all..."

source ~/dotfiles/setup/create_symlinks.sh
source ~/dotfiles/setup/set_prefs.sh
source ~/dotfiles/setup/install_packages.sh
source ~/dotfiles/setup/install_casks.sh
source ~/dotfiles/setup/remove_completions.sh
