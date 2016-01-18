#!/bin/bash
# functions.sh
# Caleb Evans

# Reloads entire shell, including .bash_profile and any activated virtualenv
# Usage: reload
reload() {
	deactivate 2> /dev/null
	exec $SHELL -l
}

# Makes new Python virtualenv for current directory
# Usage: mkvirtualenv PYTHON
# PYTHON is the name of a python executable (typically python2 or python3)
mkvirtualenv() {
	virtualenv --python="$1" "$VIRTUAL_ENV_NAME"
	# Activate virtualenv so packages can be installed
	source ./"$VIRTUAL_ENV_NAME"/bin/activate
}

# Removes existing Python virtualenv
# Usage: rmvirtualenv
rmvirtualenv() {
	rm -r ./"$VIRTUAL_ENV_NAME"
}

# Flushes all DNS caches for OS X 10.10.4 and onward
# Usage: flushdns
flushdns() {
	sudo dscacheutil -flushcache
	sudo killall -HUP mDNSResponder
}

# Generates a dummy file of any size
# Usage: genfile --size SIZE FILEPATH
# Size must be an integer ending in 'K' or 'M' (I wouldn't dare try 'G')
genfile() {
	if [ $1 == '--size' ]; then
		local filesize="$2"
		local filepath="$3"
	elif [ "$2" == '--size' ]; then
		local filepath="$1"
		local filesize="$3"
	fi
	dd if=/dev/zero of="$filepath" bs="$filesize" count=1
}
