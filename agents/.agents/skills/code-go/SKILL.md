---
name: code-go
description: Guide for writing Go code following Google's Go style guide. Use when creating, reviewing, or refactoring any Go code (.go file, package, module, test), or when deciding on naming, error handling, interfaces, or test structure in Go.
disable-model-invocation: true
---

# Code Go

## General

Follow Google's Go style. Five principles, in priority order: clarity, simplicity, concision, maintainability, consistency. Prefer core language constructs over the standard library, and the standard library over third-party dependencies. When two options are otherwise equal, pick the idiomatic one.

Before finishing, verify:

- `gofmt -l .` (or `goimports -l .`) reports no files
- `go vet ./...` is clean
- `go test ./...` passes

## References

- Before writing, reviewing, or refactoring any Go code, read `references/google-styleguide-go.md`: the distilled Google rules for formatting, naming, packages, imports, documentation, errors, language constructs, API design, and tests.
