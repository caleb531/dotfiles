#!/usr/bin/env bash

source ~/dotfiles/setup/header.sh
# Only load the exports and fnm if they are not already loaded (which is only
# the case when this script is run as executable; if the script is sourced, them
# everything should already be available, and re-loading things will cause the
# node version to switch back to the default)
if ! type node &> /dev/null; then
	source ~/dotfiles/terminal/bash/exports.sh
	source ~/dotfiles/terminal/bash/load_fnm.sh
fi

echo "Installing npm packages (node $(node -v))..."
preload_npm_pkg_list

install_npm_pkg pnpm
install_npm_pkg gulp-cli
install_npm_pkg eslint
install_npm_pkg http-server
install_npm_pkg vsce
install_npm_pkg typescript
install_npm_pkg npm-check-updates
install_npm_pkg vite-bundle-visualizer
