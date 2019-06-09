#!/usr/bin/env zsh
# .zshrc
# Caleb Evans

# Remove dash (-) as a word character
WORDCHARS='*?_.[]~=/&;!#$%^(){}<>'

# option-arrow keys (navigate by word)
bindkey '^[f' forward-word
bindkey '^[b' backward-word

# option-delete (backward delete by word)
bindkey '^[^?' backward-delete-word
# fn-option-delete (forward delete by word)
bindkey '^[d' delete-word
# fn-delete (forward delete by character)
bindkey '^[[3~' delete-char
