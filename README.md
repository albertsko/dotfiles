# dotfiles

## Enable Touch ID for `sudo`

```sh
sudo nano /etc/pam.d/sudo

# add the line below as the first line
auth       sufficient     pam_tid.so
```

## Setup SSH

```sh
ssh-keygen -t ed25519 -C "albertskonieczny@gmail.com" -f ~/.ssh/id_ed25519
eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

`~/.ssh/config` example:

```sh
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
