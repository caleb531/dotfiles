#!/usr/bin/env bash

source ~/dotfiles/setup/header.sh
# Load in environment variables for brew, nvm, node, etc.
source ~/dotfiles/terminal/bash/exports.sh

echo "Installing Atom packages..."
preload_apm_pkg_list

while read -r pkg_line; do
	pkg_name="$(echo "$pkg_line" | grep -Po '(?<=")[a-z0-9\-]+(?=")')"
	if [ -n "$pkg_name" ]; then
		install_apm_pkg "$pkg_name"
	fi
done < ~/dotfiles/atom/packages.cson
