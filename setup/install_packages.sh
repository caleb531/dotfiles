#!/usr/bin/env bash

source ~/dotfiles/setup/header.sh
source ~/dotfiles/terminal/bash/exports.sh

echo "Installing Homebrew packages..."
preload_brew_pkg_list
preload_cask_list

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
# The jq utility (used for JSON-parsing on the shell)
install_brew_pkg jq

install_brew_pkg git
install_brew_pkg diff-so-fancy

install_brew_pkg openssl
install_brew_pkg python
# Install uv via standalone installer (the recommended method; see
# <https://docs.astral.sh/uv/getting-started/installation/> for alternative
# installation methods)
curl -LsSf https://astral.sh/uv/install.sh | sh

install_brew_pkg ssh-copy-id

install_brew_pkg duti
install_brew_pkg shellcheck
install_brew_pkg cowsay

install_brew_pkg librsvg
install_brew_pkg imagemagick
# Allow pydot to render visualizations for Python projects
install_brew_pkg gprof2dot
install_brew_pkg smartmontools
install_brew_pkg wget
install_brew_pkg editorconfig
install_brew_pkg graphviz

# Install Supabase CLI and its dependencies
install_cask docker-desktop
install_brew_pkg supabase/tap/supabase

# Install Mac App Store command-line utility
install_brew_pkg mas

~/dotfiles/setup/install_node.sh
~/dotfiles/setup/install_python_packages.sh
~/dotfiles/setup/install_vscode_packages.sh
