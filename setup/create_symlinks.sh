#!/usr/bin/env bash

echo "Creating symlinks..."

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
cp -n ~/dotfiles/git/default-user.inc.gitconfig ~/user.inc.gitconfig 2> /dev/null
ln -sf ~/Library/Containers/com.pixelresearchlabs.osx.ringer/Data/Documents/Ringer ~/Music/Ringer

# Symlink pip configuration
mkdir -p ~/Library/Application\ Support/pip
ln -sf ~/dotfiles/terminal/pip.conf ~/Library/Application\ Support/pip/pip.conf

# Symlink SSH configuration
mkdir -p ~/.ssh
ln -sf ~/dotfiles/ssh/ssh_config ~/.ssh/config

# Symlink GPG configuration
mkdir -p ~/.gnupg
ln -sf ~/dotfiles/gpg/gpg.conf ~/.gnupg/gpg.conf
# gpg-agent.conf can't resolve ~ to my home folder, so we must use sed to
# evaluate the path
rm ~/.gnupg/gpg-agent.conf
cat ~/dotfiles/gpg/gpg-agent.conf | sed "s|~|$HOME|g" > ~/.gnupg/gpg-agent.conf

# Create PyPI configuration if it doesn't already exist
ln -sf ~/dotfiles/terminal/.pypirc ~/.pypirc

# Disable Bash Sessions feature in macOS El Capitan
touch ~/.bash_sessions_disable

# Create Sync directory ahead of time so it can be chosen during the Sync app
# setup process
mkdir -p ~/Sync

# Symlink VSCode configuration
symlink_vscode() {
	local config_dir="$1"/User
	mkdir -p "$config_dir"
	pushd "$config_dir" &> /dev/null || return
	rm -rf snippets
	ln -sf ~/dotfiles/vscode/settings.json settings.json
	ln -sf ~/dotfiles/vscode/init.ts init.ts
	ln -sf ~/dotfiles/vscode/keybindings.json keybindings.json
	ln -snf ~/dotfiles/vscode/snippets snippets
	popd &> /dev/null || return
}
symlink_vscode ~/Library/Application\ Support/Code
symlink_vscode ~/Library/Application\ Support/Code\ -\ Insiders

# Symlink Firefox browser styles (these custom styles will only take effect
# when the 'toolkit.legacyUserProfileCustomizations.stylesheets' about:config
# setting has been enabled)
symlink_firefox() {
	pushd ~/Library/Application\ Support/Firefox/Profiles/*.default-release &> /dev/null || return
	mkdir -p chrome
	ln -sf ~/dotfiles/firefox/userChrome.css "$PWD"/chrome/userChrome.css
	popd &> /dev/null || return
}
symlink_firefox
