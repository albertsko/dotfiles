Personal dotfiles managed with GNU Stow.

### Install

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/albertsko/dotfiles/main/install.sh)
```

The installer clones this repository to `~/.local/state/dotfiles`, prompts for `macos` or `ubuntu26`, runs the profile installer, and symlinks the dotfiles into `$HOME`.

Set `DOTFILES_DRY_RUN=1` to preview the installer without making changes.

### Layout

- `apps/` contains repo-local applications used by startup services.
- `shared/` contains configuration used on every machine.
- `macos/` contains the macOS profile and Homebrew bundle.
- `ubuntu26/` is the placeholder for the upcoming Ubuntu 26 profile.
- `work/` is an optional overlay for work-specific configuration.
