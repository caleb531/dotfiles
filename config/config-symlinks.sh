#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"/..

echo "Configuring symlinks..."

# Force create symlinks
ln -snf "$PWD/atom" ~/.atom
ln -snf "$PWD/emmet" ~/emmet
ln -snf "$PWD/terminal/.bash_profile" ~/.bash_profile
ln -snf "$PWD/terminal/.vimrc" ~/.vimrc
ln -snf "$PWD/terminal/.gitconfig" ~/.gitconfig
