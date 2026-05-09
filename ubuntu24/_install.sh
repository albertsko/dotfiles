#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"

bash "$SCRIPT_DIR/.scripts/00-init.sh"
bash "$SCRIPT_DIR/.scripts/01-dev.sh"
bash "$SCRIPT_DIR/.scripts/02-docker.sh"
bash "$SCRIPT_DIR/.scripts/03-ufw.sh"
bash "$SCRIPT_DIR/.scripts/04-fonts.sh"
bash "$SCRIPT_DIR/.scripts/05-gnome.sh"
