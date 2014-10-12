# Modified version of dyncomp.sh by user sharfah
# https://github.com/sharfah/dotfiles

# Dynamic Completion Generator to speed up completion load time.
# This script moves the completion functions from bash_completion and bash_completion.d/ 
# to a separate directory and recreates bash_completion so that it will load a completion 
# function only when it is requested for the first time. This speeds up completion.
# http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=467231

BASH_COMPLETION=/usr/local/etc/bash_completion
BASH_DYNCOMPLETION=/usr/local/etc/bash_dyncompletion
BASH_DYNCOMPLETION_DIR=/usr/local/etc/bash_dyncompletion.d

echo "Read static completions from $BASH_COMPLETION"
. "$BASH_COMPLETION" || exit 1

echo "Create dynamic completion file $BASH_DYNCOMPLETION"
touch "$BASH_DYNCOMPLETION" || exit 1

echo "Create dynamic completion directory $BASH_DYNCOMPLETION_DIR"
mkdir -p "$BASH_DYNCOMPLETION_DIR" || exit 1

echo -n "Populate dynamic completion directory:"
FUNCS=$(declare -f | grep '^[a-zA-Z_][a-zA-Z0-9_]* () $' | cut -f 1 -d ' ')
for FN in $FUNCS ; do
    echo -n " $FN"
    declare -f $FN > "$BASH_DYNCOMPLETION_DIR/$FN"
    eval "$FN () { . '$BASH_DYNCOMPLETION_DIR/$FN' ; $FN \"\$@\" ; }"
done
echo

echo "Write dynamic completion file $BASH_DYNCOMPLETION"
exec > "$BASH_DYNCOMPLETION"
cat <<EOF
# $(basename $BASH_DYNCOMPLETION) - load-by-need bash completions
# actual completion functions are stored in $BASH_DYNCOMPLETION_DIR
# this file and directory are generated from $BASH_COMPLETION

shopt -s extglob progcomp
EOF

declare -p BASH_COMPLETION 2>/dev/null
declare -p bash205 2>/dev/null
declare -p bash205b 2>/dev/null
declare -p bash3 2>/dev/null
declare -f
complete -p

exit 0
