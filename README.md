# dotfiles

## Setup SSH
```sh
ssh-keygen -t ed25519 -C "albertskonieczny@gmail.com" -f ~/.ssh/id_ed25519
eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```
