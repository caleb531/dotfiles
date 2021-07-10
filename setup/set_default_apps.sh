#!/usr/bin/env bash

source ~/dotfiles/setup/header.sh

while read -r filetype; do
	if [ -n "$filetype" ]; then
		duti -s com.microsoft.VSCode "$filetype" all
	fi
done < ~/dotfiles/setup/default-editor-filetypes.txt
