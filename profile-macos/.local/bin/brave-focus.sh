#!/usr/bin/env bash
set -euo pipefail

readonly BRAVE_APP="/Applications/Brave Browser.app"
SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
readonly SCRIPT_DIR
readonly EXTENSION_DIR="$SCRIPT_DIR/../share/brave-focus/extension"
readonly PROFILE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/brave-focus"

die() {
	printf 'Error: %s\n' "$1" >&2
	exit 1
}

(($# == 0)) || die "unexpected argument: $1"
[[ "$(uname -s)" == Darwin ]] || die 'macOS only'
[[ -d "$BRAVE_APP" ]] || die "Brave is not installed: $BRAVE_APP"
[[ -f "$EXTENSION_DIR/manifest.json" ]] || die "focus extension is missing: $EXTENSION_DIR"

extension_dir="$(realpath -- "$EXTENSION_DIR")" || die "cannot resolve focus extension: $EXTENSION_DIR"
mkdir -p -- "$PROFILE_DIR" || die "cannot create focus profile: $PROFILE_DIR"
open -n -F -a "$BRAVE_APP" --args \
	"--user-data-dir=$PROFILE_DIR" \
	"--load-extension=$extension_dir" \
	--no-first-run \
	--no-default-browser-check || die 'cannot start Brave'
