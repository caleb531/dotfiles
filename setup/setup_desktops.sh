#!/usr/bin/env bash

set -euo pipefail

# The current UUID of Desktop 2 on the first display; read it before changing
# assignments so a missing Desktop stops the script without applying changes
desktop_2_uuid="$(
	defaults export com.apple.spaces - |
		plutil -extract \
			'SpacesDisplayConfiguration.Management Data.Monitors.0.Spaces.1.uuid' \
			raw -o - -
)"

# The current UUID of Desktop 3 on the first display; read it before changing
# assignments so a missing Desktop stops the script without applying changes
desktop_3_uuid="$(
	defaults export com.apple.spaces - |
		plutil -extract \
			'SpacesDisplayConfiguration.Management Data.Monitors.0.Spaces.2.uuid' \
			raw -o - -
)"

echo "Assigning apps to Desktop 1..."

# The Dock uses lowercase bundle IDs and an empty string for Desktop 1
defaults write com.apple.spaces app-bindings -dict-add com.brave.browser ""
defaults write com.apple.spaces app-bindings -dict-add com.apple.terminal ""
defaults write com.apple.spaces app-bindings -dict-add com.microsoft.vscode ""
defaults write com.apple.spaces app-bindings -dict-add com.apple.mobilesms ""

echo "Assigning apps to Desktop 2..."

# Use the current Desktop UUID so we don't reuse an ID from before a restart
defaults write com.apple.spaces app-bindings -dict-add com.apple.mail "$desktop_2_uuid"
defaults write com.apple.spaces app-bindings -dict-add com.apple.ical "$desktop_2_uuid"
defaults write com.apple.spaces app-bindings -dict-add com.apple.reminders "$desktop_2_uuid"

echo "Assigning apps to Desktop 3..."

# Keep Music on its own Desktop
defaults write com.apple.spaces app-bindings -dict-add com.apple.music "$desktop_3_uuid"

# Restart the Dock once so it reloads all assignments
echo "Restarting Dock..."
killall Dock
