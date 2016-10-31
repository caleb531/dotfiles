#!/usr/bin/env bash

source ./setup/header.sh

echo "Creating symlinks..."

# Symlink Atom configuration
mkdir -p ~/.atom
ln -sf "$PWD"/atom/* ~/.atom

# Symlink Bash configuration
ln -snf "$PWD"/terminal/.bashrc ~/.bashrc
ln -snf "$PWD"/terminal/.bashrc ~/.bash_profile

# Symlink custom completions and remove overridden completions
ln -snf "$PWD"/terminal/bash/completions.sh /usr/local/etc/bash_completion.d/dotfiles-completions.sh
rm -f /usr/local/etc/bash_completion.d/brew
rm -f /usr/local/etc/bash_completion.d/npm

# Symlink miscellaneous configuration
ln -snf "$PWD"/terminal/.vimrc ~/.vimrc
ln -snf "$PWD"/git/.gitconfig ~/.gitconfig

# Symlink SSH configuration
mkdir -p ~/.ssh
mkdir -p ~/.ssh/sockets
ln -snf "$PWD"/ssh/ssh_config ~/.ssh/config

mkdir -p ~/.gnupg
ln -sf "$PWD"/gpg/* ~/.gnupg

# Disable Bash Sessions feature in OS X El Capitan
touch ~/.bash_sessions_disable
