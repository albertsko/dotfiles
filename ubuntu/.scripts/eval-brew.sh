# shellcheck shell=bash
# this file must be sourced or included

if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
else
	echo "fail: eval brew"

	# shellcheck disable=SC2317
	return 1 2>/dev/null || exit 1
fi

_PATH=$(echo "$PATH" | tr ':' '\n' |
	grep -vFx "/home/linuxbrew/.linuxbrew/bin" |
	grep -vFx "/home/linuxbrew/.linuxbrew/sbin" |
	tr '\n' ':')
_PATH="${_PATH%:}"

PATH="${_PATH}:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin"
unset _PATH

if ! command -v jq &>/dev/null; then
	echo "fail: jq not found"

	# shellcheck disable=SC2317
	return 1 2>/dev/null || exit 1
fi

_deps=$(jq -rn '[inputs | .runtime_dependencies[]?.full_name] | unique[]' \
	"$HOMEBREW_CELLAR"/*/*/INSTALL_RECEIPT.json | sort)
_on_request=$(jq -rn '
	inputs | select(.installed_on_request) |
	if .source.tap == "" or .source.tap == "homebrew/core"
	then input_filename | split("/")[-3]
	else "\(.source.tap)/\(input_filename | split("/")[-3])"
	end
' "$HOMEBREW_CELLAR"/*/*/INSTALL_RECEIPT.json | sort -u)

# this _merged is assumed to have exactly the same output as `brew leaves --installed-on-request`
# benchmark with `hyperfine -w 3 -i -S bash 'source ~/.profile'`
_merged=$(comm -23 <(echo "$_on_request") <(echo "$_deps"))

mkdir -p "$HOME/.local/bin"
while IFS= read -r _formula; do
	[[ -z "$_formula" ]] && continue
	for _bin in "${HOMEBREW_PREFIX}/opt/${_formula##*/}/bin"/*; do
		[[ -x "$_bin" ]] && ln -sf "$_bin" "$HOME/.local/bin/"
	done
done <<<"$_merged"

PATH="$HOME/.local/bin:$PATH"
export PATH

unset _deps _on_request _merged _formula _bin
