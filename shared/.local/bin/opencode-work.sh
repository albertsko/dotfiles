#!/usr/bin/env bash
set -euo pipefail

state_home="${XDG_STATE_HOME:-$HOME/.local/state}"

export OPENCODE_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/opencode-work"
export OPENCODE_DB="${XDG_DATA_HOME:-$HOME/.local/share}/opencode-work/opencode.db"
export XDG_STATE_HOME="${state_home%/opencode-work}/opencode-work"

mkdir -p -- "${OPENCODE_DB%/*}"
[[ -n "$(opencode service get port)" ]] || opencode service set port 49380

exec opencode "$@"
