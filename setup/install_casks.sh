#!/usr/bin/env bash

source ./setup/header.sh

echo "Installing Homebrew Casks..."
preload_cask_list

# Ensure that all Cask-installed apps are linked to /Applications
export HOMEBREW_CASK_OPTS='--appdir=/Applications'

# Install essential OS X apps via Cask (in order of essentiality)
install_cask google-chrome
install_cask dropbox
install_cask alfred
install_cask atom
install_cask evernote
install_cask keyboard-maestro
install_cask skype
install_cask flux
# Install additional OS X apps
install_cask appcleaner
install_cask namechanger
install_cask codekit
install_cask cyberduck
install_cask mamp
rm -rf '/Applications/MAMP PRO'
install_cask keybase

echo "Installing Quick Look plugins..."

install_cask qlstephen
install_cask qlmarkdown
install_cask scriptql
install_cask quicklook-json
install_cask betterzipql
install_cask suspicious-package
qlmanage -r

echo "Installing fonts..."

tap_brew_repo caskroom/fonts
install_cask font-open-sans
install_cask font-montserrat
install_cask font-ubuntu

echo "Installing additional plugins..."

install_cask colorpicker-hex
install_cask silverlight
install_cask java
