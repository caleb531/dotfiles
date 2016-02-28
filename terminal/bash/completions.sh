#!/bin/bash
# completions.sh
# Caleb Evans

# cur = current

# Completion function for pip, Python's package manager
_pip() {

    cur=${COMP_WORDS[COMP_CWORD]}
    prev=${COMP_WORDS[COMP_CWORD-1]}
    first=${COMP_WORDS[0]}
    second=${COMP_WORDS[1]}

    if [ "$prev" == pip ]; then
        # Complete common pip commands when "pip" is given
        COMPREPLY=( $(compgen -W "list install uninstall freeze" -- $cur) )
    elif [ "$prev" == '>' -o "$prev" == '-r' ]; then
        # Complete filenames when output is being redirected
        COMPREPLY=( $(compgen -f $cur) )
    else
        # Complete installed packages in every other case
        local pkg_list="$(cat ./requirements.txt 2> /dev/null | grep -Po '[a-z0-9\-]+(?=\=\=)')"
        if [ -z "$pkg_list" ]; then
            local pkg_list="$(pip list 2> /dev/null | grep -Po '[a-z0-9\-]+(?= \()')"
        fi
        COMPREPLY=( $(compgen -W "$pkg_list" -- $cur) )
    fi

}
complete -F _pip pip
