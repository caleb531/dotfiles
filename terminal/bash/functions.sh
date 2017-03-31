#!/usr/bin/env bash
# functions.sh
# Caleb Evans

# Reload entire shell, including .bash_profile and any activated virtualenv
reload() {
	deactivate 2> /dev/null
	exec $SHELL -l
}

# Make pbcopy trim surrounding whitespace from copied input, for convenience
pbcopy() {
	local contents="$(< /dev/stdin)"
	contents="${contents#"${contents%%[![:space:]]*}"}"
	echo -n "$contents" | command pbcopy
}

# Remove last n commands from Bash history (n defaults to 1)
rmlastcmd() {
	local n="$([ -n "$1" ] && echo "$1" || echo 1)"
	local i
	for ((i=0; i<$n; i++)); do
		local last_cmd_offset="$(history | tail -n 1 | awk '{print $1;}')"
		history -d "$last_cmd_offset"
	done
}

# Copy last command to clipboard
cplastcmd() {
	local last_cmd="$(fc -ln -1)"
	echo -n "$last_cmd" | pbcopy
}

# Copy last command and remove it from Bash history
cprmlastcmd() {
	cplastcmd
	rmlastcmd
}

# Create a new directory and switch to it
mkdircd() {
	mkdir "$@"
	cd "${@: -1}"
}

# Make new Python virtualenv for current directory
# PYTHONVER is a major Python version (i.e. 2 or 3)
mkvirtualenv() {
	local python_version="$(cat .python-version 2> /dev/null)"
	if [ -n "$1" ]; then
		local python_version_major="$1"
	elif [ -n "$python_version" ]; then
		local python_version_major="${python_version%.*}"
	else
		>&2 echo "${FUNCNAME[0]}: python version not found"
		return 1
	fi
	virtualenv --python=python"$python_version_major" "$VIRTUAL_ENV_NAME"
	# Activate virtualenv so packages can be installed
	source ./"$VIRTUAL_ENV_NAME"/bin/activate
}

# Remove existing Python virtualenv
rmvirtualenv() {
	rm -rf ./"$VIRTUAL_ENV_NAME"
}

# Build a Jekyll site, using Bundler if needed
jb() {
	if [ -f ./Gemfile ]; then
		bundle exec jekyll build "$@"
	else
		jekyll build "$@"
	fi
}

# Watch a Jekyll site, building (and using Bundler) as needed
jbw() {
	if [ -f ./Gemfile ]; then
		bundle exec jekyll build --watch "$@"
	else
		jekyll build --watch "$@"
	fi
}

# Watch and force-rebuild Jekyll site
jbwf() {
	rm .jekyll-metadata
	jbw
}

# Serve a Jekyll site, building (and using Bundler) as needed
jsv() {
	if [ -f ./Gemfile ]; then
		bundle exec jekyll serve "$@"
	else
		jekyll serve "$@"
	fi
}

# Serve Jekyll site, force-rebuilding initially and then building as needed
jsvf() {
	rm .jekyll-metadata
	jsv
}

# Serve Jekyll site and open site in browser
jsvo() {
	jsv -o
}

# Provide convenient access to common PyPI commands
pypi() {
	if [ "$1" == 'test' ]; then
		python setup.py register -r pypitest
		python setup.py sdist upload -r pypitest
	elif [ "$1" == 'register' ]; then
		python setup.py register -r pypi
	elif [ "$1" == 'upload' ]; then
		python setup.py sdist upload -r pypi
	else
		>&2 echo "usage: ${FUNCNAME[0]} <command>"
		>&2 echo "Available commands: test, register, upload"
	fi
}

# Flush all DNS caches for OS X 10.10.4 and onward
dnsflush() {
	sudo dscacheutil -flushcache
	sudo killall -HUP mDNSResponder
}

# Copies changed items in current directory to corresponding directory on remote
# server; an .env file containing the below environment variables must be
# present in said directory or one of its parent directories
# Required environment variables: SSH_USER, SSH_HOSTNAME, SSH_PORT, REMOTE_ROOT
deploy() {
	~/dotfiles/terminal/bash/functions/deploy.sh
}

# SSH into the remote directory corresponding to the PWD; also requires an .env
# file to function
sshcd() {
	~/dotfiles/terminal/bash/functions/sshcd.sh
}

# Control MAMP Apache server

# Start Apache
aon() {
	sudo /Applications/MAMP/Library/bin/apachectl start
}
# Stop Apache
aoff() {
	sudo /Applications/MAMP/Library/bin/apachectl stop
}
# Restart Apache
are() {
	if type rln &> /dev/null; then
		rln
	fi
	sudo /Applications/MAMP/Library/bin/apachectl restart
}

# Control MAMP (mainly Apache and MySQL servers)

# Start MAMP
mon() {
	aon
	/Applications/MAMP/bin/startMysql.sh > /dev/null
}
# Stop MAMP
moff() {
	# Suppres the annoying "Warning: Using a password on the command line
	# interface can be insecure." message
	/Applications/MAMP/bin/stopMysql.sh 2>&1 | grep -v "Warning: Using a pass"
	aoff
}
# Restart MAMP
mre() {
	/Applications/MAMP/bin/stopMysql.sh > /dev/null
	are
	/Applications/MAMP/bin/startMysql.sh > /dev/null
}

# Run Python tests with Nose test runner
rt() {
	nosetests --rednose "$@"
}

# Run Python tests with coverage report
cov() {
	if coverage run -m nose --rednose "$@"; then
		coverage report
	fi
}

# Open HTML coverage report for Python tests
covo() {
	coverage html
	open -a 'Google Chrome' ./htmlcov/index.html
}

# Run the executable compiled by the current directory's Makefile
run() {
	local executable="$(cat Makefile | grep -Po '[\w\-\./]+\.out')"
	if [ -f "$executable" ]; then
		"$(readlink -f "$executable")" "$@"
	fi
}

# Run Makefile and then run compiled executable
makerun() {
	make -s
	run
}

# Upload file using transfer.sh and get share link (output it to the terminal
# and copy it to the clipboard, for convenience)
transfer() {
	# Temporarily redirect share URL stdout to file so progress bar can be
	# printed instead (as I understand it, the curl command cannot print
	# both to stdout)
	local share_url_file=$(mktemp -t transferXXX)
	curl \
		--progress-bar \
		--upload-file \
		"$1" \
		"https://transfer.sh" \
		> "$share_url_file"
	local share_url="$(< "$share_url_file")"
	echo "$share_url"
	echo -n "$share_url" | pbcopy
	rm -f "$share_url_file"
}
