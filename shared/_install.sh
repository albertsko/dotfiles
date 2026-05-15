#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"

bash "$SCRIPT_DIR/.local/bin/ssh.sh"
bash "$SCRIPT_DIR/.local/bin/git.sh"
