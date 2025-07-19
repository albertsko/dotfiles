# dotfiles

## Setup SSH
```sh
ssh-keygen -t ed25519 -C "albertskonieczny@gmail.com" -f ~/.ssh/id_ed25519
eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

`~/.ssh/config` example:
```
Host *
  UseKeychain yes
  AddKeysToAgent yes

Host dev-askonieczny
  HostName dev-askonieczny
  User askonieczny
  ForwardAgent yes

Host *executor*
  User askonieczny
  ForwardAgent yes

Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519
  IdentitiesOnly yes
  ForwardAgent yes
```
