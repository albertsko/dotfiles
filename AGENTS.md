# Repository Guidance

- Treat `profile-*` directories as mise dotfile groups rooted at `$HOME`. `~/.config/mise` links to this repository's `mise/` directory.
- Keep machine-specific environment selection in ignored `mise/miserc.local.toml`. The `private` environment clones `dotfiles-private`. The `fandom` environment deploys its `profile-fandom` (work machine) and needs `private`. Persist both before deploying because upgrades prune deselected groups.
- Validate shell changes with `bash -n` and `hk check --all --check`.
- Validate mise changes by comparing each `mise/config*.toml` with `mise fmt --stdin`, then run `mise bootstrap --dry-run`.
- Declare Homebrew packages in `mise/Brewfile*`, not as `brew:` entries. Validate Brewfile changes with `HOMEBREW_NO_AUTO_UPDATE=1 brew bundle check --file=<Brewfile>`.
- Git-manifest profiles use indexed paths. Stage profile renames before checking or applying their deployment.
