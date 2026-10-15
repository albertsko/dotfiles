Personal dotfiles managed with GNU Stow.

### Install

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/albertsko/dotfiles/main/install.sh)
```

The installer clones this repository to `~/.local/state/dotfiles`, prompts for `macos`, `ubuntu26`, `lima`, or `msb`, runs the profile installer, and symlinks the dotfiles into `$HOME`.

Set `DOTFILES_DRY_RUN=1` to preview the installer without making changes.

### Layout

- `agents/skills/` contains the skill library managed by the `skills.sh` launcher.
- `apps/` contains repo-local applications and utilities.
- `shared/` contains configuration used on every machine.
- `macos/` contains the macOS profile.
- `ubuntu26/` is the placeholder for the upcoming Ubuntu 26 profile.
- `lima/` contains the Ubuntu 26 Lima development VM profile and provisioning configuration.
- `msb/` contains the Ubuntu 26 microsandbox development profile and image configuration.
- `shared/Brewfile` contains the portable command-line tools shared by macOS and the Lima VM, plus macOS-only tools guarded by `OS.mac?`.

### Microsandbox

Build the minimal Ubuntu 26.04 image and enter a sandbox:

```sh
bash shared/.local/bin/msb-build.sh
bash shared/.local/bin/msbdev.sh
```

Docker Buildx uses the active Docker engine, including the Docker API provided by Podman machine. The builder must support OCI export, for example the `docker-container` driver. Set `MSB_BUILDER` to select a builder explicitly.

The image includes Ubuntu bootstrap tools and the `msb` Stow profile. It contains no Homebrew installation or Brew packages. The first launch initializes Linux Homebrew in a shared host directory. Subsequent launches reuse it.

Shared data lives under `${XDG_DATA_HOME:-$HOME/.local/share}/msbdev/`:

| Host directory | Guest directory | Contents |
| --- | --- | --- |
| `brew/` | `/home/linuxbrew/.linuxbrew` | Homebrew, installed packages, taps, and package reports |
| `cache/` | `/home/dev/.cache/Homebrew` | Homebrew download cache |
| `config/` | `/home/dev/.config/homebrew` | Homebrew configuration and tap trust |

This is a Linux Homebrew installation. The macOS Homebrew prefix cannot supply Linux binaries. The guest runs as `dev` (UID 1000), and mounts present the shared directories as owned by that user.

No Brew packages are installed automatically. To install a small set into the shared prefix:

```sh
bash shared/.local/bin/msb-brew.sh jq
```

Without formula arguments, `msb-brew.sh` mirrors all Linux-compatible formulas installed on the host. Casks are excluded. Linux Homebrew resolves dependencies and installs current stable versions. The selector checks stable platform requirements, Linux and universal bottles, and architecture-specific upstream downloads. Disabled or incompatible formulas are reported as skipped. Installation failures stop the command.

The selection report is available at `~/.local/share/msbdev/brew/var/msbdev/packages.tsv`. Install or update packages from one sandbox at a time. All sandboxes using this prefix see those changes.

Use a different sandbox name to reuse the same Homebrew installation:

```sh
MSB_NAME=msbdev-other bash shared/.local/bin/msbdev.sh
```

To use a separate installation, set `MSB_DATA_DIR` together with a new `MSB_NAME`. Existing sandboxes keep the mounts they were created with. Changing their data directory requires `--recreate`.

Use `--recreate` to replace a sandbox while preserving its existing shared Homebrew data:

```sh
bash shared/.local/bin/msbdev.sh --recreate
```

The launcher also mounts `~/dev` and existing `.codex`, `.claude`, `.agents`, and `.local/share/albertsko-skills` directories. The default shell is Bash. To enable the shared Fish configuration, install `fish`, `starship`, `zoxide`, and `fzf` with `msb-brew.sh`.

The OCI archive and Buildx metadata are saved to `${XDG_CACHE_HOME:-$HOME/.cache}/msb/`. Override the output directory with `MSB_BUILD_DIR`, the image reference with `MSB_IMAGE`, or the Ubuntu 26.04 base reference with `MSB_BASE_IMAGE` (including a pinned digest).

Run a command in the sandbox:

```sh
bash shared/.local/bin/msbdev.sh -- uname -a
```

This profile does not configure a Docker daemon or SSH agent forwarding inside the guest.

Run package-selection tests with `uv run python msb/tests/test_packages.py`.
