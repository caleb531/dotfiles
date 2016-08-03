#!/usr/bin/env bash

source ~/.dotfiles/terminal/bash/functions/getenv.sh

# Retrieve the local PWD, building it if necessary
get-local-pwd() {
	local temp_dir="$1"
	if [ -f ./_config.yml ]; then
		# If local PWD is a Jekyll project, use site built by Jekyll
		local local_pwd="$temp_dir"/_site
		JEKYLL_ENV=production jekyll build --destination "$local_pwd" --quiet
		echo "$local_pwd"
	elif git rev-parse --git-dir &> /dev/null; then
		# If local PWD is a Git directory, use archive created by Git
		local local_pwd="$temp_dir"/"$(basename "$PWD")"
		local local_pwd_archive="$local_pwd".zip
		git archive HEAD --output="$local_pwd_archive" -0 .
		mkdir "$local_pwd"
		unzip -q "$local_pwd_archive" -d "$local_pwd"
		echo "$local_pwd"
	else
		echo "$PWD"
	fi
}

# Upload the contents of the given local PWD to the given remote PWD
upload() {
	local local_pwd="$1"
	local remote_pwd="$2"
	pushd "$local_pwd" > /dev/null
	rsync \
		--archive \
		--checksum \
		--compress \
		--exclude '.DS_Store' \
		--exclude '.env' \
		--exclude '.git' \
		--exclude '.sass-cache' \
		--rsh "ssh -p $SSH_PORT" \
		--verbose \
		"$local_pwd"/ \
		"$SSH_USER"@"$SSH_HOSTNAME":"$remote_pwd"
	popd > /dev/null
}

deploy() {
	local current_env="$(getenv)"
	if [ -n "$current_env" ]; then
		source "$current_env"
		if [ -n "$REMOTE_ROOT" ]; then
			local local_root="$(dirname "$current_env")"
			# Cerate a temporary directory in case it's needed (and create it
			# here so we can delete it after everything is done)
			local temp_dir="$(mktemp -d)"
			local local_pwd="$(get-local-pwd "$temp_dir")"
			local remote_pwd="${PWD/#$local_root/$REMOTE_ROOT}"
			upload "$local_pwd" "$remote_pwd"
			rm -rf "$temp_dir"
		else
			>&2 echo "Directory has no remote counterpart!"
		fi
	else
		>&2 echo "Directory has no remote environment set!"
	fi
}

deploy
