#!/usr/bin/env bash
set -euo pipefail

readonly REMOTE='gdrive:'
readonly LOCAL_DIR="${HOME}/rclone-gdrive"
readonly STALE_THRESHOLD_DAYS=7
readonly SUCCESS_MARKER="${HOME}/.config/rclone/gdrive-bisync.last-success"
readonly FILTERS_FILE="${HOME}/.config/rclone/filters.txt"
readonly RCLONE_TEST_FILE='RCLONE_TEST'
mkdir -p "${LOCAL_DIR}" "$(dirname "${SUCCESS_MARKER}")"

# Build command
readonly -a BISYNC_FLAGS=(
	--create-empty-src-dirs
	--compare 'size,modtime'
	--resilient
	--recover
	--max-lock '2m'
	--conflict-resolve 'newer'
	--conflict-loser 'pathname'
	--conflict-suffix 'sync-conflict-{DateOnly}-'
	--suffix-keep-extension
	--drive-skip-gdocs
	--drive-skip-shortcuts
	--drive-skip-dangling-shortcuts
	--drive-acknowledge-abuse
	--disable 'ListR'
	--fix-case
	--check-access
	--filters-file "${FILTERS_FILE}"
)

dry_run='false'
if [[ "${1:-}" == "--dry-run" ]]; then
	dry_run='true'
fi

cmd=(rclone bisync "${REMOTE}" "${LOCAL_DIR}" "${BISYNC_FLAGS[@]}")
if [[ "${dry_run}" == 'true' ]]; then
	cmd+=('--dry-run')
fi

# Preflight
if [[ ! -f "${LOCAL_DIR}/${RCLONE_TEST_FILE}" ]]; then
	echo "Seeding check-access file locally."
	touch "${LOCAL_DIR}/${RCLONE_TEST_FILE}"
fi

if ! rclone lsf "${REMOTE}${RCLONE_TEST_FILE}" &>/dev/null 2>&1; then
	echo "Seeding check-access file on remote."
	rclone touch "${REMOTE}${RCLONE_TEST_FILE}"
fi

needs_resync='false'
if [[ ! -f "${SUCCESS_MARKER}" ]]; then
	echo "First run - no prior successful sync recorded."
	needs_resync='true'
elif fd -q --changed-before "${STALE_THRESHOLD_DAYS}days" -tf \
	-g "$(basename "${SUCCESS_MARKER}")" "$(dirname "${SUCCESS_MARKER}")"; then
	echo "Last success is stale (older than ${STALE_THRESHOLD_DAYS} days) - resyncing."
	needs_resync='true'
fi

if [[ "${needs_resync}" != 'true' ]]; then
	echo "Running resync..."
	cmd+=('--resync' '--resync-mode' 'newer')
fi

if ! "${cmd[@]}"; then
	exit 1
fi

date -Iseconds >"${SUCCESS_MARKER}"
echo "Done."
