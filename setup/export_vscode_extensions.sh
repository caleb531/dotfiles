#!/usr/bin/env bash

code --list-extensions 2> /dev/null | sort -f > ~/dotfiles/vscode/extensions.txt
