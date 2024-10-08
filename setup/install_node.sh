#!/usr/bin/env bash

source ~/dotfiles/setup/header.sh
source ~/dotfiles/terminal/bash/exports.sh

echo "Installing node..."

if [ ! -e ~/.fnm ]; then
	# The ~/.fnm directory must exist in order for the below fnm installer
	# script to install there; otherwise, fnm will be installed to
	# ~/Library/Application Support/fnm
	mkdir -p ~/.fnm
	curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
fi
source ~/dotfiles/terminal/bash/load_fnm.sh
DEFAULT_NODE_VERSION=20
install_node_version "$DEFAULT_NODE_VERSION"
fnm default "$DEFAULT_NODE_VERSION"
