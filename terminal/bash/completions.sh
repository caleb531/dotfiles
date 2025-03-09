#!/usr/bin/env bash
# completions.sh
# Caleb Evans

# Completion function for npm, the Node-based package manager
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

# The directory containing all Homebrew taps
BREW_TAPS_DIR="$BREW_PREFIX"/Library/Taps

# Retrieve list of installed Homebrew packages
__get_installed_brew_packages() {
	ls -1 "$BREW_PREFIX"/Cellar "$BREW_PREFIX"/Caskroom
}

# Retrieve list of versions for the given package
__get_brew_package_versions() {
	if [ -d "$BREW_PREFIX"/Cellar/"$1" ]; then
		ls -1 "$BREW_PREFIX"/Cellar/"$1"
	fi
}

# A helper function used for retrieving the list of all npm script names for a
# particular project (used for autocompletion)
__get_npm_script_names() {
	cat package.json \
		| jq '.scripts | keys[] as $k | $k' \
		| xargs
}

# A helper function used for retrieving the list of npm package names used for
# autocompletion (works for npm, pnpm, and yarn)
__get_npm_pkg_names() {
	local package_json="$(cat package.json)"
	local dep_list="$(echo "$package_json" \
		| jq '.dependencies | keys[] as $k | $k' 2> /dev/null \
		| xargs)"
	local dev_dep_list="$(echo "$package_json" \
		| jq '.devDependencies | keys[] as $k | $k' 2> /dev/null \
		| xargs)"
	echo "$dep_list $dev_dep_list" | xargs
}

# Retrieve a flat list of all local Git branches
__get_git_branches() {
	# Apparently, using -E instead of -P causes dashes to get stripped out
	git branch "$@" | grep -Pio '[a-z0-9_][a-z0-9_\-\/\.]*' | xargs
}

# Generate completions for Python module/package names for the current query
__complete_python_module_names() {
	# Convert current query file path (with /) to module path (with .)
	local cur="$1"
	local curpath="${cur//./\/}"
	# Get package names matching current query; exclude hidden directories
	local packages="$(compgen -d -- "$curpath" | grep -Eo '([a-z_]+/)*([a-z_]+)\b')"
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
	local modules="$(compgen -f -- "$curpath" | grep -Eo '([a-z_]+/)*([a-z_]+)\.py')"
	# Convert Python file paths to module paths
	modules="${modules//\//.}"
	# Remove .py extension (all module names omit the .py extension)
	modules="${modules//.py/}"
	COMPREPLY=( $(compgen -W "$packages $modules" -- "$cur") )
}

# Completion function for brew, the macOS package manager
_brew() {

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}
	first=${COMP_WORDS[0]}
	second=${COMP_WORDS[1]}
	third=${COMP_WORDS[2]}

	if [ "$prev" == 'brew' ] || [ "$prev" == 'help' ]; then
		# Complete common brew commands for `brew`
		COMPREPLY=( $(compgen -W 'cleanup deps doctor help info install leaves link linkapps outdated pin prune reinstall remove search switch tap uninstall unlink unlinkapps unpin untap update upgrade uses' -- "$cur") )
	elif [ "$second" == 'list' ] || [ "$second" == 'ls' ]; then
		# Complete list options for `brew list` and `brew ls`
		COMPREPLY=( $(compgen -W "--full-name --pinned --multiple --versions $(__get_installed_brew_packages)" -- "$cur") )
	elif [ "$second" == 'install' ]; then
		# Complete list options for `brew install`
		COMPREPLY=( $(compgen -W "--cask --formula --force --dry-run --verbose $(brew search /^"$cur"/ 2> /dev/null | xargs)" -- "$cur") )
	elif [ "$second" == 'reinstall' ] || [ "$second" == 'remove' ] || [ "$second" == 'rm' ] || [ "$second" == 'uninstall' ]; then
		# Complete installed packages for brew package removal commands
		COMPREPLY=( $(compgen -W "$(__get_installed_brew_packages)" -- "$cur") )
	elif [ "$second" == 'info' ]; then
		# Complete installed packages `brew info`
		COMPREPLY=( $(compgen -W "$(__get_installed_brew_packages)" -- "$cur") )
	elif [ "$second" == 'cleanup' ]; then
		# Complete options and installed packages for `brew cleanup`
		COMPREPLY=( $(compgen -W "--dry-run $(__get_installed_brew_packages)" -- "$cur") )
	elif [ "$second" == 'pin' ] || [ "$second" == 'unpin' ]; then
		# Complete installed packages for brew pin commands
		COMPREPLY=( $(compgen -W "$(__get_installed_brew_packages)" -- "$cur") )
	elif [ "$second" == 'untap' ]; then
		# Complete all installed taps for `brew tap`
		COMPREPLY=( $(compgen -W "$(__get_brew_taps)" -- "$cur") )
	elif [ "$second" == 'upgrade' ]; then
		# Complete options and installed packages for `brew upgrade`
		COMPREPLY=( $(compgen -W "--all --cleanup $(__get_installed_brew_packages)" -- "$cur") )
	elif [ "$second" == 'deps' ] || [ "$second" == 'uses' ]; then
		# Complete options and all available packages for `brew deps` and `brew uses`
		COMPREPLY=( $(compgen -W "--installed" -- "$cur") )
	elif [ "$prev" == 'switch' ]; then
		# Complete installed package names for first argument of `brew switch`
		COMPREPLY=( $(compgen -W "$(__get_installed_brew_packages)" -- "$cur") )
	elif [ "$second" == 'switch' ]; then
		# Complete package versions for second argument of `brew switch`
		COMPREPLY=( $(compgen -W "$(__get_brew_package_versions "$prev")" -- "$cur") )
	fi

}
complete -o default -F _brew brew 2> /dev/null

