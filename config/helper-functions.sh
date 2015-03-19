#!/bin/bash

is_installed() {
	type "$1" &> /dev/null
}

is_pkg_installed() {
	brew ls -1 | grep -q "^$1\$"
}

is_npm_pkg_installed() {
	npm ls -g --depth=0 | grep -q " $1@"
}

is_cask_installed() {
	brew cask ls -1 | grep -q "^$1\$"
}

is_tapped() {
	brew tap | grep "$1" &> /dev/null
}

tap_repo() {
	if ! is_tapped "$1"; then
		brew tap "$@"
	fi
}

install_pkg() {
	if ! is_pkg_installed "$1"; then
		brew install "$@"
	else
		echo "Already installed: $1"
	fi
}

install_npm_pkg() {
	if ! is_npm_pkg_installed "$1"; then
		npm install -g "$@"
	else
		echo "Already installed: $1"
	fi
}

install_cask() {
	if ! is_cask_installed "$1"; then
		echo "Installing $1..."
		brew cask install "$@"
	else
		echo "Already installed: $1"
	fi
}
