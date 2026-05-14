#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"

mkdir -p "$SCRIPT_DIR/.bin"
entrypoint_go_build="$SCRIPT_DIR/.bin/entrypoint"

go -C "$SCRIPT_DIR" build -o "$entrypoint_go_build" .
exec "$entrypoint_go_build" "$@"
