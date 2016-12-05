#!/usr/bin/env bash
# functions.sh
# Caleb Evans

# Reload entire shell, including .bash_profile and any activated virtualenv
# Usage: reload
reload() {
	deactivate 2> /dev/null
	exec $SHELL -l
}

# Remove last command from Bash history
# Usage: rmlastcmd
rmlastcmd() {
	local last_cmd_offset="$(history | tail -n 1 | awk '{print $1;}')"
	history -d "$last_cmd_offset"
}

# Make new Python virtualenv for current directory
# Usage: mkvirtualenv PYTHONVER
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
# Usage: rmvirtualenv
rmvirtualenv() {
	rm -rf ./"$VIRTUAL_ENV_NAME"
}

# Watch a Jekyll site, building (and using Bundler) as needed
jbw() {
	if [ -f ./Gemfile ]; then
		bundle exec jekyll build --watch
	else
		jekyll build --watch
	fi
}

# Serve a Jekyll site, building (and using Bundler) as needed
jsv() {
	if [ -f ./Gemfile ]; then
		bundle exec jekyll serve
	else
		jekyll serve
	fi
}

# Provide convenient access to common PyPI commands
# Usage: pypi [register|test|upload]
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
# Usage: flushdns
flushdns() {
	sudo dscacheutil -flushcache
	sudo killall -HUP mDNSResponder
}

# Copies changed items in current directory to corresponding directory on remote
# server; an .env file containing the below environment variables must be
# present in said directory or one of its parent directories
# Required environment variables: SSH_USER, SSH_HOSTNAME, SSH_PORT, REMOTE_ROOT
# Usage: deploy
deploy() {
	~/dotfiles/terminal/bash/functions/deploy.sh
}

# SSH into the remote directory corresponding to the PWD; also requires an .env
# file to function
# Usage: sshcd
sshcd() {
	~/dotfiles/terminal/bash/functions/sshcd.sh
}

# Control MAMP (mainly Apache and MySQL servers)
mamp() {
	if [ -z "$1" -o "$1" == start ]; then
		/Applications/MAMP/bin/start.sh > /dev/null
	elif [ "$1" == stop ]; then
		/Applications/MAMP/bin/stop.sh > /dev/null
	elif [ "$1" == restart ]; then
		/Applications/MAMP/bin/stop.sh > /dev/null
		/Applications/MAMP/bin/start.sh > /dev/null
	else
		>&2 echo "usage: ${FUNCNAME[0]} <command>"
		>&2 echo "Available commands: start, stop, restart"
	fi
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
