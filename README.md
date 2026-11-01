<div align="center"><h4>Personal dotfiles powered by <a href="https://mise.jdx.dev/bootstrap.html">mise</a>. ✨</h4></div>

---

```sh
# Install macos:
(
  set -e
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
  brew install mise
  mise bootstrap -E macos,desktop \
    --from https://github.com/albertsko/dotfiles.git \
    --from-dir ~/.local/state/dotfiles \
    --config-dir mise
  if [ ! -f ~/.config/mise/miserc.local.toml ]; then
    printf 'env = ["macos", "desktop"]\n' >~/.config/mise/miserc.local.toml
  fi
)

# Install ubuntu:
(
  set -e
  sudo apt-get update
  sudo apt-get install -y build-essential procps curl file git
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  brew install mise
  mise bootstrap -E ubuntu \
    --from https://github.com/albertsko/dotfiles.git \
    --from-dir ~/.local/state/dotfiles \
    --config-dir mise
  if [ ! -f ~/.config/mise/miserc.local.toml ]; then
    printf 'env = ["ubuntu"]\n' >~/.config/mise/miserc.local.toml
  fi
)
```
