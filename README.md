Personal dotfiles managed with GNU Stow.

### Install

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/albertsko/dotfiles/main/install.sh)
```

The installer clones this repository to `~/.local/state/dotfiles`, prompts for `macos`, `ubuntu26`, or `lima`, runs the profile installer, and symlinks the dotfiles into `$HOME`.

Set `DOTFILES_DRY_RUN=1` to preview the installer without making changes.

### Layout

- `agents/skills/` contains the skill library managed by the `skills.sh` launcher.
- `apps/` contains repo-local applications and utilities.
- `shared/` contains configuration used on every machine.
- `macos/` contains the macOS profile.
- `ubuntu26/` is the placeholder for the upcoming Ubuntu 26 profile.
- `lima/` contains the Ubuntu 26 Lima development VM profile and provisioning configuration.
- `shared/Brewfile` contains the portable command-line tools shared by macOS and the Lima VM, plus macOS-only tools guarded by `OS.mac?`.
- `work/` is an optional overlay for work-specific configuration.

### Skills

Run `skills.sh` to choose the skills linked into `~/.agents/skills`,
`~/.claude/skills`, and `~/.codex/skills`.

The initial selection comes from `~/.agents/skills`. Links use a source prefix,
such as `local-output` or `superpowers-test-driven-development`.
Register remote repositories in `apps/skills/main.go`. Skills are read from each
repository's `skills/` directory.

Remote skills refresh on every run. If the refresh fails, the app stops before
opening the selector. Accepting the selection rebuilds managed links in all
three directories. Use `skills.sh --cd` to open an interactive shell in this
repository.
