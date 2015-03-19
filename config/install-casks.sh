#!/bin/bash

if [ -z "$CONFIG_ALL" ]; then
	cd "$(dirname "$0")"/..
	source ./config/helper-functions.sh
fi

if is_pkg_installed brew-cask; then

	echo "Installing Homebrew Casks..."

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
	install_cask joinme
	install_cask flux
	# Install additional OS X apps
	install_cask appcleaner
	install_cask namechanger
	install_cask codekit
	install_cask forklift
	install_cask mamp

	echo "Installing Quick Look plugins..."

	install_cask qlstephen
	install_cask qlmarkdown
	install_cask quicklook-json
	install_cask betterzipql
	install_cask suspicious-package
	qlmanage -r

	echo "Installing fonts..."

	tap_repo caskroom/fonts
	install_cask font-open-sans
	install_cask font-montserrat
	install_cask font-ubuntu

else

	echo "Homebrew Cask is not installed."

fi
