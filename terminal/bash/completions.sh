#!/usr/bin/env bash
# completions.sh
# Caleb Evans

# Retrieve list of brew taps added on this system (much faster than `brew tap`)
__get_brew_taps() {
	for parent_dir in "$BREW_TAPS_DIR"/*; do
		local parent_dir_name="$(basename "$parent_dir")"
		for child_dir in "$parent_dir"/*; do
			local child_dir_name="$(basename "$child_dir")"
			echo "$parent_dir_name"/"${child_dir_name/#homebrew-/}"
		done
	done
}

# The pattern used for matching Homebrew package/cask names
BREW_NAME_PATT='[a-z0-9\-]+(?=\.rb)'
# The directory containing all Homebrew taps
BREW_TAPS_DIR=/usr/local/Homebrew/Library/Taps

# Retrieve list of installed Homebrew packages
__get_installed_brew_packages() {
	ls -1 /usr/local/Cellar
}

# Retrieve list of installed Homebrew casks
__get_installed_brew_casks() {
	ls -1 /usr/local/Caskroom
}

# Retrieve list of all available Homebrew packages
__get_all_brew_packages() {
	find "$BREW_TAPS_DIR"/homebrew/ -type f -name '*.rb' | grep -oP "$BREW_NAME_PATT"
}

# Retrieve list of all available Homebrew casks
__get_all_brew_casks() {
	find "$BREW_TAPS_DIR"/caskroom/ -type f -name '*.rb' | grep -oP "$BREW_NAME_PATT"
}

# Completion function for brew, the OS X package manager
_brew() {

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}
	first=${COMP_WORDS[0]}
	second=${COMP_WORDS[1]}
	third=${COMP_WORDS[2]}

	if [ "$prev" == 'brew' -o "$prev" == 'help' ]; then
		# Complete common brew commands for `brew`
		COMPREPLY=( $(compgen -W 'cask cleanup deps doctor help info install leaves link linkapps outdated pin prune reinstall remove rmtree search switch tap uninstall unlink unlinkapps unpin untap update upgrade uses' -- $cur) )
	elif [ "$first" == 'brew' -a "$prev" == 'cask' ]; then
		# Complete common cask commands for `brew cask`
		COMPREPLY=( $(compgen -W 'cleanup doctor help info install list search uninstall update' -- $cur) )
	elif [ "$second" == 'list' -o "$second" == 'ls' ]; then
		# Complete list options for `brew list` and `brew ls`
		COMPREPLY=( $(compgen -W "--full-name --pinned --multiple --versions $(__get_installed_brew_packages)" -- $cur) )
	elif [ "$second" == 'cleanup' -o "$second" == 'reinstall' -o "$second" == 'remove' -o "$second" == 'rm' -o "$second" == 'rmtree' -o "$second" == 'uninstall' ]; then
		# Complete installed packages for brew package removal commands
		COMPREPLY=( $(compgen -W "$(__get_installed_brew_packages)" -- $cur) )
	elif [ "$second" == 'pin' -o "$second" == 'unpin' ]; then
		# Complete installed packages for brew pin commands
		COMPREPLY=( $(compgen -W "$(__get_installed_brew_packages)" -- $cur) )
	elif [ "$second" == 'untap' ]; then
		# Complete all installed taps for `brew tap`
		COMPREPLY=( $(compgen -W "$(__get_brew_taps)" -- $cur) )
	elif [ "$second" == 'upgrade' ]; then
		# Complete options and installed packages for `brew upgrade`
		COMPREPLY=( $(compgen -W "--all --cleanup $(__get_installed_brew_packages)" -- $cur) )
	elif [ "$second" == 'install' -o "$second" == 'info' ]; then
		# Complete all available packages for `brew install`
		COMPREPLY=( $(compgen -W "$(__get_all_brew_packages)" -- $cur) )
	elif [ "$second" == 'deps' -o "$second" == 'uses' ]; then
		# Complete options and all available packages for `brew deps` and `brew uses`
		COMPREPLY=( $(compgen -W "--include-optional --installed $(__get_all_brew_packages)" -- $cur) )
	elif [ "$second" == 'cask' -a "$third" == 'info' ]; then
		# Complete all available casks for `brew cask info`
		COMPREPLY=( $(compgen -W "$(__get_all_brew_casks)" -- $cur) )
	elif [ "$second" == 'cask' -a "$third" == 'install' ]; then
		# Complete options and installed casks for `brew cask install`
		COMPREPLY=( $(compgen -W "--force $(__get_all_brew_casks)" -- $cur) )
	elif [ "$second" == 'cask' -a "$third" == 'uninstall' ]; then
		# Complete installed casks for `brew cask uninstall`
		COMPREPLY=( $(compgen -W "$(__get_installed_brew_casks)" -- $cur) )
	fi

}
complete -o default -F _brew brew

# Completion function for npm and bower, the Node-based package managers
_npm() {

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}

	if [ "$prev" == 'npm' -o "$prev" == 'bower' -o "$prev" == 'help' ]; then
		# Complete common npm commands for `npm`
		COMPREPLY=( $(compgen -W 'cache help info init install link list outdated prune publish search show start stop test uninstall unlink unpublish update upgrade' -- $cur) )
	elif [ "$prev" == 'install' -o "$prev" == 'uninstall' ]; then
		# Complete common options for `npm install` and `npm uninstall`
		COMPREPLY=( $(compgen -W '--global --save --save-dev' -- $cur) )
	elif [ "$prev" == 'cache' ]; then
		# Complete subcommands for `npm cache`
		COMPREPLY=( $(compgen -W 'clean' -- $cur) )
	fi

}
complete -o default -F _npm npm bower

# Completion function for Grunt, the JavaScript task runner
_grunt() {

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}

	if [ "$prev" == 'grunt' ]; then
		# Complete Grunt tasks standard to all of my Grunt-based projects
		COMPREPLY=( $(compgen -W 'build serve watch --help' -- $cur) )
	fi

}
complete -o default -F _grunt grunt

# Completion function for pip, Python's package manager
_pip() {

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}
	first=${COMP_WORDS[0]}
	second=${COMP_WORDS[1]}
	third=${COMP_WORDS[2]}

	if [ "$prev" == 'pip' -o "$prev" == 'help' ]; then
		# Complete common pip commands for `pip`
		COMPREPLY=( $(compgen -W 'freeze help install list search show uninstall' -- $cur) )
	elif [ "$prev" == '>' -o "$prev" == '-r' ]; then
		# Complete filenames when output is being redirected or for `pip install -r`
		COMPREPLY=()
	elif [ "$prev" == 'list'  ]; then
		# Complete options for `pip list`
		COMPREPLY=( $(compgen -W '--editable --local --outdated --uptodate' -- $cur) )
	elif [ "$prev" == 'show' -o "$second" == 'uninstall' -o "$third" == '-U' ]; then
		# Complete installed packages for `pip show` and `pip uninstall`
		if [ -z "$PIP_PKG_LIST" -o "$PWD" != "$PIP_PKG_PWD" ]; then
			# Cache package list for the current PWD
			PIP_PKG_LIST="$(pip list '[a-z0-9\-]+(?= )' 2> /dev/null)"
			PIP_PKG_PWD="$PWD"
		fi
		COMPREPLY=( $(compgen -W "$PIP_PKG_LIST" -- $cur) )
	fi

}
complete -o default -F _pip pip

# Completion function for apm, Atom's package manager
_apm() {

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}

	if [ "$prev" == 'apm' -o "$prev" == 'help' ]; then
		# Complete common apm commands for `apm`
		COMPREPLY=( $(compgen -W 'clean develop help install list link login publish pull push search show star stars uninstall unstar update upgrade' -- $cur) )
	elif [ "$prev" == 'update' -o "$prev" == 'upgrade' ]; then
		# Complete options for `apm update` and `apm upgrade`
		COMPREPLY=( $(compgen -W '--list --no-confirm' -- $cur) )
	elif [ "$prev" == 'show' -o "$prev" == 'uninstall' ]; then
		# Complete installed packages for `apm show` and `apm uninstall`
		local pkg_list="$(ls ~/.atom/packages 2> /dev/null)"
		COMPREPLY=( $(compgen -W "$pkg_list" -- $cur) )
	fi

}
complete -o default -F _apm apm

# Completion function for Bundler, the Ruby package manager
_bundle() {

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}
	first=${COMP_WORDS[0]}
	second=${COMP_WORDS[1]}

	if [ "$prev" == 'bundle' -o "$prev" == 'help' ]; then
		# Complete common bundle commands for `bundle`
		COMPREPLY=( $(compgen -W 'check clean exec help init install list lock outdated package show update' -- $cur) )
	elif [ "$second" == 'exec' ]; then
		# Complete any shell command for `bundle exec`
		# This makes `bundle exec` behave like `command` and `exec` completion
		_command
	fi

}
complete -o default -F _bundle bundle

# Completion function for jekyll, the static site generator
_jekyll() {

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}
	first=${COMP_WORDS[0]}
	second=${COMP_WORDS[1]}

	if [ "$prev" == 'jekyll' -o "$prev" == 'help' ]; then
		# Complete common jekyll commands for `jekyll`
		COMPREPLY=( $(compgen -W 'build clean doctor help new serve' -- $cur) )
	elif [ "$second" == 'build' ]; then
		# Complete options for `jekyll build`
		COMPREPLY=( $(compgen -W '--destination --source --trace --watch' -- $cur) )
	elif [ "$prev" == '--source' -o "$prev" == '--destination' ]; then
		# Complete filenames for `--source` and `--destination`
		COMPREPLY=()
	fi

}
complete -o default -F _jekyll jekyll

# Completion function for python/python3 binaries
_python() {

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}
	first=${COMP_WORDS[0]}
	second=${COMP_WORDS[1]}

	# Complete package and module paths
	if [ "$second" == '-m' ]; then
		# Convert current query file path (with /) to module path (with .)
		local curpath="${cur//./\/}"
		# Get package names matching current query; exclude hidden directories
		local packages="$(compgen -d -- $curpath | grep -Po '([a-z_]+/)*([a-z_]+)\b')"
		# Convert Python file paths to package paths
		packages="${packages//\//.}"
		if [ -n "$packages" ]; then
			# Apepnd . to package name completions for convenience (since user
			# will type a module name next, this eliminates the need for them to
			# type a . first)
			packages="${packages// /. }."
			# Ensure that no spaces follow completed package names
			compopt -o nospace
		fi
		# Get module names matching curent query; include only .py files
		local modules="$(compgen -f -- $curpath | grep -Po '([a-z_]+/)*([a-z_]+)\.py')"
		# Convert Python file paths to module paths
		modules="${modules//\//.}"
		# Remove .py extension (all module names omit the .py extension)
		modules="${modules//.py/}"
		COMPREPLY=( $(compgen -W "$packages $modules" -- $cur) )
	fi

}
complete -o default -F _python python
complete -o default -F _python python3

# Completion function for MAMP, the Apache-MySQL-PHP stack app
_mamp() {

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}

	if [ "$prev" == 'mamp' ]; then
		# Complete common MAMP commands for `mamp`
		COMPREPLY=( $(compgen -W 'restart start stop' -- $cur) )
	fi

}
complete -o default -F _mamp mamp

# Completion function for apachectl, Apache's HTTP server utility
_apachectl() {

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}

	if [ "$prev" == 'apachectl' -o "$prev" == 'help' ]; then
		# Complete common apachectl commands for `apachectl`
		COMPREPLY=( $(compgen -W 'configtest restart start stop' -- $cur) )
	fi

}
complete -o default -F _apachectl apachectl


# Completion function for pypi, a custom function for interacting with PyPI
_pypi() {

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}

	if [ "$prev" == 'pypi' ]; then
		# Complete shortcuts to common pypi operations for `pypi`
		COMPREPLY=( $(compgen -W 'register test upload' -- $cur) )
	fi

}
complete -o default -F _pypi pypi


# Completion function for mkvirtualenv, a function for creating new Python
# virtualenvs
_mkvirtualenv() {

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}

	if [ "$prev" == 'mkvirtualenv' ]; then
		# Complete shortcuts to common mkvirtualenv operations for `mkvirtualenv`
		COMPREPLY=( $(compgen -W 'python python3' -- $cur) )
	fi

}
complete -o default -F _mkvirtualenv mkvirtualenv


# Completion function for awp, my Alfred Workflow Packager utility
_awp() {

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}
	first=${COMP_WORDS[0]}

	if [ "$first" == 'awp' ]; then
		# Complete common commands for `awp`
		COMPREPLY=( $(compgen -W '--export --help --validate --version' -- $cur) )
	elif [ "$prev" == '--export' ]; then
		# Complete file/directory paths whenever `--export` option is supplied
		COMPREPLY=()
	fi

}
complete -o default -F _awp awp
