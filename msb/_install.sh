#!/usr/bin/env bash
set -euo pipefail

readonly BREW_PREFIX="/home/linuxbrew/.linuxbrew"
readonly MARKER="$BREW_PREFIX/.msbdev-ready"

if [[ -f "$MARKER" ]]; then
	"$BREW_PREFIX/bin/brew" --version >/dev/null
	exit 0
fi

NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
"$BREW_PREFIX/bin/brew" analytics off

for shell_file in "$HOME/.bashrc" "$HOME/.profile"; do
	[[ -L "$shell_file" ]] || rm -f -- "$shell_file"
done

touch "$MARKER"
