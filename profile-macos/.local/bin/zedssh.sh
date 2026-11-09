#!/usr/bin/env bash
set -euo pipefail

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/zedssh"
MOUNT_ROOT="$HOME/mnt"

# Lets the read loop in forward_changes keep `since` and `dirs` for the next heartbeat and reconnect.
shopt -s lastpipe

# Runs on the server: every 2s print each changed directory, then a heartbeat with the server's UTC scan time.
# After a reconnect, $since restarts the scan from the last heartbeat, so changes during the outage are not lost.
remote_watch() {
	cat <<'EOF'
m=$(mktemp) || exit 1
n=$m
trap 'rm -f "$m" "$n"' EXIT
trap 'exit 0' HUP PIPE TERM
[ -z "$since" ] || TZ=UTC0 touch -t "$since" "$m"
while sleep 1; do
	t=$(date -u +%Y%m%d%H%M.%S)
	n=$(mktemp) || exit 1
	# Some finds compare whole seconds, so scan only after the marker's second has passed.
	sleep 1
	find . \( -path ./.git/objects -o -name node_modules -o -name target -o -name .venv -o -name dist -o -name build \) -type d -prune \
		-o -newer "$m" \( -type d -print -o -exec sh -c 'for f; do echo "${f%/*}"; done' sh {} + \) 2>/dev/null | sort -u
	mv -f "$n" "$m"
	echo "@$t"
done
EOF
}

die() {
	printf 'Error: %s\n' "$1" >&2
	exit 2
}

is_mounted() {
	[[ "$(mount)" == *" on $1 ("* ]]
}

# Single quotes are the only quoting every remote sh understands.
sh_quote() {
	printf "'%s'" "${1//\'/\'\\\'\'}"
}

# Makes rclone re-list each changed directory, then touches it so Zed gets a local file event.
refresh() {
	local dir i=0 keys=()
	for dir; do
		# A file key clears only its parent's listing, while a dir key drops the whole cached subtree.
		keys+=("file$((i++))=${dir:+$dir/}-")
	done
	# xargs splits a large burst into several calls that each fit the argument limit.
	printf '%s\0' "${keys[@]}" | xargs -0 rclone rc --unix-socket "$sock" vfs/forget >/dev/null 2>&1 || true

	for dir; do
		# rclone never sends folder times to the server, so this only emits a local folder event.
		touch -r "$mnt/$dir" "$mnt/$dir" 2>/dev/null || true
	done
}

# NFS and SFTP never report server-side changes, so turn each one into a local file event for Zed.
forward_changes() {
	local line dir since='' dirs=() rclone_pid
	# A pid check also stops this forwarder when its rclone dies and a later run remounts the same path.
	rclone_pid=$(rclone rc --unix-socket "$sock" core/pid | tr -dc 0-9)
	while kill -0 "$rclone_pid" 2>/dev/null; do
		{
			printf 'cd -- %s >/dev/null || exit 1\nsince=%s\n' "$(sh_quote "${path:-.}")" "$(sh_quote "$since")"
			remote_watch
		} | ssh -T -o BatchMode=yes -o ConnectTimeout=10 -o ServerAliveInterval=15 -o ServerAliveCountMax=3 "$host" sh -s |
			while IFS= read -r line; do
				if [[ "$line" != @* ]]; then
					dir=${line#.}
					dirs+=("${dir#/}")
					continue
				fi

				since=${line#@}
				kill -0 "$rclone_pid" 2>/dev/null || break
				((${#dirs[@]})) || continue
				refresh "${dirs[@]}"
				dirs=()
			done || true

		kill -0 "$rclone_pid" 2>/dev/null || break
		printf '%s forwarder: ssh ended, retrying in 5s\n' "$(date '+%F %T')"
		sleep 5
	done
}

(($# == 1)) || die 'usage: zedssh.sh <ssh-host>[:path]'
[[ "$(uname -s)" == Darwin ]] || die 'macOS only'
command -v rclone >/dev/null || die 'rclone not found'
command -v zed >/dev/null || die 'zed not found'

target=$1
host=${target%%:*}
path=''
[[ "$target" == *:* ]] && path=${target#*:}
[[ -n "$host" ]] || die 'missing ssh host'
[[ "$path" != '~'* ]] || die 'write the path relative to the remote home, without ~'

slug=${path#/}
name="$host${slug:+-${slug//\//-}}"
mnt="$MOUNT_ROOT/$name"
log="$STATE_DIR/$name.log"
# macOS limits socket paths to 104 bytes, so the socket is named by checksum.
sock="$STATE_DIR/$(printf %s "$name" | cksum | cut -d' ' -f1).sock"

# The --sftp-ssh suffix stops ~/mnt/pi from matching ~/mnt/pi-x.
procs="$(ps -axww -o args=)"
if is_mounted "$mnt" && [[ "$procs" != *" $mnt --sftp-ssh "* ]]; then
	printf 'Removing stale mount %s\n' "$mnt"
	umount -f "$mnt" 2>/dev/null || diskutil unmount force "$mnt"
fi
if is_mounted "$mnt" && [[ "$procs" != *"nfsmount :sftp:$path $mnt --sftp-ssh "* ]]; then
	die "$mnt is already mounted for another target"
fi

# Only the run that creates the mount starts a forwarder, and the forwarder stops when the mount goes away.
if ! is_mounted "$mnt"; then
	ssh -T -o BatchMode=yes -o ConnectTimeout=10 "$host" true </dev/null ||
		die "cannot ssh to $host without a prompt"

	mkdir -p -- "$mnt" "$STATE_DIR"
	# The rc socket has no auth, so only this user may reach it.
	chmod 700 "$STATE_DIR"
	rm -f -- "$sock"
	# --vfs-write-back 0s uploads each save on close, so an immediate umount keeps it.
	rclone nfsmount ":sftp:$path" "$mnt" \
		--sftp-ssh "ssh -T -o BatchMode=yes $host" \
		--sftp-shell-type unix \
		--sftp-disable-hashcheck \
		--vfs-cache-mode full \
		--vfs-write-back 0s \
		--dir-cache-time 5s \
		--volname "$name" \
		--cache-dir "$STATE_DIR/cache/$name" \
		--rc \
		--rc-addr "unix://$sock" \
		--rc-no-auth \
		--log-file "$log" \
		--daemon \
		--daemon-wait 0 ||
		die "rclone failed, see $log"

	# On macOS --daemon-wait is a fixed sleep, so wait for the mount here.
	for _ in {1..300}; do
		is_mounted "$mnt" && break
		sleep 0.1
	done
	is_mounted "$mnt" || die "mount did not appear, see $log"

	(
		trap '' HUP
		forward_changes
	) </dev/null >>"$log" 2>&1 &
	disown
fi

zed "$mnt"
printf 'Mounted %s on %s\nUnmount: umount %s\n' "$target" "$mnt" "$mnt"
