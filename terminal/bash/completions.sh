#!/usr/bin/env bash
# completions.sh
# Caleb Evans

# Completion function for npm, the Node-based package manager
_npm() {

	local cur=${COMP_WORDS[COMP_CWORD]}
	local prev=${COMP_WORDS[COMP_CWORD-1]}

	if [ "$prev" == 'npm' ] || [ "$prev" == 'help' ]; then
		# Complete common npm commands for `npm`
		COMPREPLY=( $(compgen -W 'add audit cache exec help info init install link list outdated prune publish remove search show start stop test uninstall unlink update' -- "$cur") )
	elif [ "$prev" == 'install' ] || [ "$prev" == 'i' ] || [ "$prev" == 'uninstall' ]; then
		# Complete common options for `npm install` and `npm uninstall`
		COMPREPLY=( $(compgen -W '--global --save --save-dev' -- "$cur") )
	elif [ "$prev" == 'run' ]; then
		# Complete subcommands for `npm run`
		local npm_script_names="$(npm run | grep -P '(?<=^\s{2})([a-z0-9\-_]+)' | xargs)"
		COMPREPLY=( $(compgen -W "$npm_script_names" -- "$cur") )
	elif [ "$prev" == 'exec' ]; then
		# Complete subcommands for `npm exec`
		local bin_list="$(ls node_modules/.bin)"
		COMPREPLY=( $(compgen -W "$bin_list" -- "$cur") )
	fi

}
complete -o default -F _npm npm 2> /dev/null

# Completion function for pnpm, a more performant alternative to npm
_pnpm() {

	local cur=${COMP_WORDS[COMP_CWORD]}
	local prev=${COMP_WORDS[COMP_CWORD-1]}

	if [ "$prev" == 'pnpm' ] || [ "$prev" == 'help' ]; then
		# Complete common npm commands for `npm`
		COMPREPLY=( $(compgen -W 'add audit exec help info init install link list outdated prune publish remove search show start stop test uninstall unlink update' -- "$cur") )
	elif [ "$prev" == 'update' ]; then
		local pnpm_pkg_list="$(pnpm list | grep -Po '^([@\/a-z\-]+)(?= )')"
		COMPREPLY=( $(compgen -W "$pnpm_pkg_list" -- "$cur") )
	elif [ "$prev" == 'audit' ]; then
		COMPREPLY=( $(compgen -W '--fix --prod' -- "$cur") )
	elif [ "$prev" == 'store' ]; then
		COMPREPLY=( $(compgen -W 'path prune' -- "$cur") )
	else
		_npm "$@"
	fi
}
complete -o default -F _pnpm pnpm 2> /dev/null

# Completion function for npx, the Node-based package manager
_npx() {

	local cur=${COMP_WORDS[COMP_CWORD]}
	local prev=${COMP_WORDS[COMP_CWORD-1]}
	local second=${COMP_WORDS[1]}
	local third=${COMP_WORDS[2]}

	if [ "$prev" == 'npx' ] || [ "$prev" == 'pnpx' ] || [ "$prev" == 'help' ]; then
		# Complete common npx commands for `npx`
		COMPREPLY=( $(compgen -W 'create-react-app@latest create-next-app@latest' -- "$cur") )
	elif [ "$prev" == 'create-react-app@latest' ] || [ "$prev" == 'create-next-app@latest' ]; then
		COMPREPLY=( $(compgen -W '--template' -- "$cur") )
	elif [ "$prev" == '--template' ]; then
		COMPREPLY=( $(compgen -W typescript -- "$cur") )
	fi

}
complete -o default -F _npx npx 2> /dev/null
complete -o default -F _npx pnpx 2> /dev/null

# Completion function for Grunt, the JavaScript task runner
_grunt() {

	local cur=${COMP_WORDS[COMP_CWORD]}
	local prev=${COMP_WORDS[COMP_CWORD-1]}

	if [ "$prev" == 'grunt' ]; then
		# Complete Grunt tasks standard to all of my Grunt-based projects
		COMPREPLY=( $(compgen -W 'build serve watch --help' -- "$cur") )
	fi

}
complete -o default -F _grunt grunt 2> /dev/null

