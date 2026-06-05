#!/usr/bin/env bash

# Codex sandboxed commands cannot write to ~/.local/state, where fnm creates
# multishell shims by default, so use a writable temp state directory there.
if [ -n "${CODEX_SANDBOX:-}" ]; then
export XDG_STATE_HOME="${TMPDIR:-/tmp}/codex-xdg-state"
mkdir -p "$XDG_STATE_HOME" 2> /dev/null
fi

eval "$(fnm env --shell bash)"
