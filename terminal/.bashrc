#!/usr/bin/env bash
# .bashrc
# Caleb Evans

source ~/dotfiles/terminal/bash/exports.sh
source ~/dotfiles/terminal/bash/aliases.sh
source ~/dotfiles/terminal/bash/functions.sh
source ~/dotfiles/terminal/bash/config.sh
source ~/dotfiles/terminal/bash/prompt.sh
# personal.sh is for users of my dotfiles who wish to add personal configuration
# that is not tracked by the repository
if [ -f ~/dotfiles/personal/bash_personal.sh ]; then
	source ~/dotfiles/personal/bash_personal.sh
fi