# Completion function for npm and bower, the Node-based package managers
_npm() {

	local cur=${COMP_WORDS[COMP_CWORD]}
	local prev=${COMP_WORDS[COMP_CWORD-1]}

	if [ "$prev" == 'npm' ] || [ "$prev" == 'help' ]; then
		# Complete common npm commands for `npm`
		COMPREPLY=( $(compgen -W 'add audit cache exec help info init install link list outdated prune publish remove search show start stop test uninstall unlink update upgrade' -- "$cur") )
	elif [ "$prev" == 'install' ] || [ "$prev" == 'i' ] || [ "$prev" == 'uninstall' ]; then
		# Complete common options for `npm install` and `npm uninstall`
		local npm_pkg_list="$(__get_npm_pkg_names)"
		COMPREPLY=( $(compgen -W "--global --save --save-dev $npm_pkg_list" -- "$cur") )
	elif [ "$second" == 'update' ] || [ "$second" == 'uninstall' ] || [ "$second" == 'remove' ]; then
		# Complete package names for `npm update/uninstall/remove`
		local npm_pkg_list="$(__get_npm_pkg_names)"
		COMPREPLY=( $(compgen -W "$npm_pkg_list" -- "$cur") )
	elif [ "$prev" == 'run' ]; then
		# Complete subcommands for `npm run`
		local npm_script_names="$(__get_npm_script_names)"
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
	local second=${COMP_WORDS[1]}

	if [ "$prev" == 'pnpm' ] || [ "$prev" == 'help' ]; then
		# Complete common pnpm commands for `pnpm`
		local npm_script_names="$(__get_npm_script_names)"
		COMPREPLY=( $(compgen -W "add approve-builds audit exec help info init install link list outdated prune publish remove search show start stop test uninstall unlink update upgrade $npm_script_names" -- "$cur") )
	elif [ "$second" == '-s' ]; then
		local npm_script_names="$(__get_npm_script_names)"
		COMPREPLY=( $(compgen -W "$npm_script_names" -- "$cur") )
	elif [ "$prev" == 'audit' ]; then
		# Complete useful flags for `pnpm audit`
		COMPREPLY=( $(compgen -W '--fix --prod' -- "$cur") )
	elif [ "$prev" == 'store' ]; then
		# Complete useful subcommands for `pnpm store`
		COMPREPLY=( $(compgen -W 'path prune' -- "$cur") )
	else
		_npm "$@"
	fi
}
complete -o default -F _pnpm pnpm 2> /dev/null

# Completion function for npx, the Node-based package manager
_yarn() {


	local cur=${COMP_WORDS[COMP_CWORD]}
	local prev=${COMP_WORDS[COMP_CWORD-1]}
	local second=${COMP_WORDS[1]}

	if [ "$prev" == 'yarn' ] || [ "$prev" == 'help' ]; then
		# Complete common pnpm commands for `pnpm`
		local npm_script_names="$(__get_npm_script_names)"
		COMPREPLY=( $(compgen -W "add exec help info init install link list publish remove search show start stop test uninstall unlink update $npm_script_names" -- "$cur") )
	else
		_npm "$@"
	fi

}
complete -o default -F _yarn yarn 2> /dev/null

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

# Completion function for npx, the Node-based package manager
_ncu() {

	local cur=${COMP_WORDS[COMP_CWORD]}
	local prev=${COMP_WORDS[COMP_CWORD-1]}
	local first=${COMP_WORDS[0]}

	if [ "$first" == 'ncu' ]; then
		# Complete installed npm packages for `ncu`
		local pnpm_pkg_list="$(__get_npm_pkg_names)"
		COMPREPLY=( $(compgen -W "$pnpm_pkg_list" -- "$cur") )
	fi

}
complete -o default -F _ncu ncu 2> /dev/null

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
			PIP_PKG_LIST="$($first list --format=freeze | grep -Po '[a-z0-9\-]+(?=\=)' 2> /dev/null)"
			PIP_PKG_PWD="$PWD"
		fi
		COMPREPLY=( $(compgen -W "$PIP_PKG_LIST" -- "$cur") )
	fi

}
complete -o default -F _pip pip pip2 pip3 2> /dev/null

