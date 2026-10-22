#!/usr/bin/env bash
set -euo pipefail

state_home="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_STATE_HOME="${state_home%/opencode-work}"
unset OPENCODE_CONFIG_DIR OPENCODE_DB

exec opencode "$@"
