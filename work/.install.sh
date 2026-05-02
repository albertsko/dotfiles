#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
export DOTFILES_HOME="${DOTFILES_HOME:-$(dirname "$SCRIPT_DIR")}"

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

mkdir -p "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME"

ensure_stow() {
	if command -v stow >/dev/null 2>&1; then
		return
	fi

	case "$(uname -s)" in
	Darwin)
		if [[ -x /opt/homebrew/bin/brew ]]; then
			eval "$(/opt/homebrew/bin/brew shellenv)"
		fi

		if command -v brew >/dev/null 2>&1; then
			brew install stow
			return
		fi
		;;
	Linux)
		if command -v apt-get >/dev/null 2>&1; then
			sudo apt-get update
			sudo apt-get install -y stow
			return
		fi
		;;
	esac

	echo "GNU Stow is required. Install it with this machine's package manager and rerun." >&2
	exit 1
}

stow_profile() {
	local stow_flags=(--dir="$DOTFILES_HOME" --target="$HOME" --no-folding)
	if [[ "${DOTFILES_STOW_ADOPT:-0}" == "1" ]]; then
		stow_flags+=(--adopt)
	else
		stow_flags+=(--restow)
	fi

	stow "${stow_flags[@]}" work
}

ensure_stow
stow_profile
