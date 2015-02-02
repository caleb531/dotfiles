#/bin/bash

echo "Configuring Homebrew packages..."

# Helper functions

is_installed() {
	type "$1" &> /dev/null
}

is_pkg_installed() {
	brew ls | grep "$1" &> /dev/null
}

is_tapped() {
	brew tap | grep homebrew/versions &> /dev/null
}

install_pkg() {
	if ! is_pkg_installed "$1"; then
		echo "Installing $1..."
		brew install "$@"
	else
		echo "Already installed: $1"
	fi
}

tap_repo() {
	if ! is_tapped "$1"; then
		echo "Tapping $1..."
		brew tap "$@"
	else
		echo "Already tapped: $1"
	fi
}

# Main configiration

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
	install_pkg tree
	install_pkg coreutils

	# Install additional packages for personal use
	install_pkg git
	install_pkg python
	install_pkg python3
	install_pkg node

else

	echp "Homebrew is not installed. Stoppping here."

fi
