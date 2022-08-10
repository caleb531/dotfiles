#!/usr/bin/env bash

source ~/dotfiles/setup/header.sh
# Load in environment variables for brew, nvm, node, etc.
source ~/dotfiles/terminal/bash/exports.sh

echo "Installing node..."

if [ ! -e ~/.nvm ]; then
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
	mkdir -p ~/.nvm
fi
source ~/dotfiles/terminal/bash/load_nvm.sh
install_node_version 16.16.0
nvm alias default 16.16.0
