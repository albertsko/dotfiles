#!/usr/bin/env bash
set -euo pipefail

script_dir="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
readonly DOTFILES_HOME="${DOTFILES_HOME:-$(realpath -- "$script_dir/../../..")}"
readonly MSB_IMAGE="${MSB_IMAGE:-msbdev:latest}"
readonly MSB_NAME="${MSB_NAME:-msbdev}"
readonly MSB_BUILD_DIR="${MSB_BUILD_DIR:-${XDG_CACHE_HOME:-$HOME/.cache}/msb}"
readonly MSB_DATA_DIR="${MSB_DATA_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/msbdev}"
recreate=0

while (($#)); do
	case "$1" in
	--recreate) recreate=1 ;;
	-h | --help)
		printf '%s\n' \
			'Usage: msbdev.sh [--recreate] [--] [COMMAND [ARG...]]' \
			'Create or enter the development sandbox. Build with msb-build.sh first.' \
			'--recreate replaces the sandbox and preserves the shared Homebrew installation.' \
			'Overrides: MSB_IMAGE, MSB_NAME, MSB_BUILD_DIR, MSB_DATA_DIR.' \
			'Existing instances keep their mounts. Use --recreate or a new MSB_NAME to change MSB_DATA_DIR.'
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

sandboxes="$(msb list --format json)"
sandbox_status="$(jq -r --arg name "$MSB_NAME" '.[] | select(.name == $name) | .status' <<<"$sandboxes")"

if [[ "$recreate" == 1 || -z "$sandbox_status" ]]; then
	archive="$MSB_BUILD_DIR/msbdev.oci.tar"
	[[ -f "$archive" ]] || {
		printf 'Missing image archive: %s. Run msb-build.sh first.\n' "$archive" >&2
		exit 1
	}
	msb load --input "$archive" --tag "$MSB_IMAGE"
	mkdir -p "$HOME/dev" "$MSB_DATA_DIR/brew" "$MSB_DATA_DIR/cache" "$MSB_DATA_DIR/config"
	mounts=(
		--volume "$HOME/dev:/home/dev/dev:uid=1000,gid=1000"
		--volume "$MSB_DATA_DIR/brew:/home/linuxbrew/.linuxbrew:uid=1000,gid=1000"
		--volume "$MSB_DATA_DIR/cache:/home/dev/.cache/Homebrew:uid=1000,gid=1000"
		--volume "$MSB_DATA_DIR/config:/home/dev/.config/homebrew:uid=1000,gid=1000"
	)
	for path in .codex .claude .agents .local/share/albertsko-skills; do
		[[ ! -d "$HOME/$path" ]] || mounts+=(--volume "$HOME/$path:/home/dev/$path:uid=1000,gid=1000")
	done
	replace_args=()
	((! recreate)) || replace_args+=(--replace)
	msb create --conf "$DOTFILES_HOME/msb/.config/msb/msbdev.yaml" \
		--name "$MSB_NAME" --root-disk 8G --pull never \
		"${replace_args[@]}" "${mounts[@]}" "$MSB_IMAGE"
else
	case "$sandbox_status" in
	Running) ;;
	Stopped) msb start "$MSB_NAME" ;;
	Paused) msb resume "$MSB_NAME" ;;
	*)
		printf 'Cannot enter sandbox %s in state %s.\n' "$MSB_NAME" "$sandbox_status" >&2
		exit 1
		;;
	esac
fi

msb exec --no-stdin "$MSB_NAME" -- /bin/bash /home/dev/.local/state/dotfiles/msb/_install.sh

(($#)) || set -- /bin/bash -l
exec msb exec --env TERM=xterm-256color "$MSB_NAME" -- "$@"
