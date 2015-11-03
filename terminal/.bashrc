#!/bin/bash
# .bashrc
# Caleb Evans

source ~/.bash/exports.sh
source ~/.bash/prompt.sh
source ~/.bash/aliases.sh
source ~/.bash/functions.sh
source ~/.bash/config.sh
# personal.sh is for users of my dotfiles who wish to add personal configuration that is not tracked by the repository
if [ -f ~/.bash/personal.sh ]; then
	source ~/.bash/personal.sh
fi
