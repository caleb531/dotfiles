#!/usr/bin/env bash

preload_brew_pkg_list() {
	BREW_PKG_LIST="$(brew list -1)"
}

preload_npm_pkg_list() {
	NPM_PKG_LIST="$(npm list --global --depth=0)"
}

preload_cask_list() {
	CASK_LIST="$(brew cask list -1)"
}

preload_gem_list() {
	GEM_LIST="$(gem list)"
}

preload_pip_pkg_list() {
	PIP_PKG_LIST="$(pip3 list)"
}

preload_apm_pkg_list() {
	APM_PKG_LIST="$(apm list --installed --bare)"
}

is_cmd_installed() {
	type "$1" &> /dev/null
}

is_brew_pkg_installed() {
	echo "$BREW_PKG_LIST" | grep --quiet "^$1\$"
}

is_node_version_installed() {
	[ -d "$N_PREFIX"/n/versions/node/"$1" ]
}

is_npm_pkg_installed() {
	echo "$NPM_PKG_LIST" | grep --quiet " $1@"
}

is_cask_installed() {
	echo "$CASK_LIST" | grep --quiet "^$1\$"
}

is_mas_app_installed() {
	ls /Applications | grep --quiet "^$*"
}

is_gem_installed() {
	echo "$GEM_LIST" | grep --quiet "^$1 "
}

is_pip_pkg_installed() {
	echo "$PIP_PKG_LIST" | grep --quiet "^$1=="
}

is_apm_pkg_installed() {
	echo "$APM_PKG_LIST" | grep --quiet "^$1@"
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
		n "$1"
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
		brew cask install "$@"
	fi
}

install_mas_app() {
	if ! is_mas_app_installed "$1"; then
		echo "Installing $*..."
		local search_result="$(mas search "$*" | head -n 1)"
		local app_id="$(echo "$search_result" | awk '{ print $1 }')"
		local app_name="$(echo "$search_result" | awk '{ $1=""; print $0 }' | xargs)"
		if [[ "$app_name" == "$*"* ]]; then
			mas install "$app_id"
		else
			>&2 echo "App name mismatch: requested $*, but found $app_name"
		fi
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
		pip3 install "$@"
	fi
}

install_apm_pkg() {
	if ! is_apm_pkg_installed "$1"; then
		apm install "$@"
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
		unzip -q "$dest_archive" -d "$dest_dir"
		rm -rf "$temp_dir"
	fi
}
