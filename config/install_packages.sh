#!/usr/bin/env bash

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

	if [ -f /usr/local/bin/bash -a "$SHELL" != /usr/local/bin/bash ]; then
		echo "Changing login shell to Bash 4..."
		sudo chsh -s /usr/local/bin/bash "$USER"
	else
		echo "Login shell already set to Bash 4"
	fi

	tap_brew_repo homebrew/versions
	install_brew_pkg bash-completion2
	install_brew_pkg colordiff
	tap_brew_repo homebrew/dupes
	install_brew_pkg grep --with-default-names
	# gnu-sed is required by diff-so-fancy
	install_brew_pkg gnu-sed --with-default-names
	# GNU ls is required for colored ls output
	install_brew_pkg coreutils
	install_brew_pkg tree

	install_brew_pkg git

	install_brew_pkg python
	install_brew_pkg python3
	# Always use Python 3 pip
	ln -sf /usr/local/bin/pip3 /usr/local/bin/pip

	install_brew_pkg ssh-copy-id
	install_brew_pkg closure-compiler

	install_brew_pkg speedtest_cli
	# Prefer speedtest-cli over speedtest_cli command
	rm -f /usr/local/bin/speedtest_cli

	if ! is_brew_pkg_installed librsvg; then
		# librsvg 2.40.11 and newer are broken; use working 2.40.10 release
		install_brew_pkg 'https://raw.githubusercontent.com/Homebrew/homebrew/136cb2216d3f23b2b10d89a71200d8ca0c1ca592/Library/Formula/librsvg.rb'
	else
		echo "Already installed: librsvg"
	fi
	pin_brew_pkg librsvg

	# Install utilities necessary for Grunt projects
	install_brew_pkg ruby
	pin_brew_pkg ruby
	if is_cmd_installed gem; then
		install_gem sass
	else
		echo "Skipping Ruby gems; gem command not installed"
	fi

	# Instll Node via Homebrew but install npm separately to avoid conflicts
	install_brew_pkg node --without-npm
	if ! cat ~/.npmrc | grep -q 'prefix=/usr/local/lib/npm-packages'; then
		echo "Setting npm prefix..."
		echo prefix=/usr/local/lib/npm-packages >> ~/.npmrc
	else
		echo "Correct npm prefix already set"
	fi

	if ! is_cmd_installed npm; then
		echo "Installing npm..."
		curl -L https://www.npmjs.com/install.sh | sh
	else
		echo "Already installed: npm"
	fi

	if [ ! -f /usr/local/etc/bash_completion.d/npm ]; then
		npm completion > /usr/local/etc/bash_completion.d/npm
	fi

	if is_cmd_installed npm; then

		echo "Installing npm packages..."

		install_npm_pkg grunt-cli
		install_npm_pkg diff-so-fancy
		install_npm_pkg bower

	else

		echo "Skipping npm packages; npm command not installed"

	fi

	# Install rmtree command for uninstalling packages and their leaf deps
	tap_brew_repo beeftornado/rmtree
	install_brew_pkg brew-rmtree

	# OS X now disguises clang as gcc/g++. Install and link real gcc/g++
	install_brew_pkg gcc
	ln -sf /usr/local/bin/gcc-5 /usr/local/bin/gcc
	ln -sf /usr/local/bin/g++-5 /usr/local/bin/g++

	if is_cmd_installed pip; then

		echo "Installing pip packages..."

		install_pip_pkg virtualenv
		install_pip_pkg flake8
		install_pip_pkg pep8-naming

	else

		echo "Skipping pip packages; pip command not installed"

	fi

	if is_cmd_installed apm; then

		echo "Installing Atom packages..."

		# Install Atom packages by reading each line from packages.txt file
		while read -r pkg; do
			install_apm_pkg "$pkg"
		done < ./atom/packages.txt

	else

		echo "Skipping Atom packages; apm command not installed"

	fi

	install_brew_pkg clisp

else

	echo "Homebrew is not installed."

fi
