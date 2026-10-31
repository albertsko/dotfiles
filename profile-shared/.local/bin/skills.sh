#!/usr/bin/env bash
set -euo pipefail

script_path="$(realpath -- "${BASH_SOURCE[0]}")"
readonly script_path
script_dir="$(dirname -- "$script_path")"
readonly script_dir
DOTFILES_HOME="$(realpath -- "$script_dir/../../..")"
readonly DOTFILES_HOME
export DOTFILES_HOME

if [[ ${1:-} != "--cd" ]]; then
	exec "$DOTFILES_HOME/apps/run.sh" skills "$@"
fi

(($# == 1)) || {
	printf 'Error: unexpected argument: %s\n' "$2" >&2
	exit 1
}

cd "$DOTFILES_HOME"
exec "${SHELL:-/bin/bash}" -i
