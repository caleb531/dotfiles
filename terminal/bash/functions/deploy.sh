#!/usr/bin/env bash

EXCLUSION_LIST=~/dotfiles/terminal/bash/functions/deploy-exclusions.txt

source ~/dotfiles/terminal/bash/functions/helper_functions.sh

# Retrieve the local PWD, building it if necessary
__get_local_pwd() {
	local temp_dir="$1"
	if [ -f ./_config.yml ]; then
		# If local PWD is a Jekyll project, use site built by Jekyll
		local local_pwd="$temp_dir"/_site
		JEKYLL_ENV=production \
			bundle exec \
			jekyll build --destination "$local_pwd" --quiet
		echo "$local_pwd"
	elif git rev-parse --git-dir &> /dev/null; then
		# If local PWD is a Git directory, use archive created by Git
		local local_pwd="$temp_dir"/"$(basename "$PWD")"
		local local_pwd_archive="$local_pwd".zip
		# A commit containing the current state of the repository, including
		# uncommitted working directory changes
		local stash_id="$(git stash create)"
		git archive "${stash_id:-HEAD}" --output="$local_pwd_archive" -0 .
		mkdir "$local_pwd"
		unzip -q "$local_pwd_archive" -d "$local_pwd"
		echo "$local_pwd"
	else
		echo "$PWD"
	fi
}

# Upload the contents of the given local PWD to the given remote PWD
__upload() {
	local local_pwd="$1"
	local remote_pwd="$2"
	if [ -z "$SSH_USER" ]; then
		>&2 echo "environment has no SSH user set"
	elif [ -z "$SSH_HOSTNAME" ]; then
		>&2 echo "environment has no SSH hostname set"
	elif [ -z "$SSH_PORT" ]; then
		>&2 echo "environment has no SSH port set"
	else
		pushd "$local_pwd" > /dev/null
		rsync \
			--archive \
			--checksum \
			--compress \
			--exclude-from "$EXCLUSION_LIST" \
			--human-readable \
			--rsh "ssh -p $SSH_PORT" \
			--verbose \
			"$local_pwd"/ \
			"$SSH_USER"@"$SSH_HOSTNAME":"$remote_pwd"
		popd > /dev/null
	fi
}

deploy() {
	__source_env
	local remote_pwd="$(__get_remote_pwd)"
	if [ -n "$remote_pwd" ]; then
		# Create a temporary directory in case it's needed (and create it
		# here so we can delete it after everything is done)
		local temp_dir="$(mktemp -d)"
		local local_pwd="$(__get_local_pwd "$temp_dir")"
		__upload "$local_pwd" "$remote_pwd"
		rm -rf "$temp_dir"
	fi
}

deploy
