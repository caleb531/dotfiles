#!/usr/bin/env bash
# completions.sh
# Caleb Evans

# Completion function for pip, Python's package manager
_pip() {

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}
	first=${COMP_WORDS[0]}
	second=${COMP_WORDS[1]}

	if [ "$prev" == 'pip' ]; then
		# Complete common pip commands when "pip" is given
		COMPREPLY=( $(compgen -W 'freeze install list search show uninstall' -- $cur) )
	elif [ "$prev" == '>' -o "$prev" == '-r' ]; then
		# Complete filenames when output is being redirected
		# or when `pip install -r` is given
		COMPREPLY=()
	elif [ "$prev" == 'list'  ]; then
		# Complete options when "list" command is given
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
		# Complete common apm commands when "apm" is given
		COMPREPLY=( $(compgen -W 'clean install list publish search show uninstall update upgrade' -- $cur) )
	elif [ "$prev" == 'update' -o "$prev" == 'upgrade' ]; then
		# Complete options when "update" or "upgrade" command is given
		COMPREPLY=( $(compgen -W '--list --no-confirm' -- $cur) )
	else
		# Complete installed packages in every other case
		local pkg_list="$(ls ~/.atom/packages 2> /dev/null)"
		COMPREPLY=( $(compgen -W "$pkg_list" -- $cur) )
	fi

}
complete -o default -F _apm apm

# Completion function for jekyll, the static site generator
_jekyll() {

	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}
	first=${COMP_WORDS[0]}
	second=${COMP_WORDS[1]}

	if [ "$prev" == 'jekyll' ]; then
		# Complete common jekyll commands when "jekyll" is given
		COMPREPLY=( $(compgen -W 'build clean doctor new serve' -- $cur) )
	elif [ "$prev" == '--source' -o "$prev" == '--destination' ]; then
		# Complete filenames when source or destination is specified for build
		COMPREPLY=()
	elif [ "$second" == 'build' ]; then
		# Complete options when "build" command is given
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
		# Complete common MAMP commands when "mamp" is given
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
		# Complete common apachectl commands when "apachectl" is given
		COMPREPLY=( $(compgen -W 'configtest restart start stop' -- $cur) )
	fi

}
complete -o default -F _apachectl apachectl
