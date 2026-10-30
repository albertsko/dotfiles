My macOS setup, from a fresh machine to ready-to-code in one command. Powered by [mise](https://mise.jdx.dev/bootstrap.html). ✨

### Install

Sign in to the App Store, then run:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew install mise

mise bootstrap -E macos \
  --from https://github.com/albertsko/dotfiles.git \
  --from-dir ~/.local/state/dotfiles \
  --config-dir .
printf 'env = ["macos"]\n' >~/.config/mise/miserc.local.toml
```

Add the new SSH public key to GitHub for auth and signing, then run `mise bootstrap` once more. That's it! 🎉

### Stay fresh

```sh
git -C ~/.local/state/dotfiles pull
mise run upgrade
```

This pulls the latest Homebrew metadata, upgrades every package, and applies the config. Check for drift anytime with `mise bootstrap status`.

### What's inside

- `config*.toml`, `tasks/`: packages, macOS settings, and setup tasks
- `shared/`, `ssh/`, `macos/`: dotfiles linked into `$HOME`
- `apps/`: small Go helpers
- `skills/`: agent skills, picked with `skills.sh`
