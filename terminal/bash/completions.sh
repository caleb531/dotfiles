#!/usr/bin/env bash
# completions.sh
# Caleb Evans

# Completion function for npm and bower, the Node-based package managers
_npm() {

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}
	second=${COMP_WORDS[1]}
	third=${COMP_WORDS[2]}

	if [ "$prev" == 'npm' ] || [ "$prev" == 'bower' ] || [ "$prev" == 'help' ]; then
		# Complete common npm commands for `npm`
		COMPREPLY=( $(compgen -W 'audit cache help info init install link list outdated prune publish search show start stop test uninstall unlink unpublish update upgrade' -- "$cur") )
	elif [ "$prev" == 'install' ] || [ "$prev" == 'uninstall' ]; then
		# Complete common options for `npm install` and `npm uninstall`
		COMPREPLY=( $(compgen -W '--global --save --save-dev' -- "$cur") )
	elif [ "$prev" == 'cache' ]; then
		# Complete subcommands for `npm cache`
		COMPREPLY=( $(compgen -W 'clean' -- "$cur") )
	elif [ "$prev" == 'audit' ]; then
		# Complete subcommands for `npm audit`
		COMPREPLY=( $(compgen -W 'fix' -- "$cur") )
	elif [ "$second" == 'audit' ] && [ "$third" == 'fix' ]; then
		# Complete subcommands for `npm audit fix`
		COMPREPLY=( $(compgen -W '--dry-run --force' -- "$cur") )
	fi

}
complete -o default -F _npm npm bower 2> /dev/null

# Completion function for Grunt, the JavaScript task runner
_grunt() {

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}

	if [ "$prev" == 'grunt' ]; then
		# Complete Grunt tasks standard to all of my Grunt-based projects
		COMPREPLY=( $(compgen -W 'build serve watch --help' -- "$cur") )
	fi

}
complete -o default -F _grunt grunt 2> /dev/null

# Completion function for pip, Python's package manager
_pip() {

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}
	first=${COMP_WORDS[0]}
	second=${COMP_WORDS[1]}
	third=${COMP_WORDS[2]}

	if [ "$prev" == 'pip' ] || [ "$prev" == 'pip2' ] || [ "$prev" == 'pip3' ] || [ "$prev" == 'help' ]; then
		# Complete common pip commands for `pip`
		COMPREPLY=( $(compgen -W 'freeze help install list search show uninstall' -- "$cur") )
	elif [ "$prev" == '>' ] || [ "$prev" == '-r' ]; then
		# Complete filenames when output is being redirected or for `pip install -r`
		COMPREPLY=()
	elif [ "$prev" == 'list'  ]; then
		# Complete options for `pip list`
		COMPREPLY=( $(compgen -W '--editable --local --outdated --uptodate' -- "$cur") )
	elif [ "$prev" == 'show' ] || [ "$second" == 'uninstall' ] || [ "$third" == '-U' ]; then
		# Complete installed packages for `pip show` and `pip uninstall`
		if [ -z "$PIP_PKG_LIST" ] || [ "$PWD" != "$PIP_PKG_PWD" ]; then
			# Cache package list for the current PWD
			PIP_PKG_LIST="$($first list | grep -Po '[a-z0-9\-]+(?=\=)' 2> /dev/null)"
			PIP_PKG_PWD="$PWD"
		fi
		COMPREPLY=( $(compgen -W "$PIP_PKG_LIST" -- "$cur") )
	fi

}
complete -o default -F _pip pip pip2 pip3 2> /dev/null

# Completion function for apm, Atom's package manager
_apm() {

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}

	if [ "$prev" == 'apm' ] || [ "$prev" == 'help' ]; then
		# Complete common apm commands for `apm`
		COMPREPLY=( $(compgen -W 'clean develop help install list link login publish pull push rebuild search show star stars uninstall unstar update upgrade' -- "$cur") )
	elif [ "$prev" == 'update' ] || [ "$prev" == 'upgrade' ]; then
		# Complete options for `apm update` and `apm upgrade`
		COMPREPLY=( $(compgen -W '--list --no-confirm' -- "$cur") )
	elif [ "$prev" == 'show' ] || [ "$prev" == 'uninstall' ]; then
		# Complete installed packages for `apm show` and `apm uninstall`
		local pkg_list="$(ls ~/.atom/packages 2> /dev/null)"
		COMPREPLY=( $(compgen -W "$pkg_list" -- "$cur") )
	fi

}
complete -o default -F _apm apm 2> /dev/null

# Completion function for gem, Ruby's built-in package manager
_gem() {

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}

	if [ "$prev" == 'gem' ] || [ "$prev" == 'help' ]; then
		# Complete common gem commands for `gem`
		COMPREPLY=( $(compgen -W 'cleanup dependency info install list uninstall update' -- "$cur") )
	elif [ "$prev" == 'dependency' ] || [ "$prev" == 'install' ] || [ "$prev" == 'show' ] || [ "$prev" == 'update' ] || [ "$prev" == 'uninstall' ]; then
		# Complete installed packages for `gem dependency`, `gem install`, `gem show`, `gem update`, and `gem uninstall`
		local gem_list="$(ls -1 "$BREW_PREFIX"/lib/ruby/gems/2.6.0/gems 2> /dev/null | grep -Po '[a-z0-9_\-]+(?=\-\d+(\.\d+)+.*?)')"
		COMPREPLY=( $(compgen -W "$gem_list" -- "$cur") )
	fi

}
complete -o default -F _gem gem 2> /dev/null

