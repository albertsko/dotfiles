# Repository Guidance

- Treat `profile-*` directories as mise dotfile groups rooted at `$HOME`. `~/.config/mise` links to this repository's `mise/` directory.
- Keep machine-specific environment selection in ignored `mise/miserc.local.toml`. Persist the `private` environment before deploying private profiles because upgrades prune deselected groups.
- Validate shell changes with `bash -n` and `hk check --all --check`.
- Validate mise changes by comparing each `mise/config*.toml` with `mise fmt --stdin`, then run `mise bootstrap --dry-run`.
- Git-manifest profiles use indexed paths. Stage profile renames before checking or applying their deployment.
