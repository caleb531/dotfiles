#!/usr/bin/env bash

if type brew &> /dev/null; then
	brew uninstall node
	brew uninstall n
	brew uninstall nvm
	brew uninstall fnm
fi

sudo rm -rfv \
	/usr/local/bin/npm \
	/usr/local/bin/node \
	/usr/local/share/man/man1/node* \
	/usr/local/lib/dtrace/node.d \
	~/.npm \
	~/.node-gyp \
	/opt/local/bin/node \
	/opt/local/include/node \
	/usr/local/opt/nvm \
	/usr/local/opt/fnm \
	/opt/local/lib/node_modules\
	/usr/local/lib/node_modules \
	/usr/local/lib/npm-packages \
	/opt/homebrew/lib/npm-packages \
	/opt/homebrew/opt/nvm \
	/opt/homebrew/opt/fnm \
	/usr/local/include/node \
	/usr/local/n \
	~/n \
	~/.nvm \
	~/.fnm \
	~/Library/Application\ Support/fnm \
	~/Library/Caches/fnm_multishells

if type brew &> /dev/null; then
	brew cleanup
fi
