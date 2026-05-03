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

stow_package() {
	local action="$1"
	local package="$2"
	shift 2

	echo "==> $action $package -> $HOME"
	stow "${base_flags[@]}" "$@" "$package"
}

if [[ "$DELETE" == "1" ]]; then
	stow_package unstow "$DOTFILES_PROFILE" --delete
	stow_package unstow _common --delete
	exit 0
fi

stow_package stow _common --restow --defer='.*'
stow_package stow "$DOTFILES_PROFILE" --restow --override='.*'
