Personal dotfiles managed with GNU Stow.

### Install

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/albertsko/dotfiles/main/install.sh)
```

The installer clones this repository to `~/.local/state/dotfiles`, prompts for `macos`, `ubuntu26`, or `lima`, runs the profile installer, and symlinks the dotfiles into `$HOME`.

Set `DOTFILES_DRY_RUN=1` to preview the installer without making changes.

### Layout

- `apps/` contains repo-local applications used by startup services.
- `shared/` contains configuration used on every machine.
- `macos/` contains the macOS profile.
- `ubuntu26/` is the placeholder for the upcoming Ubuntu 26 profile.
- `lima/` contains the Ubuntu 26 Lima development VM profile and provisioning configuration.
- `shared/Brewfile` contains Homebrew packages shared by macOS and the Lima VM.
- `work/` is an optional overlay for work-specific configuration.

### Lima development VM

Run `limadev.sh` on macOS to create or enter the `limadev` VM. The VM forwards the host SSH agent and passes a GitHub CLI token to each shell without storing it in the Lima configuration.

The host home directory is mounted read-only. `~/Documents/github.com` is mounted writable so the VM can edit development repositories on the host.

Set `LIMADEV_DOTFILES_REF` to provision the VM from another pushed branch. Use `limadev.sh --recreate` after changing the Lima configuration or provisioning scripts.
