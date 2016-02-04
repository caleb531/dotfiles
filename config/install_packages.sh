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
	# Always use Python 3 pip
	ln -sf /usr/local/bin/pip3 /usr/local/bin/pip
	install_brew_pkg ssh-copy-id
	install_brew_pkg closure-compiler

	# Install utilities necessary for Grunt projects
	install_brew_pkg ruby
	pin_brew_pkg ruby
	if is_cmd_installed gem; then
		install_gem sass
	fi
	install_brew_pkg node
	pin_brew_pkg node
	if is_cmd_installed npm; then
		install_npm_pkg grunt-cli
	fi

	tap_brew_repo beeftornado/rmtree
	brew install brew-rmtree

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

		# Install Atom packages by reading each line from packages text file
		while IFS='' read -r pkg || [ -n "$pkg" ]; do
			if [ -n "$pkg" ]; then
				install_apm_pkg "$pkg"
			fi
		done < ./atom/packages.txt

	fi

else

	echo "Homebrew is not installed."

fi
