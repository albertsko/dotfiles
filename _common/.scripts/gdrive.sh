#!/usr/bin/env bash
set -euo pipefail

readonly REMOTE='gdrive:rclone'
readonly LOCAL_DIR="${HOME}/rclone-gdrive"
readonly STALE_THRESHOLD_DAYS=7
readonly LOG_FILE="${HOME}/.config/rclone/gdrive-bisync.log"
readonly ZOMBIE_REPORT="${HOME}/.config/rclone/gdrive-bisync-zombie-candidates.txt"
readonly FILTERS_FILE="${HOME}/.config/rclone/filters.txt"

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
	--log-file "${LOG_FILE}"
	--log-level 'INFO'
)

mkdir -p "${LOCAL_DIR}" "$(dirname "${LOG_FILE}")"

dry_run='false'
if [[ "${1:-}" == "--dry-run" ]]; then
	dry_run='true'
fi

cmd=(rclone bisync "${REMOTE}" "${LOCAL_DIR}" "${BISYNC_FLAGS[@]}")
if [[ "${dry_run}" == 'true' ]]; then
	cmd+=('--dry-run')
fi

needs_resync='false'
if [[ ! -f "${LOG_FILE}" ]]; then
	echo "First run — no log file found."
	needs_resync='true'
elif fd -q --changed-before "${STALE_THRESHOLD_DAYS}days" -tf \
	-g "$(basename "${LOG_FILE}")" "$(dirname "${LOG_FILE}")"; then
	echo "Log is stale (older than ${STALE_THRESHOLD_DAYS} days) — resyncing."
	needs_resync='true'
fi

if [[ "${needs_resync}" == 'true' ]]; then
	if [[ -n "$(ls -A "${LOCAL_DIR}" 2>/dev/null)" ]]; then
		echo "Scanning for zombie candidates (local-only files)..."
		tmp_zombie="$(mktemp)"
		rclone check "${LOCAL_DIR}" "${REMOTE}" \
			--one-way --size-only --drive-skip-gdocs --disable 'ListR' \
			--missing-on-src "${tmp_zombie}" 2>/dev/null || true
		if [[ -s "${tmp_zombie}" ]]; then
			count="$(wc -l <"${tmp_zombie}" | tr -d ' ')"
			echo "Found ${count} zombie candidate(s). Report: ${ZOMBIE_REPORT}"
			mv "${tmp_zombie}" "${ZOMBIE_REPORT}"
		else
			echo "No zombie candidates found."
			rm -f "${tmp_zombie}" "${ZOMBIE_REPORT}"
		fi
	fi

	echo "Running resync..."
	cmd+=('--resync' '--resync-mode' 'newer')
else
	echo "Log is fresh — running normal bisync."
fi

if ! "${cmd[@]}"; then
	echo "ERROR: Bisync failed. Check log: ${LOG_FILE}" >&2
	exit 1
fi

echo "Done."
if [[ -f "${ZOMBIE_REPORT}" ]]; then
	echo "Review zombie candidates: ${ZOMBIE_REPORT}"
fi
