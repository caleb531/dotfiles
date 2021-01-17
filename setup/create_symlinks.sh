#!/usr/bin/env bash

echo "Creating symlinks..."

# Symlink Atom configuration
mkdir -p ~/.atom
ln -sf ~/dotfiles/atom/* ~/.atom
# Prevent conflicts between init.js and an existing init.coffee symlink
rm -f ~/.atom/init.coffee
ln -sf ~/dotfiles/atom/.editorconfig ~/.atom

# Symlink Bash configuration
ln -sf ~/dotfiles/terminal/.bashrc ~/.bashrc
ln -sf ~/dotfiles/terminal/.bashrc ~/.bash_profile

# Symlink Zsh configuration
ln -sf ~/dotfiles/terminal/.zshrc ~/.zshrc

# Symlink miscellaneous configuration
ln -sf ~/dotfiles/terminal/.hyper.js ~/.hyper.js
ln -sf ~/dotfiles/terminal/.vimrc ~/.vimrc
ln -sf ~/dotfiles/terminal/.sqliterc ~/.sqliterc
ln -sf ~/dotfiles/git/.gitconfig ~/.gitconfig
ln -sf ~/Library/Containers/com.pixelresearchlabs.osx.ringer/Data/Documents/Ringer ~/Music/Ringer

# Symlink pip configuration
mkdir -p ~/Library/Application\ Support/pip
ln -sf ~/dotfiles/terminal/pip.conf ~/Library/Application\ Support/pip/pip.conf

# Symlink SSH configuration
mkdir -p ~/.ssh
ln -sf ~/dotfiles/ssh/ssh_config ~/.ssh/config

# Symlink GPG configuration
mkdir -p ~/.gnupg
ln -sf ~/dotfiles/gpg/* ~/.gnupg

# Symlink Firefox browser styles
pushd ~/Library/Application\ Support/Firefox/Profiles/*.default 2> /dev/null || exit
mkdir -p chrome
ln -sf ~/dotfiles/firefox/userChrome.css "$PWD"/chrome/userChrome.css
popd > /dev/null || exit

# Create PyPI configuration if it doesn't already exist
ln -sf ~/dotfiles/terminal/.pypirc ~/.pypirc

# Disable Bash Sessions feature in macOS El Capitan
touch ~/.bash_sessions_disable
