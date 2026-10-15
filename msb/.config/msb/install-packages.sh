#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
readonly SCRIPT_DIR
readonly REPORT_DIR="/home/linuxbrew/.linuxbrew/var/msbdev"

mapfile -t requested <"$1"
if ((${#requested[@]} == 0)); then
	printf 'No formulas requested.\n' >&2
	exit 0
fi

for formula in "${requested[@]}"; do
	[[ "$formula" != */*/* ]] || brew tap "${formula%/*}"
done

mkdir -p "$REPORT_DIR"
cp -- "$1" "$REPORT_DIR/requested-formulae.txt"
brew info --json=v2 --formula "${requested[@]}" >"$REPORT_DIR/native-formulae.json"
# The internal Homebrew API can omit platform requirements in `brew info`.
curl -fsSL https://formulae.brew.sh/api/formula.json -o "$REPORT_DIR/core.json"
jq --slurpfile core "$REPORT_DIR/core.json" '
  INDEX($core[0][]; .name) as $index |
  .formulae |= map(if .tap == "homebrew/core" then $index[.name] else . end)
' "$REPORT_DIR/native-formulae.json" >"$REPORT_DIR/formulae.json"
rm -- "$REPORT_DIR/core.json" "$REPORT_DIR/native-formulae.json"

arch=arm64
[[ "$(uname -m)" != x86_64 ]] || arch=x86_64
jq -r --arg arch "$arch" --from-file "$SCRIPT_DIR/select-packages.jq" \
	"$REPORT_DIR/formulae.json" >"$REPORT_DIR/packages.tsv"
cat "$REPORT_DIR/packages.tsv" >&2

mapfile -t selected < <(awk -F '\t' '$2 == "selected" && $3 != "source build" { print $1 }' "$REPORT_DIR/packages.tsv")
mapfile -t sources < <(awk -F '\t' '$2 == "selected" && $3 == "source build" { print $1 }' "$REPORT_DIR/packages.tsv")
((${#selected[@]} == 0)) || brew install --formula "${selected[@]}"
((${#sources[@]} == 0)) || brew install --formula --build-from-source "${sources[@]}"
brew missing
