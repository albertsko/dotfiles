#!/usr/bin/env bash

set -euo pipefail

REPO_URL="${DOTFILES_REPO_URL:-https://github.com/albertsko/dotfiles.git}"
PROFILE="${1:-${DOTFILES_PROFILE:-}}"

case "$PROFILE" in
macOS | macos | darwin) PROFILE="macOS" ;;
work) PROFILE="work" ;;
ubuntu | linux) PROFILE="ubuntu" ;;
*)
	echo "Unknown dotfiles profile: $PROFILE" >&2
	echo "Expected one of: macOS, work, ubuntu" >&2
	exit 1
	;;
esac

touch "$HOME/.hushlogin"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export DOTFILES_HOME="$XDG_DATA_HOME/dotfiles"

mkdir -p "$XDG_CONFIG_HOME"
mkdir -p "$XDG_CACHE_HOME"
mkdir -p "$XDG_DATA_HOME"
mkdir -p "$XDG_STATE_HOME"
mkdir -p "$DOTFILES_HOME"

if [[ -d "$DOTFILES_HOME/.git" ]]; then
	git -C "$DOTFILES_HOME" pull --ff-only
else
	git clone "$REPO_URL" "$DOTFILES_HOME"
fi

bash "$DOTFILES_HOME/_common/.install.sh"
bash "$DOTFILES_HOME/$PROFILE/.install.sh"

stow_flags=(--dir="$DOTFILES_HOME" --target="$HOME" --no-folding)
if [[ "${DOTFILES_STOW_ADOPT:-0}" == "1" ]]; then
	stow_flags+=(--adopt)
else
	stow_flags+=(--restow)
fi

stow "${stow_flags[@]}" "$PROFILE"
