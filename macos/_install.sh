#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"

bash "$SCRIPT_DIR/.scripts/sudo-touchid.sh"
bash "$SCRIPT_DIR/.scripts/brew.sh"
bash "$SCRIPT_DIR/.scripts/macos.sh"
