# dotfiles

```sh
curl -fsSL https://raw.githubusercontent.com/albertsko/dotfiles/main/.install.sh | bash -s -- macOS
```

Profiles are top-level Stow packages:

- `_common`: shared packages
- `macOS`: personal macOS packages
- `work`: work-machine packages
- `ubuntu`: Ubuntu packages

The installer clones this repo to `$XDG_DATA_HOME/dotfiles` and stows `_common` plus the selected profile from the repo root into `$HOME`.

Useful commands:

```sh
cfg status
stow --dir "$DOTFILES_HOME" --target "$HOME" --no-folding --restow _common macOS
```

For an existing bare-checkout home, Stow will report conflicts until the old real files are moved aside or explicitly adopted. Use `DOTFILES_STOW_ADOPT=1` only when the target files should replace the package files in this repo.
