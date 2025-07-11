#!/usr/bin/env bash

preload_brew_pkg_list() {
	BREW_PKG_LIST="$(brew list --formula -1)"
}

preload_npm_pkg_list() {
	NPM_PKG_LIST="$(npm list --global --depth=0)"
}

preload_cask_list() {
	CASK_LIST="$(brew list --cask -1)"
}

preload_gem_list() {
	GEM_LIST="$(gem list)"
}

preload_python_pkg_list() {
	PYTHON_PKG_LIST="$(uv tool list | grep -Po "^[a-z0-9\-]+(?= v)")"
}

preload_vscode_pkg_list() {
	VSCODE_PKG_LIST="$(code --list-extensions)"
}

preload_mas_app_list() {
	MAS_APP_LIST="$(mas list)"
}

is_cmd_installed() {
	type "$1" &> /dev/null
}

is_brew_pkg_installed() {
	echo "$BREW_PKG_LIST" | grep --extended-regexp --quiet "^$1(@|\$)"
}

is_node_version_installed() {
	[ -d ~/.fnm/node-versions/v"$1" ]
}

is_npm_pkg_installed() {
	if echo "$1" | grep --extended-regexp --quiet ".@."; then
		# If package argument contains version specifier, account for that
		echo "$NPM_PKG_LIST" \
			| grep --quiet " $(echo "$1" | grep -Po '.+(?=@)')"
	else
		echo "$NPM_PKG_LIST" | grep --quiet " $1@"
	fi
}

is_cask_installed() {
	echo "$CASK_LIST" | grep --quiet "^$1\$"
}

is_mas_app_installed() {
	echo "$MAS_APP_LIST" | grep --quiet "^$1 " || [ -e "/Applications/$2.app" ]
}

is_gem_installed() {
	echo "$GEM_LIST" | grep --quiet "^$1 "
}

is_python_pkg_installed() {
	echo "$PYTHON_PKG_LIST" | grep --quiet "\b$1\b"
}

is_vscode_pkg_installed() {
	echo "$VSCODE_PKG_LIST" | grep --quiet "^$1$"
}

tap_brew_repo() {
	brew tap "$@"
}

install_brew_pkg() {
	if ! is_brew_pkg_installed "$(basename "$1")"; then
		brew install "$@"
	fi
}

pin_brew_pkg() {
	brew pin "$@" 2> /dev/null
}

install_node_version() {
	if ! is_node_version_installed "$1"; then
		fnm install "$1"
		fnm use "$1"
		source ~/dotfiles/setup/install_npm_packages.sh
	fi
}

install_npm_pkg() {
	if ! is_npm_pkg_installed "$1"; then
		echo "Installing $1..."
		npm install --global "$@"
	fi
}

install_cask() {
	if ! is_cask_installed "$(basename "$1")"; then
		echo "Installing $1..."
		brew install --cask "$@"
	fi
}

install_mas_app() {
	local app_id="$1"
	local app_name="$2"
	if ! is_mas_app_installed "$app_id" "$app_name"; then
		echo "Installing $app_name..."
		mas install "$app_id"
	fi
}

install_gem() {
	if ! is_gem_installed "$1"; then
		echo "Installing $1..."
		gem install "$@"
	fi
}

install_python_pkg() {
	if ! is_python_pkg_installed "$1"; then
		echo "Installing $1..."
		uv tool install "$@"
	fi
}

install_vscode_pkg() {
	if ! is_vscode_pkg_installed "$1"; then
		code --install-extension "$@"
	fi
}
