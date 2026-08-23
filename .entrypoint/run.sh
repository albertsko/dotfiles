#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
readonly SCRIPT_DIR

mkdir -p "$SCRIPT_DIR/.bin"
readonly BUILD_PATH="$SCRIPT_DIR/.bin/entrypoint"

go -C "$SCRIPT_DIR" build -o "$BUILD_PATH" .
exec "$BUILD_PATH" "$@"
