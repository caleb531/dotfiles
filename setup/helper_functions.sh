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

preload_pip_pkg_list() {
	PIP_PKG_LIST="$(pipx list --short | awk '{print $1}')"
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

is_pip_pkg_installed() {
	echo "$PIP_PKG_LIST" | grep --quiet "\b$1\b"
}

is_vscode_pkg_installed() {
	echo "$VSCODE_PKG_LIST" | grep --quiet "^$1$"
}

tap_brew_repo() {
	brew tap "$@"
}

install_brew_pkg() {
	if ! is_brew_pkg_installed "$1"; then
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
	if ! is_cask_installed "$1"; then
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

install_pip_pkg() {
	if ! is_pip_pkg_installed "$1"; then
		echo "Installing $1..."
		pipx install "$@"
	fi
}

install_vscode_pkg() {
	if ! is_vscode_pkg_installed "$1"; then
		code --install-extension "$@"
	fi
}

install_font() {
	local font_name="$1"
	local dest_dir=~/Library/Fonts/"$font_name"
	if [[ ! -d "$dest_dir" || -z "$(ls "$dest_dir"/*.ttf 2> /dev/null)" ]]; then
		echo "Installing $font_name..."
		local temp_dir="$(mktemp -d)"
		local dest_archive="$temp_dir"/"$font_name".zip
		curl \
			--get \
			--data-urlencode "family=$font_name" \
			--progress \
			'https://fonts.google.com/download' \
			> "$dest_archive"
		rm -rf "$dest_dir"
		unzip -q "$dest_archive" -d "$dest_dir"
		rm -rf "$temp_dir"
	fi
}
