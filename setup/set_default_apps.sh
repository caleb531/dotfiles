#!/usr/bin/env bash

source ~/dotfiles/setup/header.sh
source ~/dotfiles/terminal/bash/exports.sh

while read -r filetype; do
	if [ -n "$filetype" ]; then
		duti -s com.microsoft.VSCode "$filetype" all
	fi
done < ~/dotfiles/setup/default-editor-filetypes.txt
