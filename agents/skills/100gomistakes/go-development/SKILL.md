---
name: go-development
description: Develop or review Go code, design Go APIs, test concurrent behavior, diagnose performance, or upgrade Go versions with contextual rules and explicit verification evidence.
---

# Go development

1. Record the assessed repository and task scope, inspected paths, supported Go versions, actual toolchains and target platforms. Inspect module/workspace directives and relevant build constraints. Finish when the ledger scope distinguishes the supported language baseline from the compiler used to check it.
2. Initialize every rule as pending. From this skill directory, run `uv run python scripts/ledger.py init --catalog catalog.json --output /absolute/task/go-ledger.json`. Use a new path for a new task. Reuse a ledger only after reconciling its scope and catalog identity.
3. Read the [topic router](references/topics.md), then the complete [applicability index](references/rule-index.md) in topic-sized batches. Consider every trigger. Load each applicable or uncertain [topic reference](references/topics.md) before deciding. Finish when every rule has an individual applicability decision grounded in inspected scope. An unexamined topic is pending, not excluded.
4. Apply the relevant rules while working. Record status, reason and concrete inspection or execution evidence in every ledger row. Use `pass`, `not_applicable`, `pending`, `blocked` or `fail` as described in [verification](references/verification.md). Read [release references](references/sources.md#release-references) when a used API, platform or compatibility behavior crosses a version boundary. Read source details when a rule's applicability remains uncertain.
5. After the last relevant edit, refresh affected evidence and decisions. Run appropriate formatting, compilation, static checks and behavioral tests. A successful command supports only the properties it checks. Baseline language-mode tests on a newer compiler do not prove execution on an older toolchain.
6. Run `uv run python scripts/ledger.py verify --catalog catalog.json --ledger /absolute/task/go-ledger.json`. Finish only when every applicable rule passes, every exclusion has evidence, and semantic review confirms the decisions. Machine validation checks accounting, not truth. Report incomplete work when rules remain blocked, failed or pending.

Report changed behavior, actual checks and their limits, unresolved rule IDs and the ledger location. The skill covers book guidance modernized against Go 1.18-1.27. Outside that range, verify current primary sources and state any uncovered behavior. Read [source coverage and limits](references/sources.md) when auditing provenance or completeness. Read [README](README.md) for a short usage example and package checks.
