#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

docker compose -f "$SCRIPT_DIR/compose.yml" up -d --build --wait --wait-timeout 3600 ubuntu-install
docker compose -f "$SCRIPT_DIR/compose.yml" exec -T ubuntu-install bash ./.test/test.sh
