#!/usr/bin/env bash

source ~/dotfiles/setup/header.sh
source ~/dotfiles/terminal/bash/exports.sh

echo "Installing pip packages..."
preload_pip_pkg_list

install_pip_pkg virtualenv
install_pip_pkg flake8
install_pip_pkg bump-anything
# Aider does not support Python 3.13 yet (source:
# <https://github.com/Aider-AI/aider/issues/2391#issuecomment-2525674695>)
install_pip_pkg aider-chat --python python3.12
install_pip_pkg imessage-conversation-analyzer
