#!/usr/bin/env bash
set -euo pipefail

script_dir="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
DOTFILES_HOME="${DOTFILES_HOME:-$(realpath -- "$script_dir/../../..")}"
readonly DOTFILES_HOME
readonly MSB_DIR="$DOTFILES_HOME/profile-macos/.config/msb"
readonly MSB_IMAGE="msbdev:latest"
readonly DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/microsandbox"
readonly BREW_DIR="$DATA_DIR/brew"
readonly BREW_IMAGE="$DATA_DIR/brew.sparsebundle"
readonly OPENCODE_DB_DIR="$DATA_DIR/opencode"
readonly OPENCODE_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"
readonly SSH_AGENT_PORT=5022

forward_ssh=0
build=0

while (($#)); do
	case "$1" in
	--ssh | -ssh) forward_ssh=1 ;;
	--build) build=1 ;;
	-h | --help)
		printf '%s\n' \
			'Usage: msbdev.sh [--ssh|-ssh] [--build] [--] [COMMAND [ARG...]]' \
			'' \
			'Run a fresh development sandbox that is removed on exit.' \
			'' \
			'  --ssh, -ssh  Forward the host SSH agent (default: off).' \
			'  --build      Rebuild the image before running.' \
			'  -h, --help   Show this help.'
		exit 0
		;;
	--)
		shift
		break
		;;
	-*)
		printf 'Unknown option: %s\n' "$1" >&2
		exit 2
		;;
	*) break ;;
	esac
	shift
done

if ((build)) || ! msb image inspect "$MSB_IMAGE" >/dev/null 2>&1; then
	docker buildx build --pull --provenance=false --tag "$MSB_IMAGE" \
		--output type=docker,dest=- "$MSB_DIR" | msb load
fi

mkdir -p "$BREW_DIR" "$HOME/dev" "$OPENCODE_DB_DIR"
[[ -d "$BREW_IMAGE" ]] ||
	hdiutil create -quiet -size 200g -type SPARSEBUNDLE -fs "Case-sensitive APFS" \
		-volname msb-brew "$BREW_IMAGE"
# A mounted volume has a different device ID than its parent directory.
[[ "$(stat -f %d "$BREW_DIR")" != "$(stat -f %d "$DATA_DIR")" ]] ||
	hdiutil attach -quiet -nobrowse -owners off -mountpoint "$BREW_DIR" "$BREW_IMAGE"

name="msbdev-$(date +%Y%m%d-%H%M%S)-$$"
run_args=(
	--conf "$MSB_DIR/msbdev.yaml"
	--name "$name"
	--quiet
	--mount-owned "/var/lib/docker:kind=disk,size=64G"
	--volume "$HOME/dev:/home/dev/dev:uid=1000,gid=1000"
	--volume "$BREW_DIR:/home/linuxbrew/.linuxbrew:uid=1000,gid=1000"
	--volume "$OPENCODE_DB_DIR:/home/dev/.local/share/opencode-db:uid=1000,gid=1000"
	--env TERM=xterm-256color
)

# service.json holds the host service password; the sandbox runs its own service.
for path in "$OPENCODE_CONFIG_DIR"/*; do
	[[ -e "$path" && "${path##*/}" != service.json ]] || continue
	source="$(realpath -- "$path")"
	mount_flag=--mount-file
	[[ ! -d "$source" ]] || mount_flag=--mount-dir
	run_args+=("$mount_flag" "$source:/home/dev/.config/opencode/${path##*/}:ro,uid=1000,gid=1000")
done

if ((forward_ssh)); then
	[[ -S "${SSH_AUTH_SOCK:-}" ]] || {
		printf 'SSH_AUTH_SOCK does not point to an SSH agent socket.\n' >&2
		exit 1
	}
	run_args+=(--vsock "$SSH_AUTH_SOCK:$SSH_AGENT_PORT" --env "MSBDEV_SSH_AGENT_PORT=$SSH_AGENT_PORT")
fi

trap 'msb rm --force "$name" >/dev/null 2>&1 || true' EXIT
msb run "${run_args[@]}" -- "$@"
