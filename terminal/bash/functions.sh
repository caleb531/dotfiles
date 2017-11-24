#!/usr/bin/env bash
# functions.sh
# Caleb Evans

# Reload entire shell, including .bash_profile and any activated virtualenv
reload() {
	deactivate 2> /dev/null
	exec $SHELL -l
}

# Print PATH entries, one entry per line
path() {
	echo -e "${PATH//:/\\n}"
}

# Make pbcopy trim surrounding whitespace from copied input, for convenience
pbcopy() {
	local contents="$(< /dev/stdin)"
	contents="${contents#"${contents%%[![:space:]]*}"}"
	echo -n "$contents" | command pbcopy
}

# Remove last n commands from Bash history (n defaults to 1)
rmlastcmd() {
	for ((i=0; i<${1:-1}; i++)); do
		history -d "$((HISTCMD-1))"
	done
}

# Copy last command to clipboard
cplastcmd() {
	echo -n "$(fc -ln -1)" | pbcopy
}

# Copy last command and remove it from Bash history
cprmlastcmd() {
	cplastcmd
	rmlastcmd
}

# Create a new directory and switch to it
mkcd() {
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

# Flush all DNS caches for macOS (10.10.4 and onward)
dnsflush() {
	sudo dscacheutil -flushcache
	sudo killall -HUP mDNSResponder
}

# Control MAMP Apache server

# Start Apache
aon() {
	if type rln &> /dev/null; then
		rln
	fi
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

# Run Node/Python tests with Nose test runner
rt() {
	if [ -f package.json ]; then
		if cat package.json | grep -q '\"atom\"'; then
			apm test "$@"
		else
			npm test "$@"
		fi
	elif [ -f requirements.txt ]; then
		nosetests --rednose "$@"
	else
		>&2 echo "${FUNCNAME[0]}: not a node/python project"
	fi
}

# Run Node/Python tests with coverage report
cov() {
	if [ -f package.json ]; then
		npm run coverage "$@"
	elif [ -f requirements.txt ]; then
		if coverage run -m nose --rednose "$@"; then
			coverage report
			coverage html
		fi
	else
		>&2 echo "${FUNCNAME[0]}: not a node/python project"
	fi
}

# Open HTML coverage report for Node/Python tests
covo() {
	if [ -f package.json ]; then
		open -a "$WEB_BROWSER_NAME" ./coverage/index.html
	elif [ -f requirements.txt ]; then
		open -a "$WEB_BROWSER_NAME" ./htmlcov/index.html
	else
		>&2 echo "${FUNCNAME[0]}: not a node/python project"
	fi
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
	run "$@"
}

# Clone git repository and immediately cd to it
clonecd() {
	git clone "$@"
	if [ $? == 0 ]; then
		cd "$(basename "$1" .git)"
	fi
}

# Pat on the back
pat() {
	cowsay 'You did a good job!'
}
# Motivate
mot() {
	cowsay 'You got this!'
}
