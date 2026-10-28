#!/usr/bin/env bash
set -euo pipefail

# Usage: gitdiff.sh [git diff options] [-- paths]
# Like `git diff main...HEAD`, but `git merge-base HEAD A B ...` returns the newest merge-base among all main/master refs.
# This keeps a stale or diverged local main from adding unrelated changes.

# shellcheck disable=SC2046 # Split refs into separate arguments.
exec git diff "$(git merge-base HEAD $(git for-each-ref --format='%(refname:short)' --exclude="refs/heads/$(git branch --show-current)" refs/heads/main refs/heads/master 'refs/remotes/*/main' 'refs/remotes/*/master'))" HEAD "$@"
