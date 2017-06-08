#!/usr/bin/env bash

source ~/dotfiles/setup/header.sh

echo "Installing fonts..."

while read -r font_name; do
	if [ -n "$font_name" ]; then
		install_font "$font_name"
	fi
done < ~/dotfiles/setup/fonts.txt
