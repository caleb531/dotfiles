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

mkdir -p ~/.ssh
ln -snf "$PWD"/ssh/config ~/.ssh/config

# Symlinks for personal configuration
source ./personal/config/create_symlinks.sh 2> /dev/null

# Disable Bash Sessions feature in OS X El Capitan
touch ~/.bash_sessions_disable
