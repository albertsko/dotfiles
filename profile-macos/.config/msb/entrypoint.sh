#!/usr/bin/env bash
set -euo pipefail

readonly BREW_PREFIX="/home/linuxbrew/.linuxbrew"
readonly BREW_SEED="/opt/linuxbrew"
readonly BREW_MARKER="$BREW_PREFIX/.msbdev-seeded"
readonly RUN_DIR="/run/msbdev"

readonly AS_DEV=(setpriv --reuid=dev --regid=dev --init-groups env HOME=/home/dev USER=dev LOGNAME=dev)

as_dev() {
	"${AS_DEV[@]}" "$@"
}

if [[ ! -f "$BREW_MARKER" ]]; then
	printf 'Seeding the shared Homebrew prefix...\n' >&2
	as_dev cp -a "$BREW_SEED/." "$BREW_PREFIX/"
	as_dev touch "$BREW_MARKER"
fi
# ~/.homebrew links here so tap trust persists with the shared prefix.
as_dev mkdir -p "$BREW_PREFIX/var/msbdev/homebrew"

install -d -o dev -g dev -m 0700 "$RUN_DIR"
if [[ -n "${MSBDEV_SSH_AGENT_PORT:-}" ]]; then
	export SSH_AUTH_SOCK="$RUN_DIR/ssh-agent.sock"
	as_dev socat "UNIX-LISTEN:$SSH_AUTH_SOCK,fork,mode=0600" "VSOCK-CONNECT:2:$MSBDEV_SSH_AGENT_PORT" \
		</dev/null >/var/log/ssh-agent-bridge.log 2>&1 &
fi
unset MSBDEV_SSH_AGENT_PORT

dockerd >/var/log/dockerd.log 2>&1 &
for _ in {1..120}; do
	docker info >/dev/null 2>&1 && break
	sleep 0.5
done
docker info >/dev/null 2>&1 || {
	tail -n 20 /var/log/dockerd.log >&2
	exit 1
}

exec "${AS_DEV[@]}" "$@"
