#!/usr/bin/env bash
set -euo pipefail

readonly CONFIG_DIR=/config/rclone
readonly CONFIG_PATH="$CONFIG_DIR/rclone.conf"
readonly FILTERS_PATH=/state/filters.conf
readonly DATA_DIR=/data
readonly BACKUP_DIR=/backup
readonly REMOTE_PATH=gdrive:
readonly ACCESS_CHECK_PATH="$DATA_DIR/RCLONE_TEST"
readonly REMOTE_ACCESS_CHECK_PATH="${REMOTE_PATH}RCLONE_TEST"
readonly STATE_WORK_DIR=/state/bisync
readonly SYNC_INTERVAL_SECONDS=300
readonly USER_ID="${PUID:-1000}"
readonly GROUP_ID="${PGID:-1000}"
readonly RUN_USER="$USER_ID:$GROUP_ID"
CHILD_PID=""
CHILD_SIGNAL=INT

die() {
	printf 'Error: %s\n' "$1" >&2
	exit 1
}

stop() {
	if [[ -n $CHILD_PID ]]; then
		kill -s "$CHILD_SIGNAL" "$CHILD_PID" 2>/dev/null || true
		wait "$CHILD_PID" 2>/dev/null || true
	fi
	exit 0
}

run_rclone() {
	su-exec "$RUN_USER" rclone "$@" <&0 &
	CHILD_PID=$!
	local status=0
	wait "$CHILD_PID" || status=$?
	CHILD_PID=""
	return "$status"
}

run_bisync() {
	local timestamp
	timestamp="$(date -u +%Y%m%dT%H%M%SZ)" || die 'cannot create backup timestamp'
	local -a args=(
		bisync "$DATA_DIR" "$REMOTE_PATH"
		--config "$CONFIG_PATH"
		--workdir "$STATE_WORK_DIR"
		--filters-file "$FILTERS_PATH"
		--check-access
		--drive-skip-gdocs
		--drive-skip-shortcuts
		--max-delete 100
		--resilient
		--recover
		--max-lock 2m
		--conflict-resolve newer
		--suffix-keep-extension
		--backup-dir1 "$BACKUP_DIR/$timestamp"
		--verbose
	)
	args+=("$@")
	run_rclone "${args[@]}"
}

sync_once() {
	[[ -s $CONFIG_PATH ]] || {
		printf '%s\n' 'Google Drive is not configured. Run gdrive.sh config.' >&2
		return 0
	}

	local status=0
	run_bisync --track-renames || status=$?
	((status != 0)) || return 0

	printf 'Google Drive sync failed with status %s.\n' "$status" >&2
	((status == 7)) || return 0

	printf '%s\n' 'Google Drive requires recovery. Reconciling both sides.' >&2
	run_bisync --resync-mode newer || printf '%s\n' 'Google Drive recovery failed; retrying later.' >&2
}

sleep_until_next_sync() {
	CHILD_SIGNAL=TERM
	sleep "$SYNC_INTERVAL_SECONDS" &
	CHILD_PID=$!
	wait "$CHILD_PID" || true
	CHILD_PID=""
	CHILD_SIGNAL=INT
}

trap stop INT TERM

command_name="${1:-service}"
shift || true
(($# == 0)) || die "unexpected argument: $1"
[[ $command_name == config || $command_name == service ]] || die "unknown command: $command_name"
[[ $USER_ID =~ ^[0-9]+$ ]] || die 'PUID must be a numeric user ID'
[[ $GROUP_ID =~ ^[0-9]+$ ]] || die 'PGID must be a numeric group ID'

mkdir -p "$CONFIG_DIR" "$STATE_WORK_DIR" "$BACKUP_DIR" "$DATA_DIR"
chown -R "$RUN_USER" "$CONFIG_DIR" /state
chmod 700 "$CONFIG_DIR" /state "$STATE_WORK_DIR" "$BACKUP_DIR" "$DATA_DIR"
cp /etc/gdrive/filters.conf "$FILTERS_PATH"
chmod 600 "$FILTERS_PATH"
chown "$RUN_USER" "$FILTERS_PATH"
su-exec "$RUN_USER" test -w "$DATA_DIR" || die "$DATA_DIR is not writable by $RUN_USER"
su-exec "$RUN_USER" test -w "$BACKUP_DIR" || die "$BACKUP_DIR is not writable by $RUN_USER"

if [[ $command_name == config ]]; then
	run_rclone config --config "$CONFIG_PATH" || die 'rclone configuration failed'
	remotes="$(su-exec "$RUN_USER" rclone listremotes --config "$CONFIG_PATH")" || die 'cannot list rclone remotes'
	[[ $'\n'${remotes}$'\n' == *$'\ngdrive:\n'* ]] || die 'configuration must contain a remote named gdrive'
	[[ ! -e $ACCESS_CHECK_PATH || -f $ACCESS_CHECK_PATH ]] || die "$ACCESS_CHECK_PATH must be a regular file"
	run_rclone touch "$ACCESS_CHECK_PATH" --config "$CONFIG_PATH" || die "cannot create $ACCESS_CHECK_PATH"
	run_rclone copyto "$ACCESS_CHECK_PATH" "$REMOTE_ACCESS_CHECK_PATH" --config "$CONFIG_PATH" || die "cannot create $REMOTE_ACCESS_CHECK_PATH"
	run_bisync --resync-mode newer || die 'initial reconciliation failed'
	exit 0
fi

while :; do
	sync_once
	sleep_until_next_sync
done
