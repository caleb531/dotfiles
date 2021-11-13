#!/usr/bin/env bash

source ~/dotfiles/setup/header.sh
# Load in environment variables for brew, nvm, node, etc.
source ~/dotfiles/terminal/bash/exports.sh

echo "Installing node..."

if [ ! -e ~/.nvm ]; then
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
	mkdir -p ~/.nvm
fi
source ~/dotfiles/terminal/bash/load_nvm.sh
install_node_version 16.5.0
nvm alias default 16.5.0

echo "Installing npm packages..."
preload_npm_pkg_list

install_npm_pkg gulp-cli
install_npm_pkg eslint
install_npm_pkg typescript
install_npm_pkg http-server
install_npm_pkg grunt-cli
install_npm_pkg vsce

install_node_version 12.16.3 --reinstall-packages-from=default
