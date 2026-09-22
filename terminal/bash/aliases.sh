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
# Define a Git alias and register its completion when Git completion is loaded
git-alias() {
	# Expand the supplied alias value now so it remains literal when invoked
	# shellcheck disable=SC2139
	alias "$1=$2"
	if [ -n "$3" ] && type __git_complete &> /dev/null; then
		__git_complete "$1" "$3"
	fi
}

git-alias gi 'git' __git_main
git-alias got 'git' __git_main
git-alias gti 'git' __git_main
git-alias gut 'git' __git_main
git-alias igt 'git' __git_main
git-alias gbs 'git bisect start' __git_complete_refs
git-alias gbr 'git bisect reset' __git_complete_refs
git-alias gbg 'git bisect good' __git_complete_refs
git-alias good 'git bisect good' __git_complete_refs
git-alias gbb 'git bisect bad' __git_complete_refs
git-alias bad 'git bisect bad' __git_complete_refs
git-alias gcm 'git commit' _git_commit
git-alias gcma 'git commit --amend' _git_commit
git-alias gd 'git diff' _git_diff
git-alias gdc 'git diff --cached' _git_diff
git-alias gdcw 'git diffcw' _git_diff
git-alias gdcwc 'git diffcwc' _git_diff
git-alias gdcwcw 'git diffcwcw' _git_diff
git-alias gdw 'git diffw' _git_diff
git-alias gdwc 'git diffwc' _git_diff
git-alias gdwcw 'git diffwcw' _git_diff
git-alias gdwcwc 'git diffwcwc' _git_diff
# alias gf='git fetch'
git-alias gm 'git merge' _git_merge
git-alias gos 'git push' _git_push
git-alias gp 'git pull' _git_pull
git-alias fp 'git pull' _git_pull
git-alias gps 'git push' _git_push
git-alias fps 'git push' _git_push
git-alias gpsu 'git pushu' _git_push
git-alias gpsy 'git pushu' _git_push
git-alias gpsf 'git pushf' _git_push
git-alias gpst 'git pusht' _git_push
git-alias gpstt 'git pushtt' _git_push
git-alias gpsttf 'git pushtt --force-with-lease' _git_push
git-alias gpsftt 'git pushtt --force-with-lease' _git_push
git-alias gpo 'git pull origin' __git_complete_refs
git-alias gpr 'git pull --rebase' _git_pull
git-alias gpor 'git pull --rebase origin' __git_complete_refs
git-alias gr 'git reset' _git_reset
git-alias gs 'git status' _git_status

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
alias coed='code'

# Create aliases for `codex` misspellings
alias codx='codex'

# Remap 'killall' to 'ka'
alias ka='killall'

# Make bump-anything more easily accessible
alias version='bump-anything'
