#!/usr/bin/env bash

echo "Removing undesired completions..."

# Remove completions overriden by custom completions
rm -f /usr/local/etc/bash_completion.d/brew
rm -f /usr/local/etc/bash_completion.d/npm
# Prefer `bundle` over `bundler`
rm -f /usr/local/bin/bundler
