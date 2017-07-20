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
# Installing grep using --with-default-names makes the installation take about
# 40x longer, so manually symlink non-prefixed names instead
install_brew_pkg grep
ln -sf /usr/local/bin/ggrep /usr/local/bin/grep
ln -sf /usr/local/bin/gegrep /usr/local/bin/egrep
ln -sf /usr/local/bin/gfgrep /usr/local/bin/fgrep
install_brew_pkg rsync
# GNU ls is required for colored ls output
install_brew_pkg coreutils
install_brew_pkg tree

install_brew_pkg git

install_brew_pkg openssl
install_brew_pkg python
install_brew_pkg python3

install_brew_pkg ssh-copy-id

install_brew_pkg librsvg
# ImageMagick >=7.0.0 will currently break Ruby gems like rmagick
install_brew_pkg imagemagick@6
install_brew_pkg pandoc

install_brew_pkg ruby
pin_brew_pkg ruby

echo "Installing gems..."
preload_gem_list

install_gem sass
install_gem bundler
install_gem jekyll

install_brew_pkg node
if ! cat ~/.npmrc | grep -q 'prefix=/usr/local/lib/npm-packages'; then
	echo "Setting npm prefix..."
	echo prefix=/usr/local/lib/npm-packages >> ~/.npmrc
fi

echo "Installing npm packages..."
preload_npm_pkg_list

install_npm_pkg grunt-cli
install_npm_pkg brunch
install_npm_pkg diff-so-fancy
install_npm_pkg http-server

# Install rmtree command for uninstalling packages and their leaf deps
tap_brew_repo beeftornado/rmtree
install_brew_pkg brew-rmtree

# Install identity-related packages
install_brew_pkg gnupg@2.0
install_brew_pkg pinentry-mac

echo "Installing pip packages..."
preload_pip_pkg_list

install_pip_pkg virtualenv
install_pip_pkg flake8
install_pip_pkg memory_profiler
install_pip_pkg psutil

echo "Installing Atom packages..."
preload_apm_pkg_list

while read -r pkg_line; do
	pkg_name="$(echo "$pkg_line" | grep -Po '(?<=")[a-z0-9\-]+(?=")')"
	if [ -n "$pkg_name" ]; then
		install_apm_pkg "$pkg_name"
	fi
done < ~/dotfiles/atom/packages.cson
