#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
readonly SCRIPT_DIR
readonly BIN_DIR="$SCRIPT_DIR/.bin"

die() {
	printf 'Error: %s\n' "$1" >&2
	exit 1
}

[[ ${1:-} ]] || die 'missing app name'

app=$1
shift

app_path="$SCRIPT_DIR/$app"
build_path="$BIN_DIR/$app"

[[ -d "$app_path" ]] || die "unknown app: $app"

mkdir -p "$BIN_DIR"
go -C "$app_path" build -o "$build_path" .
exec "$build_path" "$@"
