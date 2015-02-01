#!/bin/bash
# Create/update home directory symlinks to these files

# Change directory to one containing this file
cd "$(dirname "${BASH_SOURCE[0]}")"

# Force create symlinks
ln -sf "$PWD/.bash_profile" ~
ln -sf "$PWD/.vimrc" ~
ln -sf "$PWD/.gitconfig" ~
