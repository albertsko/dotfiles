#!/usr/bin/env bash

git config --global user.name "Albert Skonieczny"
git config --global user.email "50720306+albertsko@users.noreply.github.com"

git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status

git config --global init.defaultBranch main
git config --global color.ui auto

git config --global push.default current
git config --global push.autoSetupRemote true
git config --global fetch.prune true
git config --global pull.rebase true
git config --global merge.conflictstyle zdiff3
git config --global rerere.enabled true

SSH_PUBKEY="${HOME}/.ssh/id_ed25519.pub"
if [[ -f "$SSH_PUBKEY" ]]; then
	git config --global gpg.format ssh
	git config --global user.signingkey "$SSH_PUBKEY"
	git config --global commit.gpgsign true
fi
