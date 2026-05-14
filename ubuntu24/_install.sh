#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"

bash "$SCRIPT_DIR/.local/bin/00-init.sh"
bash "$SCRIPT_DIR/.local/bin/01-dev.sh"
bash "$SCRIPT_DIR/.local/bin/02-docker.sh"
bash "$SCRIPT_DIR/.local/bin/03-ufw.sh"
bash "$SCRIPT_DIR/.local/bin/04-fonts.sh"
bash "$SCRIPT_DIR/.local/bin/05-gnome.sh"
