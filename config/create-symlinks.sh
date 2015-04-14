#!/bin/bash

source ./config/header.sh

echo "Creating symlinks..."

mkdir -p ~/.atom
ln -sf "$PWD"/atom/* ~/.atom
ln -snf "$PWD"/emmet ~/.emmet

ln -snf "$PWD"/terminal/.bash_profile ~/.bash_profile
ln -snf "$PWD"/terminal/bash ~/.bash

ln -snf "$PWD"/terminal/.vimrc ~/.vimrc
ln -snf "$PWD"/terminal/.gitconfig ~/.gitconfig

ln -snf "$PWD"/ssh/config ~/.ssh/config
