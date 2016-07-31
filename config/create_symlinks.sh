#!/usr/bin/env bash

source ./config/header.sh

echo "Creating symlinks..."

mkdir -p ~/.atom
ln -sf "$PWD"/atom/* ~/.atom

ln -snf "$PWD" ~/.dotfiles
ln -snf "$PWD"/terminal/.bashrc ~/.bashrc
ln -snf "$PWD"/terminal/.bashrc ~/.bash_profile
ln -snf "$PWD"/terminal/bash/completions.sh /usr/local/etc/bash_completion.d/dotfiles-completions.sh

ln -snf "$PWD"/terminal/.vimrc ~/.vimrc
ln -snf "$PWD"/git/.gitconfig ~/.gitconfig

mkdir -p ~/.ssh
mkdir -p ~/.ssh/sockets
ln -snf "$PWD"/ssh/ssh_config ~/.ssh/config

# Disable Bash Sessions feature in OS X El Capitan
touch ~/.bash_sessions_disable
