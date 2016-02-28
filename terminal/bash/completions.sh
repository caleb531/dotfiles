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
    elif [ "$second" == freeze -a "$prev" == '>' ]; then
        # Complete filenames when "pip freeze" command is given
        COMPREPLY=( $(compgen -f $cur) )
    else
        local pkg_list="$(cat ./requirements.txt | grep -Po '[a-z0-9\-]+')"
        COMPREPLY=( $(compgen -W "$pkg_list" -- $cur) )
    fi

}
complete -F _pip pip
