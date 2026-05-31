#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"

mkdir -p "$SCRIPT_DIR/.bin"
build="$SCRIPT_DIR/.bin/build"

go -C "$SCRIPT_DIR/src" build -o "$build" .
exec "$build" "$@"
