#!/bin/bash

source ./config/header.sh

if ! is_installed brew; then

	echo "Installing Command Line Tools..."
	xcode-select --install

	echo "Installing Homebrew..."
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

else

	echo "Already installed: Homebrew"

fi

if is_installed brew; then

	echo "Installing Homebrew packages..."

	install_pkg bash

	if [ -f /usr/local/bin/bash -a $SHELL != /usr/local/bin/bash ]; then
		echo "Changing login shell to Bash 4..."
		sudo chsh -s /usr/local/bin/bash $USER
	else
		echo "Login shell already set to Bash 4"
	fi

	# Install packages used by dotfiles
	tap_repo homebrew/versions
	install_pkg bash-completion2
	install_pkg colordiff
	tap_repo homebrew/dupes
	install_pkg grep --with-default-names
	install_pkg coreutils
	install_pkg tree

	# Install additional packages for personal use
	install_pkg git
	install_pkg python
	install_pkg python3
	install_pkg node
	install_pkg ruby
	# Install Homebrew Cask for managing packaged apps
	tap_repo caskroom/cask
	install_pkg brew-cask

	if is_installed npm; then

		echo "Installing npm packages..."

		install_npm_pkg bower
		install_npm_pkg grunt-cli
		install_npm_pkg gulp
		install_npm_pkg ios-sim

	fi

	if is_installed gem; then

		echo "Installing Ruby gems..."

		install_gem sass

	fi

else

	echo "Homebrew is not installed."

fi
