#!/usr/bin/env bash

source ~/dotfiles/setup/header.sh

if is_brew_pkg_installed node; then
	brew uninstall node
fi
if is_brew_pkg_installed n; then
	brew uninstall n
fi

sudo rm -rfv \
	/usr/local/bin/npm \
	/usr/local/bin/node \
	/usr/local/share/man/man1/node* \
	/usr/local/lib/dtrace/node.d \
	~/.npm \
	~/.node-gyp \
	/opt/local/bin/node \
	opt/local/include/node \
	/opt/local/lib/node_modules\
	/usr/local/lib/node_modules \
	/usr/local/lib/npm-packages \
	/usr/local/include/node \
	/usr/local/n \
	~/n

brew prune