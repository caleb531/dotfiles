#!/usr/bin/env bash
# aliases.sh
# Caleb Evans

# Enable aliases to be run as root
alias sudo='sudo '

# Print PATH entries, one entry per line
alias path='echo -e ${PATH//:/\\n}'

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

# Colorize diff output
if type colordiff &> /dev/null; then
	alias diff='colordiff'
fi

# Colorize tree output
if type tree &> /dev/null; then
	alias tree='tree -C'
fi

# Search for running processes easily
alias psgrep='ps ax | grep -v grep | grep'
# Provide quick access to MAMP's Apache server
alias apachectl='sudo /Applications/MAMP/Library/bin/apachectl'
# Provide access to MAMP's MySQL utility
alias mysql='/Applications/MAMP/Library/bin/mysql'
# Provide access to MAMP's MySQL export utility
alias mysqldump='/Applications/MAMP/Library/bin/mysqldump'
# Provides access to MAMP's PHP 7 utility
alias php='/Applications/MAMP/bin/php/php7.0.12/bin/php'
# Use recommended version of OpenSSL over deprecated OpenSSL from system
alias openssl='/usr/local/opt/openssl/bin/openssl'
# Start Node HTTP server and open web browser
alias hso='http-server -a localhost -c-1 -o'
# Open phpMyAdmin in web browser
alias pma='open http://localhost/phpMyAdmin/'

# Common Brunch commands
alias bb='brunch build'
alias bw='brunch watch'
alias bws='brunch watch --server --network'
