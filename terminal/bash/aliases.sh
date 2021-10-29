#!/usr/bin/env bash
# aliases.sh
# Caleb Evans

# Enable aliases to be run as root
alias sudo='sudo '

# Colorize directory listings
alias ls='ls --color=auto'
alias lsa='ls -a'
alias lsl='ls -l'
alias lsla='ls -la'
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

# Build a Brunch project
alias bb='brunch build'
# Watch a Brunch project for changes and build as needed
alias bw='brunch watch'
# Serve a Brunch site
alias bs='bw --server'
# Build a Jekyll site, using Bundler if needed
alias jb='bundle exec jekyll build'
# Build a Jekyll site and enable tracebacks
alias jbt='jb --trace'
# Build a Jekyll site for production
alias jbp='JEKYLL_ENV=production jb'
# Watch a Jekyll site, building (and using Bundler) as needed
alias jw='jb --watch'
# Serve a Jekyll site, building (and using Bundler) as needed
alias js='bundle exec jekyll serve'
# Serve Jekyll site and open site in browser
alias jso='js -o'
# Serve a directory via a Node HTTP server
alias hs='http-server -c-1'
# Serve a directory and open it in web browser
alias hso='hs -o'
# Build a Gulp project
alias gb='gulp build'
# Watch a Gulp project, building as needed
alias gw='gulp build:watch'
# Run a Gulp project's local server
alias gse='gulp serve'

# Dependency installation packages

# Install Bundler gems (has nothing to do with Brunch)
alias bi='bundle install'
# Execute an arbitrary command in a project's Bundler environment
alias be='bundle exec'
# Install Python packages into virtualenv
alias pir='pip install -r requirements.txt'
# Record installed Python packages
alias pf='pip freeze'
alias pfr='pip freeze > requirements.txt'

# Allow m typo to point to n node switcher
alias m='n'
# Recompile C++ for all relevant npm packages
alias nr='npm rebuild'
# Recompile node-sass specifically
alias nrs='npm rebuild node-sass'
# Build and watch project
alias nb='npm run build'
alias nw='npm run watch'

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
alias gpom='git pull origin master'
alias gpr='git pull --rebase'
alias gr='git reset'
alias gs='git status'

# Restart GPG to fix occasional signing issues
alias restart-gpg='gpgconf --kill gpg-agent'

# Switch to built-in Xcode tools from standalone command line tools (or
# vice-versa)
alias xcode-switch-xcode='sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer'
alias xcode-switch-clt='sudo xcode-select --switch /Library/Developer/CommandLineTools'

# Create several aliases for 'atom' misspellings
alias atoml='atom'
alias aton='atom'

# Create several aliases for 'code' misspellings
alias code='code'
alias codel='code'
alias cide='code'

# apm aliases
alias apmre='apm rebuild'

# Remap 'killall' to 'ka'
alias ka='killall'
