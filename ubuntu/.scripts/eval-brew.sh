# shellcheck shell=bash
# this file must be sourced or included

case ":$PATH:" in
*":/home/linuxbrew/.linuxbrew/bin:"* | *":$HOME/.linuxbrew/bin:"*)
	# shellcheck disable=SC2317
	return 0 2>/dev/null || exit 0
	;;
esac

_orig_PATH="$PATH"

if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
elif [[ -x "$HOME/.linuxbrew/bin/brew" ]]; then
	eval "$("$HOME/.linuxbrew/bin/brew" shellenv bash)"
else
	echo "fail: eval brew"

	# shellcheck disable=SC2317
	return 1 2>/dev/null || exit 1
fi

_orig_first="${_orig_PATH%%:*}"
_brew_prepended="${PATH%%"$_orig_first"*}"
_brew_prepended="${_brew_prepended%:}"

PATH="${_orig_PATH}${_brew_prepended:+:$_brew_prepended}"
export PATH

unset _orig_PATH _orig_first _brew_prepended

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
_merged=$(comm -23 <(echo "$_on_request") <(echo "$_deps"))

mkdir -p "$HOME/.local/bin"
for _formula in $(_merged); do
	for _bin in "${HOMEBREW_PREFIX}/opt/${_formula##*/}/bin"/*; do
		[[ -x "$_bin" ]] && ln -sf "$_bin" "$HOME/.local/bin/"
	done
done

PATH="$HOME/.local/bin:$PATH"
export PATH

unset _deps _on_request _merged _formula _bin
