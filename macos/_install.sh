#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"

VAULT_GIT_DIR="${VAULT_GIT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/.vault.git}"
readonly VAULT_REPO_URL="git@github.com:albertsko/vault.git"

if [[ ! -d "$VAULT_GIT_DIR" ]]; then
	git clone --bare "$VAULT_REPO_URL" "$VAULT_GIT_DIR"
	git --git-dir="$VAULT_GIT_DIR" read-tree HEAD
fi

bash "$SCRIPT_DIR/.local/bin/brew.sh"
bash "$SCRIPT_DIR/.local/bin/macos.sh"
