# Repository Guidance

- Treat `shared/`, `ssh/`, and `macos/` as mise dotfile groups rooted at `$HOME`. The repository root is the global mise config directory: `config*.toml`, `miserc.toml`, and `tasks/` declare them.
- Validate shell changes with `bash -n` and `hk check`, which runs `shellcheck` and `shfmt`.
- Validate mise changes by comparing each `config*.toml` with the output of `mise fmt --stdin`, then run `mise bootstrap --dry-run`.
