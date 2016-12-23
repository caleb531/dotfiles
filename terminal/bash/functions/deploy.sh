#!/usr/bin/env bash

# The list of file/directory patterns to exclude from deployment
DEPLOY_EXCLUSION_LIST=~/dotfiles/terminal/bash/functions/deploy-exclusions.txt
# The cache location for deployed directories
DEPLOY_CACHE_DIR=~/.deploy-cache

source ~/dotfiles/terminal/bash/functions/helper_functions.sh

# Get the ID for the current directory for identification in the deploy cache
__get_cache_id() {
	echo "$PWD" | openssl sha1
}

# Retrieve the local PWD, building it if necessary
__get_local_pwd() {
	if [ -f ./_config.yml ]; then
		# If local PWD is a Jekyll project, use production site built by Jekyll
		local local_pwd="$DEPLOY_CACHE_DIR"/"$(__get_cache_id)"
		JEKYLL_ENV=production \
			bundle exec \
			jekyll build --destination "$local_pwd" --quiet
		echo "$local_pwd"
	elif [ -f ./brunch-config.js ]; then
		# If local PWD is a Brunch project, use production site built by Brunch
		rm -rf ./public
		brunch build --production > /dev/null
		echo "$PWD"/public
	elif git rev-parse --git-dir &> /dev/null; then
		# If local PWD is a Git directory, use archive created by Git
		local local_pwd="$DEPLOY_CACHE_DIR"/"$(__get_cache_id)"
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
		>&2 echo "$(__get_script_name): environment has no SSH user set"
		return 1
	elif [ -z "$SSH_HOSTNAME" ]; then
		>&2 echo "$(__get_script_name): environment has no SSH hostname set"
		return 1
	elif [ -z "$SSH_PORT" ]; then
		>&2 echo "$(__get_script_name): environment has no SSH port set"
		return 1
	else
		pushd "$local_pwd" > /dev/null
		rsync \
			--archive \
			--checksum \
			--compress \
			--exclude-from "$DEPLOY_EXCLUSION_LIST" \
			--human-readable \
			--rsh "ssh -p $SSH_PORT" \
			--verbose \
			"$local_pwd"/ \
			"$SSH_USER"@"$SSH_HOSTNAME":"$remote_pwd"
		popd > /dev/null
	fi
}

deploy() {
	if __source_env; then
		local remote_pwd="$(__get_remote_pwd)"
	fi
	if [ -n "$remote_pwd" ]; then
		mkdir -p "$DEPLOY_CACHE_DIR"
		local local_pwd="$(__get_local_pwd)"
		__upload "$local_pwd" "$remote_pwd"
	else
		return 1
	fi
}

deploy
