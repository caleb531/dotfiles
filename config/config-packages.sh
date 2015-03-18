#!/bin/bash

echo "Configuring Homebrew packages/applications..."

# Helper functions

is_installed() {
	type "$1" &> /dev/null
}

is_pkg_installed() {
	brew ls --versions "$1" &> /dev/null
}

is_app_installed() {
	brew cask ls "$1" &> /dev/null
}

is_tapped() {
	brew tap | grep "homebrew/versions" &> /dev/null
}

install_pkg() {
	if ! is_pkg_installed "$1"; then
		brew install "$@"
	else
		echo "Already installed: $1"
	fi
}

install_app() {
	if ! is_app_installed "$1"; then
		brew cask install "$@"
	else
		echo "Already installed: $1"
	fi
}

tap_repo() {
	if ! is_tapped "$1"; then
		brew tap "$@"
	fi
}

# Main configuration

if ! is_installed brew; then
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
	echo "Already installed: Homebrew"
fi

if is_installed brew; then

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
	# Ensure that all Cask-installed apps are linked to /Applications
	export HOMEBREW_CASK_OPTS='--appdir=/Applications'

	if is_pkg_installed brew-cask; then

		# Install essential OS X apps via Cask (in order of essentiality)
		install_app google-chrome
		install_app dropbox
		install_app alfred
		install_app atom
		install_app evernote
		install_app keyboard-maestro
		install_app skype
		install_app joinme
		install_app flux
		# Install additional (though not nearly as essential) OS X apps
		install_app namechanger
		install_app codekit
		install_app mamp

	fi

else

	echo "Homebrew is not installed. Stopping here."

fi
