#!/usr/bin/env bash
set -euo pipefail

config_output="$(mise config ls --json | jq -r 'reverse[].path')"
readarray -t config_paths <<<"$config_output"

for config_path in "${config_paths[@]}"; do
	filename="${config_path##*/}"
	[[ "$filename" == "config.toml" || "$filename" == config.*.toml ]] || continue
	brewfile="${config_path%/*}/Brewfile${filename#config}"
	brewfile="${brewfile%.toml}"
	[[ -f "$brewfile" ]] || continue
	brew bundle install --file="$brewfile"
done

brew cleanup
