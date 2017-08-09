#!/usr/bin/env bash
# aliases.sh
# Caleb Evans

# Enable aliases to be run as root
alias sudo='sudo '

# Colorize directory listings
alias ls='ls --color=auto'

# Output the octal permissions for a file or directory
alias octmod='stat -c "%a"'
# Output the owner/group for a file or directory
alias owners='stat -c "%U %G"'

# Colorize grep matches (but not for piped output)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Colorize tree output
alias tree='tree -C'

# Search for running processes easily
alias psgrep='ps ax | grep -v grep | grep'
# Provide quick access to MAMP's Apache server
alias apachectl='sudo /Applications/MAMP/Library/bin/apachectl'
# Provide access to MAMP's MySQL utility
alias mysql='/Applications/MAMP/Library/bin/mysql'
# Provide access to MAMP's MySQL export utility
alias mysqldump='/Applications/MAMP/Library/bin/mysqldump'
# Use recommended version of OpenSSL over deprecated OpenSSL from system
alias openssl='/usr/local/opt/openssl/bin/openssl'
# Increment major, minor, or patch version of the node package
alias bump='npm version --no-git-tag-version'

# Build/serve aliases

# Build a Brunch project
alias bb='brunch build "$@"'
# Watch a Brunch project for changes and build as needed
alias bw='brunch watch "$@"'
# Serve a Brunch site
alias bs='bw --server "$@"'
# Build a Jekyll site, using Bundler if needed
alias jb='bundle exec jekyll build "$@"'
# Watch a Jekyll site, building (and using Bundler) as needed
alias jw='jb --watch "$@"'
# Serve a Jekyll site, building (and using Bundler) as needed
alias js='bundle exec jekyll serve "$@"'
# Serve Jekyll site and open site in browser
alias jso='js -o "$@"'
# Serve a directory via a Node HTTP server
alias hs='http-server -a localhost -c-1 "$@"'
# Serve a directory and open it in web browser
alias hso='hs -o "$@"'

# Dependency installation packages

# Install Bundler gems (has nothing to do with Brunch)
alias bi='bundle install'
# Install Python packages into virtualenv
alias pi='pip install -r requirements.txt'
