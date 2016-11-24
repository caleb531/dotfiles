#!/usr/bin/env bash

echo "Removing undesired completions..."

# Remove completions overriden by custom completions
rm -f /usr/local/etc/bash_completion.d/brew
rm -f /usr/local/etc/bash_completion.d/npm
# Prefer `bundle` over `bundler`
rm -f /usr/local/bin/bundler
# Prefer `speedtest` over `speedtest-cli` and `speedtest_cli`
rm -f /usr/local/bin/speedtest-cli
rm -f /usr/local/bin/speedtest_cli
