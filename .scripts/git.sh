#!/usr/bin/env bash

git config --global user.name "Albert Skonieczny"
git config --global user.email "50720306+albertsko@users.noreply.github.com"

git config --global init.defaultBranch main
git config --global color.ui auto
git config --global push.default current
git config --global push.autoSetupRemote true
git config --global fetch.prune true
git config --global pull.ff only
git config --global credential.helper osxkeychain

SSH_PUBKEY="${HOME}/.ssh/id_ed25519.pub"
if [[ -f "$SSH_PUBKEY" ]]; then
	git config --global gpg.format ssh
	git config --global user.signingkey "$SSH_PUBKEY"
	git config --global commit.gpgsign true
	echo "Enabled SSH commit signing with $SSH_PUBKEY"
else
	echo "SSH public key not found at $SSH_PUBKEY"
fi

# --- delta config ---
# git config --global core.pager delta
# git config --global interactive.diffFilter 'delta --color-only'
# git config --global merge.conflictStyle zdiff3
# git config --global delta.navigate false
# git config --global delta.line-numbers true
# git config --global delta.pager "less --mouse -R"
