#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"

mkdir -p "$SCRIPT_DIR/.bin"
build="$SCRIPT_DIR/.bin/entrypoint"

[[ ! -x "$build" || "$SCRIPT_DIR/go.mod" -nt "$build" || "$SCRIPT_DIR/main.go" -nt "$build" ]] && {
	go -C "$SCRIPT_DIR" build -o "$build" .
}

exec "$build" "$@"
