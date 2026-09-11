#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
SSH_MODE="${DOTFILES_SSH_MODE:-local}"

die() {
	printf 'Error: %s\n' "$1" >&2
	exit 1
}

(($# == 0)) || die "unexpected argument: $1"

case "$SSH_MODE" in
local) bash "$SCRIPT_DIR/.local/bin/ssh.sh" ;;
forwarded) ;;
*) die "unsupported DOTFILES_SSH_MODE: $SSH_MODE" ;;
esac

bash "$SCRIPT_DIR/.local/bin/git.sh"
