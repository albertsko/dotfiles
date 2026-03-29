```
Host *
  UseKeychain yes
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_ed25519
  IdentitiesOnly yes
  ForwardAgent no

Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519
  IdentitiesOnly yes
  ForwardAgent no

Host dev-askonieczny
  HostName dev-askonieczny
  User askonieczny
  ForwardAgent yes
```
