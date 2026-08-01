#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname -- "$(realpath "${BASH_SOURCE[0]}")")"
AGENTS_DIR="$(realpath "$SCRIPT_DIR/../..")"
SKILLS_DIR="$AGENTS_DIR/.agents/skills"

if [[ ! -d "$SKILLS_DIR" ]]; then
	echo "Error: skills directory not found: $SKILLS_DIR" >&2
	exit 1
fi

targets=(
	".claude/skills:../../.agents/skills"
	".codex/skills:../../.agents/skills"
	".gemini/config/skills:../../../.agents/skills"
)

for target_spec in "${targets[@]}"; do
	target_rel="${target_spec%%:*}"
	rel_prefix="${target_spec#*:}"
	dest_dir="$AGENTS_DIR/$target_rel"

	rm -rf "$dest_dir"
	mkdir -p "$dest_dir"

	for skill_path in "$SKILLS_DIR"/*; do
		[[ -d "$skill_path" ]] || continue
		skill_name="${skill_path##*/}"
		ln -s "$rel_prefix/$skill_name" "$dest_dir/$skill_name"
	done
done
