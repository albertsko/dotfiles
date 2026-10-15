#!/usr/bin/env bash
set -euo pipefail

script_dir="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
readonly MSB_NAME="${MSB_NAME:-msbdev}"

if [[ "${1:-}" == --help || "${1:-}" == -h ]]; then
	printf '%s\n' \
		'Usage: msb-brew.sh [FORMULA...]' \
		'Install Linux-compatible formulas into the shared Homebrew installation.' \
		'Without arguments, mirror all installed formulas on this host. Casks are excluded.' \
		'Explicit names select a smaller set. Installation failures stop the command.' \
		'MSB_NAME selects the sandbox. Existing sandboxes keep their original mounts.' \
		'Use a new MSB_NAME with MSB_DATA_DIR for a separate Homebrew installation.'
	exit 0
fi

inventory="$(mktemp)"
trap 'rm -f -- "$inventory"' EXIT
if (($#)); then
	printf '%s\n' "$@" >"$inventory"
else
	brew list --formula --full-name >"$inventory"
fi

bash "$script_dir/msbdev.sh" -- /bin/true
guest_inventory="/tmp/$(basename -- "$inventory")"
# Expand the positional parameter in the guest shell.
# shellcheck disable=SC2016
msb exec --stream "$MSB_NAME" -- /bin/sh -c 'cat > "$1"' -- "$guest_inventory" <"$inventory"
msb exec --no-stdin "$MSB_NAME" -- /bin/bash \
	/home/dev/.local/state/dotfiles/msb/.config/msb/install-packages.sh "$guest_inventory"
msb exec --no-stdin "$MSB_NAME" -- rm -f -- "$guest_inventory"
