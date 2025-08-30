#!/usr/bin/env bash

source ~/dotfiles/setup/header.sh
source ~/dotfiles/terminal/bash/exports.sh

echo "Installing Homebrew Casks..."
preload_cask_list

# Install essential macOS apps via Cask (in order of essentiality)
install_cask google-chrome
install_cask brave-browser
install_cask sync
install_cask alfred
install_cask visual-studio-code
install_cask 1password
install_cask 1password-cli
install_cask keyboard-maestro
install_cask flux-app
# Install additional apps
install_cask chatgpt
install_cask zoom
install_cask microsoft-teams
install_cask postman
install_cask keybase
# Least-essential apps
install_cask appcleaner
install_cask imageoptim
install_cask namechanger
install_cask the-unarchiver
install_cask mamp
rm -rf '/Applications/MAMP PRO'

echo "Installing Quick Look plugins..."

install_cask quicklook-json
install_cask betterzip
install_cask suspicious-package
qlmanage -r
