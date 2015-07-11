#!/bin/bash

source ./config/header.sh sudo

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
	install_pkg ssh-copy-id
	install_pkg closure-compiler
	# Install Homebrew Cask for managing packaged apps
	tap_repo caskroom/cask
	install_pkg brew-cask


	echo -n "Install dev env packages for work? (y/n) "
	read prompt_answer

	if [ "$prompt_answer" == y ]; then

		install_pkg ruby
		install_pkg node
		install_pkg postgresql
		install_pkg imagemagick	--with-webp
		install_pkg graphicsmagick

		if is_installed npm; then

			echo "Installing npm packages..."

			install_npm_pkg bower
			install_npm_pkg grunt-cli
			install_npm_pkg gulp
			install_npm_pkg ios-sim
			install_npm_pkg node-inspector

		fi

		if is_installed gem; then

			echo "Installing Ruby gems..."

			install_gem sass

		fi

	fi

	if is_installed pip; then

		echo "Installing pip packages..."

		install_pip_pkg virtualenv
		install_pip_pkg pep8

	fi

	if is_installed apm; then

		echo "Installing Atom packages..."

		install_apm_pkg monokai
		install_apm_pkg editorconfig
		install_apm_pkg resize-indent
		install_apm_pkg line-ending-converter
		install_apm_pkg language-applescript
		install_apm_pkg language-gitignore
		install_apm_pkg language-apache
		install_apm_pkg language-hosts
		install_apm_pkg language-viml
		install_apm_pkg language-ini
		install_apm_pkg language-x86
		install_apm_pkg ssh-config
		install_apm_pkg script
		install_apm_pkg emmet
		install_apm_pkg linter
		install_apm_pkg linter-jshint
		install_apm_pkg linter-jscs
		install_apm_pkg linter-pep8
		install_apm_pkg linter-php
		install_apm_pkg linter-shellcheck

	fi

else

	echo "Homebrew is not installed."

fi
