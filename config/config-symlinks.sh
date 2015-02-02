#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"/..

echo "Configuring symlinks..."

# Force create symlinks
ln -sf "$PWD/.bash_profile" ~
ln -sf "$PWD/.vimrc" ~
ln -sf "$PWD/.gitconfig" ~