# Completion function for Bundler, the Ruby package manager
_bundle() {

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}
	first=${COMP_WORDS[0]}
	second=${COMP_WORDS[1]}

	if [ "$prev" == 'bundle' ] || [ "$prev" == 'help' ]; then
		# Complete common bundle commands for `bundle`
		COMPREPLY=( $(compgen -W 'check clean exec help init install list lock outdated package show update' -- "$cur") )
	elif [ "$second" == 'update' ]; then
		local gem_list="$(cat Gemfile 2> /dev/null | grep -Po '(?<=gem .)[a-z0-9_\-]+(?=.\s*$)')"
		COMPREPLY=( $(compgen -W "$gem_list" -- "$cur") )
	elif [ "$second" == 'exec' ]; then
		# Complete any shell command for `bundle exec`
		# This makes `bundle exec` behave like `command` and `exec` completion
		_command
	fi

}
complete -o default -F _bundle bundle bundler 2> /dev/null

# Completion function for jekyll, the static site generator
_jekyll() {

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}
	first=${COMP_WORDS[0]}
	second=${COMP_WORDS[1]}

	if [ "$prev" == 'jekyll' ] || [ "$prev" == 'help' ]; then
		# Complete common jekyll commands for `jekyll`
		COMPREPLY=( $(compgen -W 'build clean doctor help new serve' -- "$cur") )
	elif [ "$second" == 'build' ]; then
		# Complete options for `jekyll build`
		COMPREPLY=( $(compgen -W '--destination --source --trace --watch' -- "$cur") )
	elif [ "$prev" == '--source' ] || [ "$prev" == '--destination' ]; then
		# Complete filenames for `--source` and `--destination`
		COMPREPLY=()
	fi

}
complete -o default -F _jekyll jekyll 2> /dev/null

# Completion functions for Ruby's Make system, Rake
_rake() {

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}

	if [ "$prev" == 'rake' ]; then
		COMPREPLY=( $(compgen -W "$(rake --tasks --all | grep -Po '(?<=rake )\S+')" -- "$cur") )
	fi

}
complete -o default -F _rake rake 2> /dev/null

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
		local packages="$(compgen -d -- "$curpath" | grep -Po '([a-z_]+/)*([a-z_]+)\b')"
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
		local modules="$(compgen -f -- "$curpath" | grep -Po '([a-z_]+/)*([a-z_]+)\.py')"
		# Convert Python file paths to module paths
		modules="${modules//\//.}"
		# Remove .py extension (all module names omit the .py extension)
		modules="${modules//.py/}"
		COMPREPLY=( $(compgen -W "$packages $modules" -- "$cur") )
	fi

}
complete -o default -F _python python 2> /dev/null
complete -o default -F _python python2 2> /dev/null
complete -o default -F _python python3 2> /dev/null

# Completion function for apachectl, Apache's HTTP server utility
_apachectl() {

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}

	if [ "$prev" == 'apachectl' ] || [ "$prev" == 'help' ]; then
		# Complete common apachectl commands for `apachectl`
		COMPREPLY=( $(compgen -W 'configtest restart start stop' -- "$cur") )
	fi

}
complete -o default -F _apachectl apachectl 2> /dev/null


# Completion function for pypi, a custom function for interacting with PyPI
_pypi() {

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}

	if [ "$prev" == 'pypi' ]; then
		# Complete shortcuts to common pypi operations for `pypi`
		COMPREPLY=( $(compgen -W 'test upload' -- "$cur") )
	fi

}
complete -o default -F _pypi pypi 2> /dev/null


# Completion function for mkvirtualenv, a function for creating new Python
# virtualenvs
_mkvirtualenv() {

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}

	if [ "$prev" == 'mkvirtualenv' ]; then
		# Complete shortcuts to common mkvirtualenv operations for `mkvirtualenv`
		COMPREPLY=( $(compgen -W 'python python3' -- "$cur") )
	fi

}
complete -o default -F _mkvirtualenv mkvirtualenv 2> /dev/null


# Completion function for awp, my Alfred Workflow Packager utility
_awp() {

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}
	first=${COMP_WORDS[0]}

	if [ "$prev" == '--export' ] || [ "$prev" == '-e' ]; then
		# Complete file/directory paths whenever `--export` option is supplied
		COMPREPLY=()
	elif [ "$first" == 'awp' ]; then
		# Complete common commands for `awp`
		COMPREPLY=( $(compgen -W '--export --help --validate --version' -- "$cur") )
	fi

}
complete -o default -F _awp awp 2> /dev/null

# My personal bump utility, available via pip as bump-anything
_bump() {

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}
	first=${COMP_WORDS[0]}
	second=${COMP_WORDS[1]}

	if [ "$prev" == 'bump' ]; then
		# Complete increment types for `bump`
		COMPREPLY=( $(compgen -W 'major minor patch' -- "$cur") )
	elif [ "$second" == 'major' ] || [ "$second" == 'minor' ] || [ "$second" == 'patch' ]; then
		# Complete file/directory paths for any argument after first
		COMPREPLY=()
	fi

}
complete -o default -F _bump bump 2> /dev/null

# Enable completions for aliases for 'git'
if type __git_complete &> /dev/null; then
	__git_complete gi __git_main
	__git_complete got __git_main
	__git_complete gti __git_main
	__git_complete gut __git_main
	__git_complete igt __git_main
fi
