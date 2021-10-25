#!/usr/bin/env bash

code --list-extensions | sort -f > ~/dotfiles/vscode/extensions.txt
git add ~/dotfiles/vscode/extensions.txt
git commit -m 'Updated VS Code extensions list'
git push
