#!/usr/bin/env bash
set -euo pipefail

readonly INSTANCE_NAME="limadev"
script_dir="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
DOTFILES_HOME="${DOTFILES_HOME:-$(realpath -- "$script_dir/../../..")}"
readonly DOTFILES_HOME
readonly DOTFILES_REF="${LIMADEV_DOTFILES_REF:-$(git -C "$DOTFILES_HOME" branch --show-current)}"

forward_gh=0
recreate=0
shell_env=(TERM=xterm-256color LIMA_SHELLENV_BLOCK='*' LIMA_SHELLENV_ALLOW=)

while (($#)); do
	case "$1" in
	--gh | -gh) forward_gh=1 ;;
	--nossh | -nossh)
		# A reused SSH connection can retain its forwarded agent.
		shell_env+=('SSH=ssh -o ForwardAgent=no -o ControlMaster=no -o ControlPath=none -o ControlPersist=no')
		;;
	--recreate) recreate=1 ;;
	-h | --help)
		printf '%s\n' \
			'Usage: limadev.sh [--gh|-gh] [--nossh|-nossh] [--recreate] [--] [COMMAND [ARG...]]' \
			'' \
			'  --gh, -gh        Forward GH_TOKEN or the host gh login (default: off).' \
			'  --nossh, -nossh  Disable SSH agent forwarding for this session (default: on).' \
			'  --recreate       Delete and recreate the VM before connecting.' \
			'  -h, --help       Show this help.'
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

((forward_gh)) && gh_token="${GH_TOKEN:-$(gh auth token --hostname github.com)}"
((forward_gh)) && shell_env+=("GH_TOKEN=$gh_token" LIMA_SHELLENV_ALLOW=GH_TOKEN)

mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}/albertsko-skills"

((recreate == 0)) || limactl delete --force "$INSTANCE_NAME" >/dev/null 2>&1 || true

limactl list "$INSTANCE_NAME" --format '{{.Name}}' >/dev/null 2>&1 ||
	limactl start \
		--name="$INSTANCE_NAME" \
		--param="DOTFILES_REF=$DOTFILES_REF" \
		--progress \
		--timeout=30m \
		--tty=false \
		"$DOTFILES_HOME/lima/.config/lima/limadev.yml"

docker_host="$(limactl list "$INSTANCE_NAME" --format 'unix://{{.Dir}}/sock/docker.sock')"
context_action=update
docker context inspect "$INSTANCE_NAME" >/dev/null 2>&1 || context_action=create
docker context "$context_action" "$INSTANCE_NAME" --docker "host=$docker_host" >/dev/null

exec env "${shell_env[@]}" \
	limactl shell --start --preserve-env "$INSTANCE_NAME" -- "$@"
