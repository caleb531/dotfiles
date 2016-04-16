#!/usr/bin/env bash

# Removes the given public SSH key from the server
__ssh_remove_id() {
	local pub_key="$1"
	local escaped_pub_key="$(echo "$pub_key" | sed -e 's/[\/+]/\\&/g')"
	local pattern="$escaped_pub_key (.*)\$"
	local auth_keys_file="$HOME/.ssh/authorized_keys"
	local new_auth_keys="$(cat "$auth_keys_file" | egrep -v "$pattern")"
	echo "$new_auth_keys" > "$auth_keys_file"
}
__ssh_remove_id "$*"
