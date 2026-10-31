Personal dotfiles powered by [mise](https://mise.jdx.dev/bootstrap.html). ✨

### Install (macOS)

Run in Bash or Zsh:

```sh
(
  set -e
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
  brew install mise
  mise bootstrap -E macos \
    --from https://github.com/albertsko/dotfiles.git \
    --from-dir ~/.local/state/dotfiles \
    --config-dir mise
  if [ ! -f ~/.config/mise/miserc.local.toml ]; then
    printf 'env = ["macos"]\n' >~/.config/mise/miserc.local.toml
  fi
)
```
