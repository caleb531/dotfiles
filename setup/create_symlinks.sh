#!/usr/bin/env bash

echo "Creating symlinks..."

# Symlink Atom configuration
mkdir -p ~/.atom
ln -sf ~/dotfiles/atom/* ~/.atom
# Also symlink hidden files (like .editorconfig)
ln -sf ~/dotfiles/atom/.[!.]* ~/.atom

# Symlink Bash configuration
ln -snf ~/dotfiles/terminal/.bashrc ~/.bashrc
ln -snf ~/dotfiles/terminal/.bashrc ~/.bash_profile

# Symlink miscellaneous configuration
ln -snf ~/dotfiles/terminal/.vimrc ~/.vimrc
ln -snf ~/dotfiles/git/.gitconfig ~/.gitconfig

# Symlink pip configuration
mkdir -p ~/Library/Application\ Support/pip
ln -snf ~/dotfiles/terminal/pip.conf ~/Library/Application\ Support/pip/pip.conf

# Symlink SSH configuration
mkdir -p ~/.ssh
ln -snf ~/dotfiles/ssh/ssh_config ~/.ssh/config

# Symlink GPG configuration
mkdir -p ~/.gnupg
ln -sf ~/dotfiles/gpg/* ~/.gnupg

# Disable Bash Sessions feature in macOS El Capitan
touch ~/.bash_sessions_disable
