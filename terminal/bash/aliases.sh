#!/usr/bin/env bash
# aliases.sh
# Caleb Evans

# Enable aliases to be run as root
alias sudo='sudo '

# Make Python 3 the default Python
alias python='python3'

# Colorize directory listings
if ls --color=auto ~ &> /dev/null; then
	alias ls='ls --color=auto'
elif /bin/ls -G ~ &> /dev/null; then
	alias ls='/bin/ls -G'
fi
alias lsa='ls -a'
alias lsl='ls -l'
alias lsla='ls -la'
alias ..='cd ..'
# Colorize tree output
alias tree='tree -C'

# Displays information related to the system's ability to sleep
alias whyunosleep='pmset -g assertions | grep --color=never Sleep'

# Remove files and directories
alias rmf='rm -f'
alias rmrf='rm -rf'

# Create a directory and all of its specified intermediate directories
alias mkdirp='mkdir -p'

# Always enable case-insensitive searches in less (for lowercase queries)
alias less='less --no-init --quit-if-one-screen --IGNORE-CASE'

# Mark a file as executable
alias x='chmod +x'
# Output the octal permissions for a file or directory
alias octmod='stat -c "%a"'
# Output the owner/group for a file or directory
alias owners='stat -c "%U %G"'

# Colorize grep matches (but not for piped output)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Search for running processes easily
alias psgrep='ps ax | grep -v grep | grep'
# Provide quick access to MAMP's Apache server
alias apachectl='sudo /Applications/MAMP/Library/bin/apachectl'
# Provide access to MAMP's MySQL utility
alias mysql='/Applications/MAMP/Library/bin/mysql'
# Provide access to MAMP's MySQL export utility
alias mysqldump='/Applications/MAMP/Library/bin/mysqldump'
# Use recommended version of OpenSSL over deprecated OpenSSL from system
alias openssl='$BREW_PREFIX/opt/openssl/bin/openssl'
# Check DNS records for the given domain
alias dns='dig'

# Build/serve aliases

# Serve a directory via a Node HTTP server
alias hs='http-server -a localhost -c-1'
# Serve a directory and open it in web browser
alias hso='hs -o'

# Stop me from accidentally generating *.js / *.jsx files every time I run the
# `tsc` command for linting
alias tsc='tsc --noEmit'

# Dependency installation packages

# Install Python packages into virtualenv
alias pir='pip install -r requirements.txt'
# Record installed Python packages
alias pf='pip freeze'
alias pfr='pip freeze > requirements.txt'
# Install and upgrade Python packages
alias pipi='pip install'
alias pipiu='pip install -U'
alias pipu='pip install -U'

# Allow nvm to be used as a shortcut for fnm
alias nvm='fnm'
# Allow m typo to point to n node switcher
alias m='n'
# Recompile C++ for all relevant npm packages
alias nr='npm rebuild'
# Recompile node-sass specifically
alias nrs='npm rebuild node-sass'

# Shortcut to create new Svelte+SvelteKit project
alias create-svelte='pnpm create svelte@latest'

# Shortcut to start jest-preview server
alias jest-preview='npm exec jest-preview'

# Git
alias gi='git'
alias got='git'
alias gti='git'
alias gut='git'
alias igt='git'
alias gcm='git commit'
alias gcma='git commit --amend'
alias gd='git diff'
alias gdc='git diff --cached'
alias gdcw='git diffcw'
alias gdcwc='git diffcwc'
alias gdcwcw='git diffcwcw'
alias gdw='git diffw'
alias gdwc='git diffwc'
alias gdwcw='git diffwcw'
alias gdwcwc='git diffwcwc'
alias gf='git fetch'
alias gm='git merge'
alias gos='git push'
alias gp='git pull'
alias gps='git push'
alias gpsu='git pushu'
alias gpsy='git pushu'
alias gpsf='git pushf'
alias gpst='git pusht'
alias gpstt='git pushtt'
alias gpo='git pull origin'
alias gpr='git pull --rebase'
alias gr='git reset'
alias gs='git status'

# Restart GPG to fix occasional signing issues
alias restart-gpg='gpgconf --kill gpg-agent'

# Switch to built-in Xcode tools from standalone command line tools (or
# vice-versa)
alias xcode-switch-xcode='sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer'
alias xcode-switch-clt='sudo xcode-select --switch /Library/Developer/CommandLineTools'
# Remove Apple CLI tools so they can be reinstalled fresh
alias xcode-uninstall-tools='sudo rm -rfv "$(xcode-select --print-path)"'

# Create several aliases for 'code' misspellings
alias code='code'
alias codel='code'
alias cide='code'
alias cod='code'
alias coe='code'
alias ciode='code'
alias cdoe='code'

# Remap 'killall' to 'ka'
alias ka='killall'

# Alias `bump-anything` to `version`
alias version='bump-anything'
