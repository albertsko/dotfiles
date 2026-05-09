# shellcheck shell=bash
# this file must be sourced or included

# This script setups brew for linux in a way
# we have in front of the $PATH binaries installed on request
#
# Steps:
# 1. eval brew
# 2. remove `/home/linuxbrew/.linuxbrew/*` from $PATH
# 3. add `/home/linuxbrew/.linuxbrew/*` to the end of $PATH
# 4. create "$HOME/.local/bin"
# 5. find out which brew packages are installed on request
#    (faster `brew leaves --installed-on-request` alternative)
# 6. link brew packages installed on request to "$HOME/.local/bin"
# 7. export PATH="$HOME/.local/bin:$PATH"

# --- Eval brew ---
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

# --- Link brew installed binaries ---
# `brew leaves --installed-on-request` means explicit formulae not required by another formula
# benchmark with `hyperfine -w 3 -i -S bash 'source ~/.profile'`
mkdir -p "$HOME/.local/bin"

_receipts=("$HOMEBREW_CELLAR"/*/*/INSTALL_RECEIPT.json)

# formulae required by at least one installed formula
_runtime_dependencies=$(jq -r '.runtime_dependencies[]?.full_name' "${_receipts[@]}" | sort -u)

# receipt files for formulae installed explicitly by the user
_requested_receipts=$(jq -r 'select(.installed_on_request) | input_filename' "${_receipts[@]}")

while IFS= read -r _receipt; do
	[[ -z "$_receipt" ]] && continue

	# remove the cellar prefix, then keep the formula directory name
	_formula_and_version=${_receipt#"$HOMEBREW_CELLAR"/}
	_formula=${_formula_and_version%%/*}

	_tap=$(jq -r '.source.tap // ""' "$_receipt")

	# core formula full names look like fzf
	# tapped formula full names look like owner/tap/formula
	if [[ -z "$_tap" || "$_tap" == "homebrew/core" ]]; then
		_full_name=$_formula
	else
		_full_name=$_tap/$_formula
	fi

	# exact whole line match so fzf does not match fzf-tab
	if grep -Fxq "$_full_name" <<<"$_runtime_dependencies"; then
		continue
	fi

	_bin_dir="${HOMEBREW_PREFIX}/opt/${_formula}/bin"
	for _bin in "$_bin_dir"/*; do
		[[ -x "$_bin" ]] && ln -sf "$_bin" "$HOME/.local/bin/"
	done
done <<<"$_requested_receipts"

PATH="$HOME/.local/bin:$PATH"
export PATH

unset _receipts _runtime_dependencies _requested_receipts _receipt _formula_and_version _tap _formula _full_name _bin_dir _bin
