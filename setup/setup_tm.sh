#!/usr/bin/env bash

source ~/dotfiles/setup/header.sh

# The path to the cloned Asimov repository
export ASIMOV_PATH=~/asimov

# Exclude the given directory path from Time Machine
exclude_dir() {
	local dir_path="${1%/}"
	echo "Excluding $dir_path"
	sudo tmutil addexclusion -p "$dir_path"
}

# Only back up /Users
for dir_path in /*/ /.*/; do
	if [[ "$dir_path" != '/Users/' && "$dir_path" != '/./' && "$dir_path" != '/../' ]]; then
		exclude_dir "$dir_path"
	fi
done

# Exclude large directories under user home directory
exclude_dir ~/Library
exclude_dir ~/n
exclude_dir ~/Music/iTunes/Album\ Artwork/Cache
exclude_dir ~/.Trash

# Clone Asimov for excluding development directories
if [ ! -d "$ASIMOV_PATH" ]; then
	mkdir -p "$ASIMOV_PATH"
	git clone https://github.com/caleb531/asimov.git "$ASIMOV_PATH"
else
	pushd "$ASIMOV_PATH" > /dev/null || exit
	git pull > /dev/null
	popd > /dev/null || exit
fi

"$ASIMOV_PATH"/install.sh
