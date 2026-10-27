#!/usr/bin/env bash
set -euo pipefail

dir="$("${HERDR_BIN_PATH:-herdr}" api snapshot | jq -r '
	.result.snapshot
	| .focused_pane_id as $id
	| .panes[]
	| select(.pane_id == $id)
	| .foreground_cwd // .cwd // empty
')"
[[ -d "$dir" ]] || exit 0

root="$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null)" || root="$dir"
zed -a -- "$root"