# Completion function for pip upgrade aliases
_pipiu() {

	local cur=${COMP_WORDS[COMP_CWORD]}
	local prev=${COMP_WORDS[COMP_CWORD-1]}

	if [ "$prev" == 'pipiu' ] || [ "$prev" == 'pipu' ]; then
		# Complete installed packages for `pip show` and `pip uninstall`
		if [ -z "$PIP_PKG_LIST" ] || [ "$PWD" != "$PIP_PKG_PWD" ]; then
			# Cache package list for the current PWD
			PIP_PKG_LIST="$(pip list | grep -Po '[a-z0-9\-]+(?=\=)' 2> /dev/null)"
			PIP_PKG_PWD="$PWD"
		fi
		COMPREPLY=( $(compgen -W "$PIP_PKG_LIST" -- "$cur") )
	fi

}
complete -o default -F _pipiu pipiu pipu 2> /dev/null

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
		__complete_python_module_names "$cur"
	fi

}
complete -o default -F _python python 2> /dev/null
complete -o default -F _python python2 2> /dev/null
complete -o default -F _python python3 2> /dev/null

# Completion function for python/python3 binaries
_rt() {

	local cur=${COMP_WORDS[COMP_CWORD]}
	local prev=${COMP_WORDS[COMP_CWORD-1]}

	# Complete package and module paths
	if [ "$prev" == 'rt' ] && [ -d "$VIRTUAL_ENV_NAME" ]; then
		__complete_python_module_names "$cur"
	fi

}
complete -o default -F _rt rt 2> /dev/null

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

# Completion function for fnm, a faster alternative to nvm
_fnm() {

	local cur=${COMP_WORDS[COMP_CWORD]}
	local prev=${COMP_WORDS[COMP_CWORD-1]}

	if [ "$prev" == 'fnm' ] || [ "$prev" == 'nvm' ] || [ "$prev" == 'help' ]; then
		# Complete increment types for `fnm`
		COMPREPLY=( $(compgen -W 'alias env exec list list-remote ls ls-remote install unalias uninstall use' -- "$cur") )
	fi

}
complete -o default -F _fnm fnm 2> /dev/null
complete -o default -F _fnm nvm 2> /dev/null

# My personal bump utility, available via pip as bump-anything
_bump() {

	local cur=${COMP_WORDS[COMP_CWORD]}
	local prev=${COMP_WORDS[COMP_CWORD-1]}
	local first=${COMP_WORDS[0]}
	local second=${COMP_WORDS[1]}

	if [ "$prev" == 'bump' ]; then
		# Complete increment types for `bump`
		COMPREPLY=( $(compgen -W 'major minor patch prerelease' -- "$cur") )
	elif [ "$second" == 'major' ] || [ "$second" == 'minor' ] || [ "$second" == 'patch' ] || [ "$second" == 'prerelease' ]; then
		# Complete file/directory paths for any argument after first
		COMPREPLY=()
	fi

}
complete -o default -F _bump bump 2> /dev/null
complete -o default -F _bump bump-anything 2> /dev/null

# Completions for my custom integrate (int) function
_int() {
	local cur=${COMP_WORDS[COMP_CWORD]}
	local prev=${COMP_WORDS[COMP_CWORD-1]}

	if [ "$prev" == 'int' ] || [ "$prev" == 'intn' ]; then
		# Complete Git branch names for `int`
		COMPREPLY=( $(compgen -W "$(__get_git_branches --)" -- "$cur") )
	fi

}
complete -o default -F _int int intn 2> /dev/null

# My custom Git alias for `git pull origin`, which should complete branch names
_gpo() {

	local cur=${COMP_WORDS[COMP_CWORD]}
	local prev=${COMP_WORDS[COMP_CWORD-1]}

	if [ "$prev" == 'gpo' ] || [ "$prev" == 'gpor' ]; then
		# Complete branch names for `gpo`
		COMPREPLY=( $(compgen -W "$(__get_git_branches --)" -- "$cur") )
	fi

}
complete -o default -F _gpo gpo 2> /dev/null
complete -o default -F _gpo gpor 2> /dev/null

# My custom Git alias for opening a pull request, which should complete branch
# names (because the alias accepts an optional branch name as its only argument)
_pr() {

	local cur=${COMP_WORDS[COMP_CWORD]}
	local prev=${COMP_WORDS[COMP_CWORD-1]}

	if [ "$prev" == 'pr' ]; then
		# Complete branch names for `pr`
		COMPREPLY=( $(compgen -W "$(__get_git_branches --)" -- "$cur") )
	fi

}
complete -o default -F _pr pr 2> /dev/null

# Enable completions for aliases for 'git'
if type __git_complete &> /dev/null; then
	__git_complete gi __git_main
	__git_complete got __git_main
	__git_complete gti __git_main
	__git_complete gut __git_main
	__git_complete igt __git_main
fi
