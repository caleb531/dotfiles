#!/bin/bash

source ./config/header.sh

echo "Creating symlinks..."

# Force create symlinks

ln -snf "$PWD"/atom ~/.atom
ln -snf "$PWD"/emmet ~/.emmet

ln -snf "$PWD"/terminal/bash/.bash_profile ~/.bash_profile
rm -rf ~/.bash
mkdir ~/.bash
ln -sf "$PWD"/terminal/bash/* ~/.bash

ln -snf "$PWD"/terminal/.vimrc ~/.vimrc
ln -snf "$PWD"/terminal/.gitconfig ~/.gitconfig
