#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

bash "$SCRIPT_DIR/.scripts/sudo-touchid.sh"
bash "$SCRIPT_DIR/.scripts/brew.sh"
bash "$SCRIPT_DIR/.scripts/macos.sh"
