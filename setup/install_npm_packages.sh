#!/usr/bin/env bash

source ~/dotfiles/setup/header.sh
source ~/dotfiles/terminal/bash/exports.sh
source ~/dotfiles/terminal/bash/load_fnm.sh

echo "Installing npm packages (node $(node -v))..."
preload_npm_pkg_list

install_npm_pkg pnpm
install_npm_pkg gulp-cli
install_npm_pkg eslint
install_npm_pkg http-server
install_npm_pkg vsce
install_npm_pkg typescript
install_npm_pkg npm-check-updates
