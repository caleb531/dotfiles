#!/usr/bin/env bash

source ~/dotfiles/setup/header.sh

if ! is_cmd_installed brew; then

	echo "Installing Command Line Tools..."
	xcode-select --install

	echo "Installing Homebrew..."
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

fi

echo "Installing Homebrew packages..."
preload_brew_pkg_list

install_brew_pkg bash

if [ -f /usr/local/bin/bash -a "$SHELL" != /usr/local/bin/bash ]; then
	echo "Changing login shell to Bash 4..."
	sudo chsh -s /usr/local/bin/bash "$USER"
fi

install_brew_pkg bash-completion@2
install_brew_pkg colordiff
install_brew_pkg grep --with-default-names
install_brew_pkg rsync
# gnu-sed is required by diff-so-fancy
install_brew_pkg gnu-sed --with-default-names
# GNU ls is required for colored ls output
install_brew_pkg coreutils
install_brew_pkg tree
install_brew_pkg gnu-tar --with-default-names

install_brew_pkg git

install_brew_pkg openssl
install_brew_pkg python
install_brew_pkg python3

install_brew_pkg ssh-copy-id
install_brew_pkg trash

install_brew_pkg librsvg
# ImageMagick >=7.0.0 will currently break Ruby gems like rmagick
install_brew_pkg imagemagick@6
# imagemagick@6 is keg-only, so it must be linked explicitly
brew link --force imagemagick@6
# Pin ImageMagick because upgrading it can break plugins which depend on it
# (like the rmagick Jekyll plugin I use for my personal website)
pin_brew_pkg imagemagick
install_brew_pkg pandoc

install_brew_pkg ruby
pin_brew_pkg ruby

echo "Installing gems..."
preload_gem_list

install_gem sass
install_gem bundler
install_gem jekyll

# Instll Node via Homebrew but install npm separately to avoid conflicts
install_brew_pkg node
if ! cat ~/.npmrc | grep -q 'prefix=/usr/local/lib/npm-packages'; then
	echo "Setting npm prefix..."
	echo prefix=/usr/local/lib/npm-packages >> ~/.npmrc
fi
pin_brew_pkg node

echo "Installing npm packages..."
preload_npm_pkg_list

install_npm_pkg grunt-cli
install_npm_pkg brunch
install_npm_pkg diff-so-fancy
install_npm_pkg bower
install_npm_pkg http-server

# Install rmtree command for uninstalling packages and their leaf deps
tap_brew_repo beeftornado/rmtree
install_brew_pkg brew-rmtree

# macOS now disguises clang as gcc/g++. Install and link real gcc/g++
install_brew_pkg gcc
ln -sf /usr/local/bin/gcc-6 /usr/local/bin/gcc
ln -sf /usr/local/bin/g++-6 /usr/local/bin/g++

# Install identity-related packages
install_brew_pkg gnupg@2.0
install_brew_pkg pinentry-mac

echo "Installing pip packages..."
preload_pip_pkg_list

install_pip_pkg virtualenv
install_pip_pkg flake8

echo "Installing Atom packages..."
preload_apm_pkg_list

# Install Atom packages by reading each line from packages.cson file
while read -r pkg_line; do
	pkg="$(echo "$pkg_line" | grep -Po '(?<=")[a-z0-9\-]+(?=")')"
	if [ -n "$pkg" ]; then
		install_apm_pkg "$pkg"
	fi
done < ~/dotfiles/atom/packages.cson
