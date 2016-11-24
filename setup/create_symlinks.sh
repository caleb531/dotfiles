#!/usr/bin/env bash

echo "Creating symlinks..."

# Symlink Atom configuration
mkdir -p ~/.atom
ln -sf ~/dotfiles/atom/* ~/.atom

# Symlink Bash configuration
ln -snf ~/dotfiles/terminal/.bashrc ~/.bashrc
ln -snf ~/dotfiles/terminal/.bashrc ~/.bash_profile

# Symlink custom completions and remove overridden completions
ln -snf ~/dotfiles/terminal/bash/completions.sh /usr/local/etc/bash_completion.d/dotfiles-completions.sh
rm -f /usr/local/etc/bash_completion.d/brew
rm -f /usr/local/etc/bash_completion.d/npm

# Symlink miscellaneous configuration
ln -snf ~/dotfiles/terminal/.vimrc ~/.vimrc
ln -snf ~/dotfiles/git/.gitconfig ~/.gitconfig

# Symlink SSH configuration
mkdir -p ~/.ssh
mkdir -p ~/.ssh/sockets
ln -snf ~/dotfiles/ssh/ssh_config ~/.ssh/config

mkdir -p ~/.gnupg
ln -sf ~/dotfiles/gpg/* ~/.gnupg

# Disable Bash Sessions feature in OS X El Capitan
touch ~/.bash_sessions_disable
