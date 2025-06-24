#!/usr/bin/env bash

source ~/dotfiles/setup/header.sh
source ~/dotfiles/terminal/bash/exports.sh

echo "Installing global python packages..."
preload_python_pkg_list

install_python_pkg ruff
install_python_pkg bump-anything
install_python_pkg imessage-conversation-analyzer
