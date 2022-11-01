#!/usr/bin/env bash

source ~/dotfiles/setup/header.sh

if ! is_cmd_installed brew; then

	echo "Installing Command Line Tools..."
	sudo xcode-select --install
	echo "Installing Rosetta..."
	sudo softwareupdate --install-rosetta 2> /dev/null

	echo "Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	export PATH=/opt/homebrew/bin:"$PATH"
	export BREW_PREFIX="$(brew --prefix)"

fi