# Completion function for pip, Python's package manager
_pip() {

	local cur=${COMP_WORDS[COMP_CWORD]}
	local prev=${COMP_WORDS[COMP_CWORD-1]}
	local first=${COMP_WORDS[0]}
	local second=${COMP_WORDS[1]}
	local third=${COMP_WORDS[2]}

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

# Completion function for gem, Ruby's built-in package manager
_gem() {

	local cur=${COMP_WORDS[COMP_CWORD]}
	local prev=${COMP_WORDS[COMP_CWORD-1]}

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

	local cur=${COMP_WORDS[COMP_CWORD]}
	local prev=${COMP_WORDS[COMP_CWORD-1]}
	local first=${COMP_WORDS[0]}
	local second=${COMP_WORDS[1]}

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

	local cur=${COMP_WORDS[COMP_CWORD]}
	local prev=${COMP_WORDS[COMP_CWORD-1]}
	local first=${COMP_WORDS[0]}
	local second=${COMP_WORDS[1]}

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

	local cur=${COMP_WORDS[COMP_CWORD]}
	local prev=${COMP_WORDS[COMP_CWORD-1]}

	if [ "$prev" == 'rake' ]; then
		COMPREPLY=( $(compgen -W "$(rake --tasks --all | grep -Po '(?<=rake )\S+')" -- "$cur") )
	fi

}
complete -o default -F _rake rake 2> /dev/null

# Completion function for python/python3 binaries
_python() {

	local cur=${COMP_WORDS[COMP_CWORD]}
	local prev=${COMP_WORDS[COMP_CWORD-1]}
	local first=${COMP_WORDS[0]}
	local second=${COMP_WORDS[1]}

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

	local cur=${COMP_WORDS[COMP_CWORD]}
	local prev=${COMP_WORDS[COMP_CWORD-1]}

	if [ "$prev" == 'apachectl' ] || [ "$prev" == 'help' ]; then
		# Complete common apachectl commands for `apachectl`
		COMPREPLY=( $(compgen -W 'configtest restart start stop' -- "$cur") )
	fi

}
complete -o default -F _apachectl apachectl 2> /dev/null


# Completion function for pypi, a custom function for interacting with PyPI
_pypi() {

	local cur=${COMP_WORDS[COMP_CWORD]}
	local prev=${COMP_WORDS[COMP_CWORD-1]}

	if [ "$prev" == 'pypi' ]; then
		# Complete shortcuts to common pypi operations for `pypi`
		COMPREPLY=( $(compgen -W 'test upload' -- "$cur") )
	fi

}
complete -o default -F _pypi pypi 2> /dev/null


# Completion function for mkvirtualenv, a function for creating new Python
# virtualenvs
_mkvirtualenv() {

	local cur=${COMP_WORDS[COMP_CWORD]}
	local prev=${COMP_WORDS[COMP_CWORD-1]}

	if [ "$prev" == 'mkvirtualenv' ]; then
		# Complete shortcuts to common mkvirtualenv operations for `mkvirtualenv`
		COMPREPLY=( $(compgen -W 'python python3' -- "$cur") )
	fi

}
complete -o default -F _mkvirtualenv mkvirtualenv 2> /dev/null


# Completion function for awp, my Alfred Workflow Packager utility
_awp() {

	local cur=${COMP_WORDS[COMP_CWORD]}
	local prev=${COMP_WORDS[COMP_CWORD-1]}
	local first=${COMP_WORDS[0]}

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

	local cur=${COMP_WORDS[COMP_CWORD]}
	local prev=${COMP_WORDS[COMP_CWORD-1]}
	local first=${COMP_WORDS[0]}
	local second=${COMP_WORDS[1]}

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
