#!/usr/bin/env bash

source ~/dotfiles/setup/header.sh
# Load in environment variables for brew, nvm, node, etc.
source ~/dotfiles/terminal/bash/exports.sh
# Load nvm so that the node and npm commands are available
source ~/dotfiles/terminal/bash/load_nvm.sh

echo "Installing npm packages..."
preload_npm_pkg_list

install_npm_pkg gulp-cli
install_npm_pkg eslint
install_npm_pkg @typescript-eslint/parser
install_npm_pkg @typescript-eslint/eslint-plugin
install_npm_pkg http-server
install_npm_pkg grunt-cli
install_npm_pkg vsce
install_npm_pkg typescript
install_npm_pkg ts-node
install_npm_pkg esbuild
install_npm_pkg npm-check-updates
install_npm_pkg netlify-cli
