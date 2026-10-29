# Repository Guidance

- Treat `shared/`, `ssh/`, `macos/`, `ubuntu26/`, and `lima/` as mise dotfile groups rooted at `$HOME`. `mise/` is the global mise config that declares them.
- Validate shell changes with `bash -n`, `shellcheck`, and `shfmt -d`.
- Validate mise changes by comparing each `mise/config*.toml` with the output of `mise fmt --stdin`, then run `mise bootstrap --dry-run`.
