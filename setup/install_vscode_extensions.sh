#!/usr/bin/env bash

source ~/dotfiles/setup/header.sh
source ~/dotfiles/terminal/bash/exports.sh

echo "Installing VS Code packages..."
preload_vscode_pkg_list

while read -r pkg_name; do
	if [ -n "$pkg_name" ]; then
		install_vscode_pkg "$pkg_name"
	fi
done < ~/dotfiles/vscode/extensions.txt
