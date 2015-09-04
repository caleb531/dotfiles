#!/bin/bash

source ./config/header.sh sudo

if ! is_cmd_installed brew; then

	echo "Installing Command Line Tools..."
	xcode-select --install

	echo "Installing Homebrew..."
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

else

	echo "Already installed: Homebrew"

fi

if is_cmd_installed brew; then

	echo "Installing Homebrew packages..."

	install_brew_pkg bash

	if [ -f /usr/local/bin/bash -a $SHELL != /usr/local/bin/bash ]; then
		echo "Changing login shell to Bash 4..."
		sudo chsh -s /usr/local/bin/bash $USER
	else
		echo "Login shell already set to Bash 4"
	fi

	# Install packages used by dotfiles
	tap_brew_repo homebrew/versions
	install_brew_pkg bash-completion2
	install_brew_pkg colordiff
	tap_brew_repo homebrew/dupes
	install_brew_pkg grep --with-default-names
	install_brew_pkg coreutils
	install_brew_pkg tree

	# Install additional packages for personal use
	install_brew_pkg git
	install_brew_pkg python
	install_brew_pkg python3
	install_brew_pkg ssh-copy-id
	install_brew_pkg closure-compiler
	install_brew_pkg node
	tap_brew_repo beeftornado/rmtree
	brew install brew-rmtree
	# Install Homebrew Cask for managing packaged apps
	tap_brew_repo caskroom/cask
	install_brew_pkg brew-cask

	# OS X now disguises clang as gcc/g++. Install and link real gcc/g++
	install_brew_pkg gcc
	ln -sf /usr/local/bin/gcc-5 /usr/local/bin/gcc
	ln -sf /usr/local/bin/g++-5 /usr/local/bin/g++

	if is_cmd_installed pip; then

		echo "Installing pip packages..."

		install_pip_pkg virtualenv
		install_pip_pkg flake8
		install_pip_pkg pep8-naming

	fi

	if is_cmd_installed apm; then

		echo "Installing Atom packages..."

		install_apm_pkg monokai
		install_apm_pkg editorconfig
		install_apm_pkg resize-indent
		install_apm_pkg expand-region
		install_apm_pkg line-ending-converter
		install_apm_pkg language-applescript
		install_apm_pkg language-gitignore
		install_apm_pkg language-apache
		install_apm_pkg language-hosts
		install_apm_pkg language-viml
		install_apm_pkg language-ini
		install_apm_pkg language-cpp14
		install_apm_pkg language-x86
		install_apm_pkg ssh-config
		install_apm_pkg atom-alignment
		install_apm_pkg advanced-open-file
		install_apm_pkg auto-update-packages
		install_apm_pkg script
		install_apm_pkg emmet
		install_apm_pkg linter
		install_apm_pkg linter-jshint
		install_apm_pkg linter-jscs
		install_apm_pkg linter-flake8
		install_apm_pkg linter-php
		install_apm_pkg pigments
		install_apm_pkg merge-conflicts
		install_apm_pkg svg-preview

	fi

else

	echo "Homebrew is not installed."

fi
