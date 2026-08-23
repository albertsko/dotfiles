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

usage() {
	printf '%s\n' \
		'Usage: gdrive.sh COMMAND' \
		'' \
		'Commands:' \
		'  config              Configure the gdrive rclone remote' \
		'  init [--apply]      Preview or apply the initial merge' \
		'  start               Start the sync service' \
		'  stop                Stop the sync service' \
		'  status              Show service status' \
		'  logs                Follow service logs'
}

compose() {
	docker compose --project-directory "$SCRIPT_DIR" -f "$SCRIPT_DIR/compose.yml" "$@"
}

command_name="${1:-}"
shift || true

case "$command_name" in
help | -h | --help | '')
	(($# == 0)) || die "unexpected argument: $1"
	usage
	exit 0
	;;
config | init | start | stop | status | logs) ;;
*) die "unknown command: $command_name" ;;
esac

command -v docker >/dev/null || die 'docker is required'
docker compose version >/dev/null 2>&1 || die 'docker compose is required'
docker info >/dev/null 2>&1 || die 'Docker-compatible daemon is unavailable'

mkdir -p "$DATA_DIR" "$BACKUP_DIR"
chmod 700 "$DATA_DIR" "$BACKUP_DIR"
PUID=$(id -u)
PGID=$(id -g)
export PUID PGID

case "$command_name" in
config)
	(($# == 0)) || die "unexpected argument: $1"
	compose stop
	compose run --rm gdrive config
	;;
init)
	(($# <= 1)) || die "unexpected argument: $2"
	[[ $# == 0 || $1 == --apply ]] || die "unknown option: $1"
	compose stop
	compose run --rm gdrive init "$@"
	[[ ${1:-} != --apply ]] || compose up -d
	;;
start)
	(($# == 0)) || die "unexpected argument: $1"
	compose up -d
	;;
stop)
	(($# == 0)) || die "unexpected argument: $1"
	compose stop
	;;
status)
	(($# == 0)) || die "unexpected argument: $1"
	compose ps
	;;
logs)
	(($# == 0)) || die "unexpected argument: $1"
	compose logs -f
	;;
esac
