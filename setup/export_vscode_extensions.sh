#!/usr/bin/env bash

code --list-extensions | sort -f > ~/dotfiles/vscode/extensions.txt
git reset &> /dev/null
git add ~/dotfiles/vscode/extensions.txt
git commit -m 'Update VS Code extensions list' 2> /dev/null
git push 2> /dev/null
