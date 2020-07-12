#!/usr/bin/env bash

source ~/dotfiles/setup/header.sh

while read -r filetype; do
	if [ -n "$filetype" ]; then
		duti -s com.github.atom "$filetype" all
	fi
done < ~/dotfiles/setup/default-filetypes-atom.txt
