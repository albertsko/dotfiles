#!/usr/bin/env bash

set -euo pipefail

SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname -- "$SCRIPT_PATH")"

DOTFILES_HOME="${DOTFILES_HOME:-$(realpath "$SCRIPT_DIR/../..")}"
DOTFILES_PROFILE="${DOTFILES_PROFILE:-}"
DRY_RUN="${DOTFILES_DRY_RUN:-0}"
DELETE=0

usage() {
	printf 'Usage: %s [--delete|-D] [--dry-run|-n|--simulate] [profile]\n' "$(basename -- "$0")" >&2
}

for arg in "$@"; do
	case "$arg" in
	--delete | -D) DELETE=1 ;;
	--simulate | -n | --dry-run) DRY_RUN=1 ;;
	--*)
		echo "Error: unknown flag '$arg'" >&2
		usage
		exit 1
		;;
	*) DOTFILES_PROFILE="$arg" ;;
	esac
done

if [[ -z "$DOTFILES_PROFILE" ]]; then
	echo "Error: DOTFILES_PROFILE is not set. Export it or pass it as an argument." >&2
	usage
	exit 1
fi

if [[ ! -d "$DOTFILES_HOME/_common" ]]; then
	echo "Error: common stow package is missing: $DOTFILES_HOME/_common" >&2
	exit 1
fi

if [[ ! -d "$DOTFILES_HOME/$DOTFILES_PROFILE" ]]; then
	echo "Error: profile stow package is missing: $DOTFILES_HOME/$DOTFILES_PROFILE" >&2
	exit 1
fi

base_flags=(--dir="$DOTFILES_HOME" --target="$HOME" --no-folding --verbose=1)
[[ "$DRY_RUN" == "1" ]] && base_flags+=(-n)

if [[ "$DELETE" == "1" ]]; then
	echo "==> unstow $DOTFILES_PROFILE -> $HOME"
	stow "${base_flags[@]}" --delete "$DOTFILES_PROFILE"
	echo "==> unstow _common -> $HOME"
	stow "${base_flags[@]}" --delete _common
	exit 0
fi

echo "==> stow _common -> $HOME"
stow "${base_flags[@]}" --restow --defer='.*' _common
echo "==> stow $DOTFILES_PROFILE -> $HOME"
stow "${base_flags[@]}" --restow --override='.*' "$DOTFILES_PROFILE"
