#!/bin/zsh

read -rp "Git user.name: " GIT_NAME
read -rp "Git user.email: " GIT_EMAIL

git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"

git config --global init.defaultBranch main # new repos use 'main'
git config --global color.ui auto
git config --global push.default current      # 'git push' works without extra args
git config --global push.autoSetupRemote true # first push sets upstream automatically
git config --global fetch.prune true          # clean up deleted remote branches
git config --global pull.ff only              # avoid accidental merge commits
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

git config --global core.pager delta
git config --global interactive.diffFilter 'delta --color-only'
git config --global delta.navigate true
git config --global merge.conflictStyle zdiff3
