# dotfiles

```sh
curl -fsSL https://raw.githubusercontent.com/albertsko/dotfiles/main/.install.sh | bash -s -- macOS
```

Profiles are top-level Stow packages:

- `_common`: shared packages
- `macOS`: personal macOS packages
- `work`: work-machine packages
- `ubuntu`: Ubuntu packages

The root installer clones this repo to `$XDG_DATA_HOME/dotfiles`, runs `_common/.install.sh`, then runs the selected profile installer. Each profile installer owns its setup and stows its top-level package from the repo root. Profile `.stow-local-ignore` files are symlinks to the root `.stow-local-ignore`.

Useful commands:

```sh
cfg status
./_common/.install.sh
./macOS/.install.sh
stow --dir "$DOTFILES_HOME" --target "$HOME" --no-folding --restow _common macOS
```

For an existing bare-checkout home, Stow will report conflicts until the old real files are moved aside or explicitly adopted. Use `DOTFILES_STOW_ADOPT=1` only when the target files should replace the package files in this repo.
