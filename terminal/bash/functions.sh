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
	history -d "$((HISTCMD))"
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
	cd "${@: -1}" || return
}

# Jump to the root directory of the current project (based on .git)
rootdir() {
	local path="$PWD"
	while [[ "$path" != '/' ]]; do
		if [ -d "$path"/.git ]; then
			cd "$path" || return 1
			return 0
		fi
		path="$(dirname "$path")"
	done
	return 1
}

# Ease transition from n to fnm
n() {
	if [ -n "$1" ]; then
		fnm use "$1" 2> /dev/null || fnm install "$1"
	else
		fnm list
	fi
}

# Make new Python virtualenv for current directory
# PYTHONVER is a major Python version (i.e. 2 or 3)
mkvirtualenv() {
	local python_version="$(cat .python-version 2> /dev/null)"
	local python_version_major="${python_version%.*}"
	if [ -n "$1" ]; then
		local python_path=python"$1"
	elif type python"$python_version" &> /dev/null; then
		local python_path=python"$python_version"
	else
		local python_path=python"$python_version_major"
	fi
	virtualenv --python="$python_path" "$VIRTUAL_ENV_NAME"
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
		rm -rf dist
		python setup.py sdist bdist_wheel
		twine upload --repository testpypi dist/*
	elif [ "$1" == 'upload' ]; then
		rm -rf dist
		python setup.py sdist bdist_wheel
		twine upload dist/*
	else
		>&2 echo "usage: ${FUNCNAME[0]} <command>"
		>&2 echo "Available commands: test, upload"
		return 1
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
		npm test -- "$@"
	elif [ -f requirements.txt ] && cat requirements.txt | grep -q nose2==; then
		nose2 --quiet "$@"
	elif [ -f requirements.txt ] && cat requirements.txt | grep -q nose==; then
		nosetests --rednose "$@"
	elif ls ./*.py &> /dev/null || ls tests/*.py &> /dev/null; then
		python -m unittest discover "$@"
	else
		>&2 echo "${FUNCNAME[0]}: not a node/python project"
		return 1
	fi
}
rtw() {
	if [ -f package.json ]; then
		npm test -- --watch "$@"
	else
		>&2 echo "${FUNCNAME[0]}: the watch mode for rt only works for Jest projects"
		return 1
	fi
}

# Run Node/Python tests with coverage report
cov() {
	if [ -f package.json ]; then
		npm run coverage -- "$@"
	elif [ -f .python-version ]; then
		if [ -f requirements.txt ] && cat requirements.txt | grep -q nose2==; then
			coverage run -m nose2 --quiet "$@"
		elif [ -f requirements.txt ] && cat requirements.txt | grep -q nose==; then
			coverage run -m nose --rednose "$@"
		elif [ -f requirements.txt ]; then
			coverage run -m unittest "$@"
		fi
		if [ $? == 0 ]; then
			coverage report
			coverage html
		fi
	else
		>&2 echo "${FUNCNAME[0]}: not a node/python project"
		return 1
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
		return 1
	fi
}

# Lint JavaScript/Python project files
lint() {
	if [ -f package.json ]; then
		npm run lint "$@"
	elif [ -f requirements.txt ]; then
		pycodestyle "$@" ./**/!(setup).py
	else
		>&2 echo "${FUNCNAME[0]}: not a node/python project"
		return 1
	fi
}

# Check Node/Python cyclomatic complexity
cc() {
	if [ -f requirements.txt ]; then
		radon cc --show-complexity --average "$@" ./**/!(setup).py
	else
		>&2 echo "${FUNCNAME[0]}: not a node/python project"
		return 1
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
		local repo_name="$(basename "$1" .git)"
		cd "${2:-$repo_name}" || return
	fi
}

