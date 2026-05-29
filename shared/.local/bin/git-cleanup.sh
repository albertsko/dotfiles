#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
	echo "Usage: $0 <path_to_directory>"
	exit 1
fi

TARGET_DIR="$1"

if [ ! -d "$TARGET_DIR" ]; then
	echo "Error: Directory '$TARGET_DIR' does not exist."
	exit 1
fi

for dir in "$TARGET_DIR"/*/; do
	dir="${dir%/}"

	if [ ! -d "$dir/.git" ]; then
		continue
	fi

	cd "$dir" || continue

	git stash || true

	DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
	if [ -z "$DEFAULT_BRANCH" ]; then
		if git show-ref --verify --quiet refs/heads/main; then
			DEFAULT_BRANCH="main"
		elif git show-ref --verify --quiet refs/heads/master; then
			DEFAULT_BRANCH="master"
		else
			DEFAULT_BRANCH="main"
		fi
	fi

	git checkout -f "$DEFAULT_BRANCH"
	git reset --hard
	git clean -fd
	git submodule foreach --recursive 'git reset --hard && git clean -fd'
	cd - >/dev/null || exit
done

echo "Cleanup complete for: $(realpath "$TARGET_DIR")"
