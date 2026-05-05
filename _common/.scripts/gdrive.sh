#!/usr/bin/env bash
set -euo pipefail

readonly REMOTE='gdrive:'
readonly STALE_THRESHOLD_DAYS=7
readonly FILTERS_FILE="${HOME}/.config/rclone/filters.txt"

readonly LOCAL_DIR="${HOME}/rclone-gdrive"
readonly RCLONE_TEST_FILE='RCLONE_TEST'
readonly SUCCESS_MARKER="${LOCAL_DIR}/${RCLONE_TEST_FILE}"
mkdir -p "${LOCAL_DIR}"

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

cmd=(rclone bisync "${REMOTE}" "${LOCAL_DIR}" "${BISYNC_FLAGS[@]}" "$@")

needs_resync='false'
if fd -q --older "${STALE_THRESHOLD_DAYS}d" -t f -g "$(basename "${SUCCESS_MARKER}")" "$(dirname "${SUCCESS_MARKER}")" --exact-depth 1; then
	needs_resync='true'
fi

if [[ ! -f "${SUCCESS_MARKER}" ]]; then
	needs_resync='true'
	touch "${SUCCESS_MARKER}"
	rclone touch "${REMOTE}${RCLONE_TEST_FILE}"
fi

if [[ "${needs_resync}" == 'true' ]]; then
	echo "Resyncing..."
	cmd+=('--resync' '--resync-mode' 'newer')
fi

if ! "${cmd[@]}"; then
	rm -f "${SUCCESS_MARKER}"
	exit 1
fi

touch "${SUCCESS_MARKER}"
rclone touch "${REMOTE}${RCLONE_TEST_FILE}"

echo "Success."