# Pull from main/master into the current branch
gpom() {
	if git rev-parse --verify master &> /dev/null; then
		git pull origin master
	else
		git pull origin main
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

# Generate SRI hash
sri() {
	local url="$1"
	local ext="${url##*.}"
	local hash="$(curl -s "$url" | openssl dgst -sha384 -binary | openssl base64 -A)"
	if [ "$ext" == js ]; then
		echo "<script src=\"$url\" integrity=\"sha384-$hash\" crossorigin=\"anonymous\"></script>" | pbcopy
		echo "Copied <script> tag!"
	elif [ "$ext" == css ]; then
		echo "<link rel=\"stylesheet\" href=\"$url\" integrity=\"sha384-$hash\" crossorigin=\"anonymous\" />" | pbcopy
		echo "Copied <link> tag!"
	else
		>&2 echo "file is not a JS or CSS file"
	fi
}

# Shortcuts for `git add`
ga() {
	git add "${@:--A}"
}
gap() {
	ga -p "${@:--A}"
}

# Fix node-gyp Xcode installation error
xcode-fix-node-gyp() {
	sudo xcode-select --reset
	xcode-select -print-path
	sudo rm -rf "$(xcode-select --print-path)"
	xcode-select --install
}

# Get bundle identifier of any app
appid() {
	# The full app name, including the .app extension
	local app_name_full="$(basename "$*")"
	# The app name minus the .app extension
	local app_name_short="${app_name_full%.*}"
	osascript -e "id of app \"$app_name_short\""
}

# Check drive usage and wear statistics for SSD
ssd() {
	if ! type smartctl &> /dev/null; then
		brew install smartmontools
	fi
	sudo smartctl --all /dev/disk0
}

# The base URL for all Jira ticket URLs
export JIRA_BASE_TICKET_URL='https://revvy-modeln.atlassian.net/browse/'

# Create a pull request on Bitbucket or GitHub
pr() {
	git push || return $?
	local branch_name="$(git rev-parse --abbrev-ref HEAD)"
	local ticket_id="$(echo "$branch_name" | grep -Eo '([A-Z]+)-([0-9]+)')"
	local repo_url="$(git config --get remote.origin.url | sed 's/\.git//')"
	if [ -n "$ticket_id" ]; then
		local pr_default_title="[${ticket_id}] "
		local pr_default_body="Ticket: ${JIRA_BASE_TICKET_URL}${ticket_id}

"
	fi
	if echo "$repo_url" | grep -Fq 'bitbucket.org'; then
		# Bitbucket
		local repo_url="${repo_url//git@bitbucket.org:/https:\/\/bitbucket.org\/}"
		local pr_url="${repo_url}/pull-requests/new?source=${branch_name}&t=1"
	elif echo "$repo_url" | grep -Fq 'github.com'; then
		# GitHub
		local repo_url="${repo_url//git@github.com/https:\/\/github.com}"
		local parent_branch="$(git show-branch -a | sed 's/].*//' | grep -F '*' | grep -v "$(git rev-parse --abbrev-ref HEAD)" | head -n1 | sed 's/^.*\[//' | sed -E 's/~[0-9]+//')"
		local pr_url="${repo_url}/compare/${parent_branch:-main}...${branch_name}?title=${pr_default_title}&body=${pr_default_body}"
	fi
	if [ -n "$pr_url" ]; then
		echo "$pr_url"
		open "$pr_url"
	else
		>&2 echo "PR URL is empty"
	fi
}

# Integrate changes by merging them into a target branch (default: main) and
# then switching back to the original branch; if there is an error at any point
# along the way (e.g. merge conflicts), the function will stop in its place and
# allow you to resolve; when you are ready to continue, you can simply run the
# `int` command again
__int() {
	# If the last run of the `int` command completed successfully, then store
	# the original branch name until all steps of the integration process have
	# successfully completed
	if [ -z "$INT_ORIG_BRANCH" ]; then
		INT_ORIG_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
	fi
	git checkout "${1:-main}" || return $?
	git pull || return $?
	git merge "$INT_ORIG_BRANCH" || return $?
	git push || return $?
	if [ -z "$INT_DISABLE_CHECKOUT_ORIG_BRANCH" ]; then
		git checkout "$INT_ORIG_BRANCH" || return $?
	fi
	# Unset the stored original branch name now that we've reached the end of
	# the integration process
	INT_ORIG_BRANCH=''
}
int() {
	# If running `intn` fails, but then we resume the process with `int`, we
	# should re-enable checking out of the original branch (because we ran `int`
	# instead of `intn`)
	INT_DISABLE_CHECKOUT_ORIG_BRANCH=''
	__int "$@"
}
# A variant of the above int function which does not check out the original
# branch upon successful completion
intn() {
	INT_DISABLE_CHECKOUT_ORIG_BRANCH=1
	__int "$@"
	INT_DISABLE_CHECKOUT_ORIG_BRANCH=''
}
