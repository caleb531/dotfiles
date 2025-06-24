#!/usr/bin/env bash

source ~/dotfiles/setup/header.sh
source ~/dotfiles/terminal/bash/exports.sh

echo "Installing pip packages..."
preload_pip_pkg_list

install_pip_pkg uv
install_pip_pkg flake8
install_pip_pkg bump-anything
install_pip_pkg imessage-conversation-analyzer
