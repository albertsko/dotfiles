#!/usr/bin/env bash
set -euo pipefail

readonly REMOTE='gdrive:'
readonly FILTERS_FILE="${HOME}/.config/rclone/filters.txt"

readonly LOCAL_DIR="${HOME}/rclone-gdrive"
mkdir -p "$LOCAL_DIR"

readonly RCLONE_TEST_FILE='RCLONE_TEST'
readonly RCLONE_TEST_FILE_PATH="${LOCAL_DIR}/${RCLONE_TEST_FILE}"

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

if ! test -f "${RCLONE_TEST_FILE_PATH}"; then
	touch "${RCLONE_TEST_FILE_PATH}"
fi
if ! rclone lsf "${REMOTE}${RCLONE_TEST_FILE}" >/dev/null 2>&1; then
	rclone touch "${REMOTE}${RCLONE_TEST_FILE}"
fi

has_force=0
tmp_stderr=$(mktemp)
"${cmd[@]}" 2>"${tmp_stderr}" || true

stderr_output=$(<"${tmp_stderr}")
rm -f "${tmp_stderr}"

if [[ "${stderr_output}" == *"--force"* ]]; then
	"${cmd[@]}" --dry-run || true
	has_force=1
fi

if ! [[ "${has_force}" -eq 1 ]]; then
	test -n "${stderr_output}" && echo "${stderr_output}" >&2
	echo "yay!"
	exit 0
fi

BOLD=$'\033[1m'
RESET=$'\033[0m'
gum_header="
Bisync requires manual resolution. Select an option:

${BOLD}1)${RESET} --force
${BOLD}2)${RESET} --resync-mode newer
${BOLD}3)${RESET} --resync-mode older
${BOLD}4)${RESET} --resync-mode path1
${BOLD}5)${RESET} --resync-mode path2
"

choice=$(gum input --header "${gum_header}" --placeholder "1-5" --char-limit 1 --header.foreground="212")
case "${choice}" in
1) "${cmd[@]}" --force ;;
2) "${cmd[@]}" --resync --resync-mode newer ;;
3) "${cmd[@]}" --resync --resync-mode older ;;
4) "${cmd[@]}" --resync --resync-mode path1 ;;
5) "${cmd[@]}" --resync --resync-mode path2 ;;
*)
	echo "${BOLD}Invalid key clicked. Aborting.${RESET}" >&2
	exit 1
	;;
esac

echo "yay!"
