# dotfiles

## Install

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/albertsko/dotfiles/main/install.sh)
```

Clones the repo to `~/.local/share/dotfiles`, prompts for a profile (`macos`, `ubuntu`, `work`), sets up SSH + git, runs the profile installer, then symlinks dotfiles into `$HOME` via stow.

Set `DOTFILES_DRY_RUN=1` to preview without making changes.

## Stow

Dotfiles are organized into stow packages:

- `_common/` — applied to all profiles
- `macos/`, `ubuntu/`, `work/` — profile-specific overrides

To re-stow manually after adding files:

```sh
stow.sh <profile>
```
