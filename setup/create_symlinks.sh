#!/usr/bin/env bash

echo "Creating symlinks..."

# Symlink Atom configuration
mkdir -p ~/.atom
ln -sf ~/dotfiles/atom/* ~/.atom
ln -sf ~/dotfiles/atom/.editorconfig ~/.atom

# Symlink Bash configuration
ln -snf ~/dotfiles/terminal/.bashrc ~/.bashrc
ln -snf ~/dotfiles/terminal/.bashrc ~/.bash_profile

# Symlink miscellaneous configuration
ln -snf ~/dotfiles/terminal/.hyper.js ~/.hyper.js
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

# Symlink Firefox browser styles
pushd ~/Library/Application\ Support/Firefox/Profiles/*.default > /dev/null || exit
mkdir -p chrome
ln -sf ~/dotfiles/firefox/userChrome.css "$PWD"/chrome/userChrome.css
popd > /dev/null || exit

# Create PyPI configuration if it doesn't already exist
ln -snf ~/dotfiles/terminal/.pypirc ~/.pypirc

# Disable Bash Sessions feature in macOS El Capitan
touch ~/.bash_sessions_disable
