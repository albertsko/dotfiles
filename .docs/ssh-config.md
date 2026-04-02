```
Host *
  UseKeychain yes
  AddKeysToAgent yes
  IdentitiesOnly yes
  ForwardAgent no

Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519

Host dev-askonieczny
  HostName dev-askonieczny
  User askonieczny
  ForwardAgent yes
```
