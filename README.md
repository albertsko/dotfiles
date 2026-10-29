# Dotfiles

Apple Silicon macOS setup and dotfiles managed with [mise](https://mise.jdx.dev/bootstrap.html).

## Install

Sign in to the App Store. Then install [Homebrew](https://brew.sh) and mise and bootstrap the machine:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew install mise

mise bootstrap -E macos \
  --from https://github.com/albertsko/dotfiles.git \
  --from-dir ~/.local/state/dotfiles \
  --config-dir mise
printf 'env = ["macos"]\n' >~/.config/mise/miserc.local.toml
```

Add the generated SSH public key to GitHub as an authentication and signing key. Sign in to the App Store, then run `mise bootstrap` again. Use `--dry-run` to preview changes.

## Update

```sh
git -C ~/.local/state/dotfiles pull
mise bootstrap --prune-dotfiles
```

Upgrade packages and tools, then apply the configuration:

```sh
mise run upgrade
```

`mise bootstrap status` compares the machine with the configuration. The `mise-tool-update` service updates mise tools daily.

## Layout

- `mise/` contains the global and macOS configuration plus imperative setup tasks.
- `shared/`, `ssh/`, and `macos/` contain files that mise links into `$HOME`.
- `apps/` contains repo-local applications and utilities.
- `agents/skills/` contains the skill library managed by the `skills.sh` launcher.
- `hk.pkl` configures the Git hooks that block commits containing secrets.
