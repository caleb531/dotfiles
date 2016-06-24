#!/usr/bin/env bash
# completions.sh
# Caleb Evans

# Completion function for brew, the OS X package manager
_brew() {

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}
	first=${COMP_WORDS[0]}
	second=${COMP_WORDS[1]}

	if [ "$prev" == 'brew' ]; then
		# Complete common brew commands for `brew`
		COMPREPLY=( $(compgen -W 'cask cleanup deps doctor help info install leaves link linkapps outdated pin prune reinstall rmtree search tap uninstall unlink unlinkapps unpin untap update upgrade uses --version' -- $cur) )
	elif [ "$first" == 'brew' -a "$prev" == 'cask' ]; then
		# Complete common cask commands for `brew cask`
		COMPREPLY=( $(compgen -W 'cleanup doctor info install list search uninstall update' -- $cur) )
	elif [ "$second" == 'list' -o "$second" == 'ls' ]; then
		# Complete list options for `brew list` or `brew ls`
		COMPREPLY=( $(compgen -W '--full-name --pinned --multiple --versions' -- $cur) )
	elif [ "$second" == 'cleanup' -o "$second" == 'uninstall' ]; then
		# Complete installed packages for `brew cleanup` or `brew uninstall`
		COMPREPLY=( $(compgen -W "$(ls -1 /usr/local/Cellar)" -- $cur) )
	elif [ "$second" == 'cask' -o "$prev" == 'uninstall' ]; then
		# Complete installed packages if `brew cask uninstall`
		COMPREPLY=( $(compgen -W "$(ls -1 /usr/local/Caskroom)" -- $cur) )
	fi

}
complete -o default -F _brew brew


# Completion function for pip, Python's package manager
_pip() {

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}
	first=${COMP_WORDS[0]}
	second=${COMP_WORDS[1]}

	if [ "$prev" == 'pip' ]; then
		# Complete common pip commands for `pip`
		COMPREPLY=( $(compgen -W 'freeze help install list search show uninstall' -- $cur) )
	elif [ "$prev" == '>' -o "$prev" == '-r' ]; then
		# Complete filenames when output is being redirected or for `pip install -r`
		COMPREPLY=()
	elif [ "$prev" == 'list'  ]; then
		# Complete options for `pip list`
		COMPREPLY=( $(compgen -W '--editable --local --outdated --uptodate' -- $cur) )
	else
		# Complete installed packages in every other case
		local pkg_list="$(cat ./requirements.txt 2> /dev/null | grep -Po '[a-z0-9\-]+(?=\=\=)')"
		if [ -z "$pkg_list" ]; then
			local pkg_list="$(pip list 2> /dev/null | grep -Po '[a-z0-9\-]+(?= \()')"
		fi
		COMPREPLY=( $(compgen -W "$pkg_list" -- $cur) )
	fi

}
complete -o default -F _pip pip

# Completion function for apm, Atom's package manager
_apm() {

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}
	first=${COMP_WORDS[0]}
	second=${COMP_WORDS[1]}

	if [ "$prev" == 'apm' ]; then
		# Complete common apm commands for `apm`
		COMPREPLY=( $(compgen -W 'clean help install list publish search show uninstall update upgrade' -- $cur) )
	elif [ "$prev" == 'update' -o "$prev" == 'upgrade' ]; then
		# Complete options for `apm update` or `apm upgrade`
		COMPREPLY=( $(compgen -W '--list --no-confirm' -- $cur) )
	else
		# Complete installed packages in every other case
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

	if [ "$prev" == 'bundle' -o "$prev" == 'bundler' ]; then
		# Complete common bundle commands for `bundle`
		COMPREPLY=( $(compgen -W 'check clean exec help init install list lock outdated package show update' -- $cur) )
	fi

}
complete -o default -F _bundle bundle
complete -o default -F _bundle bundler

# Completion function for jekyll, the static site generator
_jekyll() {

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}
	first=${COMP_WORDS[0]}
	second=${COMP_WORDS[1]}

	if [ "$prev" == 'jekyll' ]; then
		# Complete common jekyll commands for `jekyll`
		COMPREPLY=( $(compgen -W 'build clean doctor help new serve' -- $cur) )
	elif [ "$prev" == '--source' -o "$prev" == '--destination' ]; then
		# Complete filenames for `--source` or `--destination`
		COMPREPLY=()
	elif [ "$second" == 'build' ]; then
		# Complete options for `jekyll build`
		COMPREPLY=( $(compgen -W '--destination --source --trace --watch' -- $cur) )
	fi

}
complete -o default -F _jekyll jekyll

# Completion function for MAMP, the Apache-MySQL-PHP stack app
_mamp() {

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}
	first=${COMP_WORDS[0]}
	second=${COMP_WORDS[1]}

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
	first=${COMP_WORDS[0]}
	second=${COMP_WORDS[1]}

	if [ "$prev" == 'apachectl' ]; then
		# Complete common apachectl commands for `apachectl`
		COMPREPLY=( $(compgen -W 'configtest restart start stop' -- $cur) )
	fi

}
complete -o default -F _apachectl apachectl
