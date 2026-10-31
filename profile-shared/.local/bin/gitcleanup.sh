#!/usr/bin/env bash
set -euo pipefail

# Usage: gitcleanup.sh [--pull] [path]
# Inside a repo: clean it. Otherwise: clean each repo directly inside path.

pull=0
[[ "${1-}" == "--pull" ]] && pull=1 && shift
[[ "${1-}" == -* ]] && echo "Usage: gitcleanup.sh [--pull] [path]" >&2 && exit 1
TARGET_DIR="${1:-.}"

clean_repo() {
	local repo="$1" branch

	branch="$(git -C "$repo" symbolic-ref --quiet --short refs/remotes/origin/HEAD || echo origin/main)"
	branch="${branch#origin/}"
	echo "Cleaning $repo ($branch)"

	# Stash untracked files too, so local work stays recoverable.
	git -C "$repo" stash push --include-untracked --quiet
	git -C "$repo" checkout --force "$branch"
	git -C "$repo" reset --hard
	git -C "$repo" clean -fd
	git -C "$repo" submodule foreach --recursive 'git reset --hard && git clean -fd'
	[[ "$pull" == "0" ]] || git -C "$repo" pull --ff-only
}

if top="$(git -C "$TARGET_DIR" rev-parse --show-toplevel 2>/dev/null)"; then
	clean_repo "$top"
	exit 0
fi

for dir in "$TARGET_DIR"/*/; do
	# .git is a file in worktrees and submodules.
	[[ -e "${dir}.git" ]] || continue
	clean_repo "${dir%/}"
done
