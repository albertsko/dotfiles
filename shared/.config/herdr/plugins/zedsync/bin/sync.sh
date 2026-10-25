#!/usr/bin/env bash
set -euo pipefail

readonly STATE_DIR="${HERDR_PLUGIN_STATE_DIR:?}"

zed_instance() {
	osascript -l JavaScript <<'JXA'
ObjC.import("AppKit");
const apps = $.NSRunningApplication.runningApplicationsWithBundleIdentifier("dev.zed.Zed");
const app = Number(apps.count) === 1 ? apps.objectAtIndex(0) : null;
app ? [app.processIdentifier, app.launchDate.timeIntervalSince1970].join("-") : "";
JXA
}

request="$(mktemp "$STATE_DIR/request.XXXXXX")"
trap 'rm -f -- "$request"' EXIT
printf '%s\n' "$$" >"$request"
mv -f -- "$request" "$STATE_DIR/latest"

platform="$(uname -s)"
exec 9>"$STATE_DIR/sync.lock"
case "$platform" in
Darwin) lockf 9 ;;
Linux) flock 9 ;;
esac

[[ "$(<"$STATE_DIR/latest")" == "$$" ]] || exit 0
sleep 0.1
[[ "$(<"$STATE_DIR/latest")" == "$$" ]] || exit 0

dir="$("${HERDR_BIN_PATH:-herdr}" api snapshot | jq -r '
	.result.snapshot
	| .focused_pane_id as $id
	| .panes[]
	| select(.pane_id == $id)
	| .foreground_cwd // .cwd // empty
')"
[[ -d "$dir" ]] || exit 0

root="$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null)" || root="$dir"

if [[ "$platform" != Darwin ]]; then
	zed -a -- "$root" 9>&-
	exit 0
fi

instance="$(zed_instance)"
key="$(printf '%s' "$root" | git hash-object --stdin)"
marker="$STATE_DIR/project-$key"

if [[ -n "$instance" && -f "$marker" && "$(<"$marker")" == "$instance" && "${HERDR_PLUGIN_ACTION_ID:-}" != sync ]]; then
	open -g -b dev.zed.Zed "$root" 9>&-
	exit 0
fi

zed -a -- "$root" 9>&-
instance="$(zed_instance)"
[[ -n "$instance" ]] || exit 0
printf '%s\n' "$instance" >"$marker"
