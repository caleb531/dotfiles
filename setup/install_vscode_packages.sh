#!/usr/bin/env bash

source ~/dotfiles/setup/header.sh
# Load in environment variables for brew, nvm, node, etc.
source ~/dotfiles/terminal/bash/exports.sh

echo "Installing VS Code packages..."
preload_vscode_pkg_list

while read -r pkg_line; do
	pkg_name="$(echo "$pkg_line" | grep -Po '(?<=")[A-Za-z0-9\-\.]+(?=")')"
	if [ -n "$pkg_name" ]; then
		install_vscode_pkg "$pkg_name"
	fi
done < ~/dotfiles/vscode/packages.json
