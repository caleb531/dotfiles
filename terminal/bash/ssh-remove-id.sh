#!/usr/bin/env bash
# Removes the given public SSH key from the server

pub_key="$*"
escaped_pub_key="$(echo "$pub_key" | sed -e 's/[\/+]/\\&/g')"
pattern="$escaped_pub_key (.*)\$"

auth_keys_file="$HOME/.ssh/authorized_keys"
old_auth_keys="$(cat "$auth_keys_file")"
new_auth_keys="$(echo "$old_auth_keys" | egrep -v "$pattern")"

if [ "$new_auth_keys" != "$old_auth_keys" ]; then
	echo "$new_auth_keys" > "$auth_keys_file"
	echo "1 key removed."
else
	echo "Key not found."
fi
