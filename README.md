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
- `shared/Brewfile` contains the portable command-line tools shared by macOS and the Lima VM, plus macOS-only tools guarded by `OS.mac?`.
- `work/` is an optional overlay for work-specific configuration.

### Lima development VM

Run `limadev.sh` on macOS to create or enter the `limadev` VM. The VM forwards the host SSH agent and passes a GitHub CLI token to each shell without storing it in the Lima configuration.

The host home directory is mounted read-only. `~/Documents/github.com` is mounted writable so the VM can edit development repositories on the host.

The VM uses Docker rather than Lima-managed containerd and maps `host.docker.internal` to the Lima host. The wrapper creates or updates the `lima-limadev` Docker context without changing the active context:

```sh
docker --context lima-limadev info
```

Run `docker context use lima-limadev` if you want to make it active.

Set `LIMADEV_DOTFILES_REF` to provision the VM from another pushed branch or tag. Use `limadev.sh --recreate` after changing the Lima configuration, provisioning scripts, or requested ref.

The separate `limavm-docker.sh` helper remains available for the smaller Docker-only Lima VM. It creates and selects the `lima-docker` context.
