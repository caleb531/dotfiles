#!/usr/bin/env bash

source ~/dotfiles/setup/header.sh

echo "Installing Homebrew Casks..."
preload_cask_list

# Install essential macOS apps via Cask (in order of essentiality)
install_cask google-chrome
install_cask dropbox
install_cask alfred
install_cask atom
install_cask authy
install_cask evernote
install_cask keyboard-maestro
install_cask skype
install_cask flux
# Install additional apps
install_cask appcleaner
install_cask namechanger
install_cask cyberduck
install_cask the-unarchiver
install_cask mamp
rm -rf '/Applications/MAMP PRO'
install_cask keybase
install_cask postman

echo "Installing Quick Look plugins..."

install_cask qlstephen
install_cask qlmarkdown
install_cask scriptql
install_cask quicklook-json
install_cask betterzipql
install_cask suspicious-package
qlmanage -r

echo "Installing additional plugins..."

install_cask colorpicker-hex
