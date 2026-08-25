#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
BIN_DIR="$SCRIPT_DIR/.bin"

mkdir -p "$BIN_DIR"

APP="$1"
shift 1

BUILD_PATH="$BIN_DIR/$APP"

go -C "$SCRIPT_DIR/$APP" build -o "$BUILD_PATH" .
exec "$BUILD_PATH" "$@"
