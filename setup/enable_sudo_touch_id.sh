#!/usr/bin/env bash

enable_sudo_touch_id() {
	local auth_file_path=/etc/pam.d/sudo
	local tid_line='auth       sufficient     pam_tid.so'
	if ! cat "$auth_file_path" | grep -qF "$tid_line"; then
		local updated_auth_file_contents="$(awk "NR==1{print; print \"$tid_line\"} NR!=1" $auth_file_path)"
		echo "$updated_auth_file_contents"
		echo ''
		read -rp "Overwrite $auth_file_path with the above? " answer
		if [[ "$answer" =~ y ]]; then
			echo "$updated_auth_file_contents" | sudo tee "$auth_file_path" > /dev/null
			echo "Done. Please restart the Terminal application."
		fi
	else
		echo "macOS Terminal should already support Touch ID!"
	fi
}
enable_sudo_touch_id
