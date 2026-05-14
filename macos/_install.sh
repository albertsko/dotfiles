#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"

bash "$SCRIPT_DIR/.local/bin/sudo-touchid.sh"
bash "$SCRIPT_DIR/.local/bin/brew.sh"
bash "$SCRIPT_DIR/.local/bin/macos.sh"
