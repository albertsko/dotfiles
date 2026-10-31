#!/usr/bin/env bash
set -euo pipefail

PID_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/kawka/pid"

die() {
	printf 'Error: %s\n' "$1" >&2
	exit 2
}

(($# == 0)) || die "unexpected argument: $1"
[[ "$(uname -s)" == Darwin ]] || die 'macOS only'
command -v caffeinate >/dev/null || die 'caffeinate not found'

pid="$(cat -- "$PID_FILE" 2>/dev/null || true)"
pid_command="$(ps -p "${pid:-0}" -o args= 2>/dev/null || true)"

if [[ "$pid_command" == *"caffeinate -dimsu"* ]]; then
	kill "$pid"
	rm -f -- "$PID_FILE"
	printf 'off\n'
	exit 0
fi

mkdir -p -- "$(dirname -- "$PID_FILE")"
nohup caffeinate -dimsu </dev/null >/dev/null 2>&1 &
printf '%s\n' "$!" >"$PID_FILE"
disown
printf 'on\n'
