#!/usr/bin/env bash

echo "Configuring Codex..."

# Locate Codex user configuration while respecting a custom Codex home
codex_config_dir="${CODEX_HOME:-"$HOME/.codex"}"
# Store durable Codex settings in the standard user configuration file
codex_config_file="$codex_config_dir/config.toml"
# Read the desired Codex settings from the dotfiles repository
codex_config_source="$HOME/dotfiles/codex/config.toml"
# Read setup-managed command approvals from the dotfiles repository
codex_rules_source="$HOME/dotfiles/codex/rules/default.rules"
# Install setup-managed approvals separately from interactive approvals
codex_rules_target="$codex_config_dir/rules/default.rules"
# Symlink AGENTS.md from the dotfiles repository
codex_agentsmd_source="$HOME/dotfiles/codex/AGENTS.md"
codex_agentsmd_target="$codex_config_dir/AGENTS.md"

# Stop with a useful message when the TOML editor has not been installed yet
if ! type yq &> /dev/null; then
	echo 'yq must be installed before running this script'
	exit 1
fi

# Stop if Codex directory does not exist (although it should because it should
# already be installed at this point)
if [ ! -d "$codex_config_dir" ]; then
	>&2 echo "Codex directory does not exist: ${codex_config_dir}"
	return
fi

# Because Codex CLI's config.toml mixes configuration with machine-specific
# trust policies and other state, it's not very maintainable to symlink it into
# the dotfiles; however, we can still keep the configuration we care about most,
# then ensure they get merged into the local config.toml
yq eval-all \
	--input-format toml \
	--output-format toml \
	--inplace \
	'select(fileIndex == 0) * select(fileIndex == 1)' \
	"$codex_config_file" \
	"$codex_config_source"

# Link setup-managed approvals so repository changes apply immediately
ln -sf "$codex_rules_source" "$codex_rules_target"
# Link setup-managed approvals so repository changes apply immediately
ln -sf "$codex_agentsmd_source" "$codex_agentsmd_target"
