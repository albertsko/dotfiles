#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
readonly SCRIPT_DIR
readonly DATA_DIR="$HOME/.gdrive"
readonly BACKUP_DIR="$HOME/.gdrive-bak"

die() {
	printf 'Error: %s\n' "$1" >&2
	exit 1
}

compose() {
	docker compose --project-directory "$SCRIPT_DIR" -f "$SCRIPT_DIR/compose.yml" "$@"
}

command_name="${1:-service}"
shift || true
(($# == 0)) || die "unexpected argument: $1"
[[ $command_name == config || $command_name == service ]] || die "unknown command: $command_name"

command -v docker >/dev/null || die 'docker is required'
docker info >/dev/null 2>&1 || die 'Docker-compatible daemon is unavailable'
docker compose version >/dev/null 2>&1 || die 'Docker Compose is required'

mkdir -p "$DATA_DIR" "$BACKUP_DIR"
chmod 700 "$DATA_DIR" "$BACKUP_DIR"

if [[ $command_name == config ]]; then
	compose stop
	compose build
	compose run --rm gdrive config
fi

compose up --detach --build
