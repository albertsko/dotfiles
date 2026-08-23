#!/usr/bin/env bash
set -euo pipefail

readonly CONFIG_DIR=/config/rclone
readonly CONFIG_PATH="$CONFIG_DIR/rclone.conf"
readonly FILTERS_PATH=/state/filters.conf
readonly SYNC_SETTINGS_PATH=/state/sync-settings-version
readonly SYNC_SETTINGS_VERSION=1
readonly DATA_DIR=/data
readonly BACKUP_DIR=/backup
readonly REMOTE_PATH=gdrive:
readonly ACCESS_CHECK_PATH="$DATA_DIR/RCLONE_TEST"
readonly REMOTE_ACCESS_CHECK_PATH="${REMOTE_PATH}RCLONE_TEST"
readonly STATE_WORK_DIR=/state/bisync
readonly DRY_RUN_WORK_DIR=/tmp/gdrive-bisync
readonly USER_ID="${PUID:-1000}"
readonly GROUP_ID="${PGID:-1000}"
readonly RUN_USER="$USER_ID:$GROUP_ID"
readonly SYNC_INTERVAL_SECONDS=300
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
	local status
	if wait "$CHILD_PID"; then
		status=0
	else
		status=$?
	fi
	CHILD_PID=""
	return "$status"
}

run_bisync() {
	local work_dir=$1
	shift
	local timestamp
	timestamp="$(date -u +%Y%m%dT%H%M%SZ)" || die 'cannot create backup timestamp'
	local -a args=(
		bisync "$DATA_DIR" "$REMOTE_PATH"
		--config "$CONFIG_PATH"
		--workdir "$work_dir"
		--filters-file "$FILTERS_PATH"
		--drive-skip-gdocs
		--drive-skip-shortcuts
		--max-delete 10
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

trap stop INT TERM

command_name="${1:-service}"
shift || true

case "$command_name" in
config | service)
	(($# == 0)) || die "unexpected argument: $1"
	;;
resync)
	(($# <= 1)) || die "unexpected argument: $2"
	[[ $# == 0 || $1 == --apply ]] || die "unknown option: $1"
	;;
*) die "unknown command: $command_name" ;;
esac

[[ $USER_ID =~ ^[0-9]+$ ]] || die 'PUID must be numeric'
[[ $GROUP_ID =~ ^[0-9]+$ ]] || die 'PGID must be numeric'

mkdir -p "$CONFIG_DIR" "$STATE_WORK_DIR" "$BACKUP_DIR" "$DATA_DIR"
chown -R "$RUN_USER" "$CONFIG_DIR" /state
chmod 700 "$CONFIG_DIR" /state "$STATE_WORK_DIR"
cp /etc/gdrive/filters.conf "$FILTERS_PATH"
chown "$RUN_USER" "$FILTERS_PATH"
chmod 600 "$FILTERS_PATH"
su-exec "$RUN_USER" test -w "$DATA_DIR" || die "$DATA_DIR is not writable"
su-exec "$RUN_USER" test -w "$BACKUP_DIR" || die "$BACKUP_DIR is not writable"

case "$command_name" in
config)
	run_rclone config --config "$CONFIG_PATH" || die 'rclone configuration failed'
	remotes="$(su-exec "$RUN_USER" rclone listremotes --config "$CONFIG_PATH")" || die 'cannot list rclone remotes'
	[[ $'\n'${remotes}$'\n' == *$'\ngdrive:\n'* ]] || die 'configuration must contain a remote named gdrive'
	;;
resync)
	[[ -s $CONFIG_PATH ]] || die 'run gdrive.sh config first'
	if [[ ${1:-} == --apply ]]; then
		[[ ! -e $ACCESS_CHECK_PATH || -f $ACCESS_CHECK_PATH ]] || die "$ACCESS_CHECK_PATH must be a regular file"
		run_rclone touch "$ACCESS_CHECK_PATH" --config "$CONFIG_PATH" || die "cannot create $ACCESS_CHECK_PATH"
		run_rclone touch "$REMOTE_ACCESS_CHECK_PATH" --config "$CONFIG_PATH" || die "cannot create $REMOTE_ACCESS_CHECK_PATH"
		run_bisync "$STATE_WORK_DIR" --check-access --resync-mode newer || die 'resync failed'
		printf '%s\n' "$SYNC_SETTINGS_VERSION" >"$SYNC_SETTINGS_PATH"
		chown "$RUN_USER" "$SYNC_SETTINGS_PATH"
		chmod 600 "$SYNC_SETTINGS_PATH"
		exit 0
	fi
	mkdir -p "$DRY_RUN_WORK_DIR"
	chown "$RUN_USER" "$DRY_RUN_WORK_DIR"
	run_bisync "$DRY_RUN_WORK_DIR" --resync-mode newer --dry-run
	;;
service)
	while :; do
		sync_settings_version=""
		[[ ! -f $SYNC_SETTINGS_PATH ]] || sync_settings_version="$(<"$SYNC_SETTINGS_PATH")"
		if [[ -s $CONFIG_PATH && $sync_settings_version == "$SYNC_SETTINGS_VERSION" ]]; then
			run_bisync "$STATE_WORK_DIR" --check-access --track-renames || printf '%s\n' 'Google Drive sync failed.' >&2
		elif [[ -s $CONFIG_PATH ]]; then
			printf '%s\n' 'Google Drive requires resync. Run gdrive.sh resync, then gdrive.sh resync --apply.' >&2
		else
			printf '%s\n' 'Google Drive is not configured. Run gdrive.sh config.' >&2
		fi
		CHILD_SIGNAL=TERM
		sleep "$SYNC_INTERVAL_SECONDS" &
		CHILD_PID=$!
		wait "$CHILD_PID" || true
		CHILD_PID=""
		CHILD_SIGNAL=INT
	done
	;;
esac
