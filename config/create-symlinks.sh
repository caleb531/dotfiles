#!/bin/bash

if [ -z "$CONFIG_ALL" ]; then
	cd "$(dirname "$0")"/..
fi

echo "Creating symlinks..."

# Force create symlinks
ln -snfv "$PWD/atom" ~/.atom
ln -snfv "$PWD/emmet" ~/emmet
ln -snfv "$PWD/terminal/.bash_profile" ~/.bash_profile
ln -snfv "$PWD/terminal/.vimrc" ~/.vimrc
ln -snfv "$PWD/terminal/.gitconfig" ~/.gitconfig
