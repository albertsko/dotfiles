#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
export DOTFILES_HOME="${DOTFILES_HOME:-$(dirname "$SCRIPT_DIR")}"

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

mkdir -p "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME"

run_script() {
	local script="$1"

	if [[ -f "$script" ]]; then
		bash "$script"
	fi
}

ensure_stow() {
	if command -v stow >/dev/null 2>&1; then
		return
	fi

	if [[ -x /opt/homebrew/bin/brew ]]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	fi

	if command -v brew >/dev/null 2>&1; then
		brew install stow
		return
	fi

	echo "GNU Stow is required. Install Homebrew or Stow and rerun." >&2
	exit 1
}

stow_profile() {
	local stow_flags=(--dir="$DOTFILES_HOME" --target="$HOME" --no-folding)
	if [[ "${DOTFILES_STOW_ADOPT:-0}" == "1" ]]; then
		stow_flags+=(--adopt)
	else
		stow_flags+=(--restow)
	fi

	stow "${stow_flags[@]}" macOS
}

run_script "$SCRIPT_DIR/.scripts/sudo-touchid.sh"
run_script "$SCRIPT_DIR/.scripts/brew.sh"
run_script "$SCRIPT_DIR/.scripts/macos.sh"
ensure_stow
stow_profile
