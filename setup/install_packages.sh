#!/usr/bin/env bash

source ~/dotfiles/setup/header.sh
# Load in environment variables for brew, n, node, etc.
source ~/dotfiles/terminal/bash/exports.sh

echo "Installing Homebrew packages..."
preload_brew_pkg_list

install_brew_pkg bash

if [ -f "$BREW_PREFIX"/bin/bash ] && [ "$SHELL" != "$BREW_PREFIX"/bin/bash ]; then
	echo "Changing login shell to Bash 4..."
	sudo chsh -s "$BREW_PREFIX"/bin/bash "$USER"
fi

install_brew_pkg bash-completion@2
# Installing grep using --with-default-names makes the installation take about
# 40x longer, so manually symlink non-prefixed names instead
install_brew_pkg grep
ln -sf "$BREW_PREFIX"/bin/ggrep "$BREW_PREFIX"/bin/grep
ln -sf "$BREW_PREFIX"/bin/gegrep "$BREW_PREFIX"/bin/egrep
ln -sf "$BREW_PREFIX"/bin/gfgrep "$BREW_PREFIX"/bin/fgrep
install_brew_pkg gnu-sed
ln -sf "$BREW_PREFIX"/bin/gsed "$BREW_PREFIX"/bin/sed
install_brew_pkg rsync
# GNU ls is required for colored ls output
install_brew_pkg coreutils
install_brew_pkg tree

install_brew_pkg git
install_brew_pkg diff-so-fancy

install_brew_pkg openssl
install_brew_pkg python
install_brew_pkg ical-buddy

install_brew_pkg ssh-copy-id
tap_brew_repo heroku/brew
install_brew_pkg heroku

install_brew_pkg duti
install_brew_pkg cowsay

install_brew_pkg librsvg
# ImageMagick >=7.0.0 will currently break Ruby gems like rmagick
install_brew_pkg imagemagick@6

# Install identity-related packages
install_brew_pkg gnupg
install_brew_pkg pinentry-mac
# Because the Homebrew prefix directory differs between Intel and ARM Macs, the
# path to the pinentry-mac program will also differ between the two
# architectures; this creates a problem because the gpg-agent.conf expects only
# a single path, and if that path ios not architecture-agnostic, then it will
# break GPG signing for Git commits; to solve this, create a symlink whose path
# will be the same across all architectures, then simply reference that symlink
# in my gpg-agent.conf
sudo mkdir -p "$GPG_BIN_DIR"
sudo chown "$USER":admin "$GPG_BIN_DIR"
mkdir -p "$GPG_BIN_DIR"
ln -s "$BREW_PREFIX"/bin/pinentry-mac "$GPG_BIN_DIR"/pinentry-mac

# Install Mac App Store command-line utility
install_brew_pkg mas

install_brew_pkg ruby@2

echo "Installing gems..."
preload_gem_list

install_gem bundler
install_gem jekyll

echo "Installing node..."

if ! is_cmd_installed n; then
	curl -L https://git.io/n-install | bash -s -- -y -n -
fi

install_node_version "$DEFAULT_NODE_VERSION"
n "$DEFAULT_NODE_VERSION"

echo "Installing npm packages..."
preload_npm_pkg_list

install_npm_pkg gulp-cli
install_npm_pkg http-server
install_npm_pkg grunt-cli

echo "Installing pip packages..."
preload_pip_pkg_list

install_pip_pkg virtualenv
install_pip_pkg flake8
install_pip_pkg bump-anything

echo "Installing Atom packages..."
preload_apm_pkg_list

while read -r pkg_line; do
	pkg_name="$(echo "$pkg_line" | grep -Po '(?<=")[a-z0-9\-]+(?=")')"
	if [ -n "$pkg_name" ]; then
		install_apm_pkg "$pkg_name"
	fi
done < ~/dotfiles/atom/packages.cson
