#!/usr/bin/env bash
set -euo pipefail

readonly REPO_URL="https://github.com/albertsko/dotfiles.git"
readonly DOTFILES_REF="${PARAM_DOTFILES_REF:-main}"
readonly STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
# Must match dotfiles.root in mise/config.toml.
readonly DOTFILES_HOME="$HOME/.local/state/dotfiles"
readonly BREW_BIN="/home/linuxbrew/.linuxbrew/bin/brew"
readonly MARKER="$STATE_HOME/limadev-user.done"

[[ -f "$MARKER" ]] && exit 0

[[ -x "$BREW_BIN" ]] || NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$("$BREW_BIN" shellenv)"
brew install mise

# A retry reuses the checkout, whose origin may already use SSH.
from_args=(--from "$REPO_URL?ref=$DOTFILES_REF" --from-dir "$DOTFILES_HOME" --config-dir mise)
[[ ! -d "$DOTFILES_HOME/.git" ]] || from_args=()

# A fresh VM has default shell files where the lima group links its own.
mise bootstrap --yes --force-dotfiles -E lima "${from_args[@]}"
printf 'env = ["lima"]\n' >"$HOME/.config/mise/miserc.local.toml"

touch "$MARKER"
