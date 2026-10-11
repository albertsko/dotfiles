# Go development

A portable agent skill for Go development and review. It combines contextual advice from *100 Go Mistakes and How to Avoid Them* with official Go 1.18-1.27 release changes.

Use this folder as a skill in an agent that supports `SKILL.md`, or ask an agent: "Read go-development/SKILL.md and apply it to this Go task." No global installation is required. Python scripts use the standard library and are run through `uv run`.

The agent reads the complete trigger index in small batches, opens relevant topic details, and records a decision for every rule. This avoids keeping the entire detailed catalog in context. Even a small task retains all rule rows, with concrete reasons for exclusions.

From this folder, create a task ledger:

```sh
uv run python scripts/ledger.py init --catalog catalog.json --output /absolute/task/go-ledger.json
```

Fill its scope fields. Keep each rule's `id` and record `status`, `reason` and `evidence`. For example, an HTTP-specific rule can be `not_applicable` only after inspection establishes that the assessed code and relevant boundaries do not involve HTTP. A passing unit test is not evidence for every rule.

After work and semantic review, verify the ledger:

```sh
uv run python scripts/ledger.py verify --catalog catalog.json --ledger /absolute/task/go-ledger.json
```

Exit 0 means structurally complete. Exit 3 means incomplete or invalid accounting. Exit 1 means an input error. Exit 2 means invalid command syntax. Keep unresolved work visible in the final report.

For package maintainers, `catalog.json` is the rule source of truth. Regenerate references after editing it, then check the portable bundle:

```sh
uv run python scripts/render.py --catalog catalog.json
uv run python scripts/check.py --root .
```

See [verification](references/verification.md), [topics](references/topics.md), [examples](examples/README.md), and [source coverage](references/sources.md). The JSON coverage manifest maps every canonical source to rules or a reasoned reference disposition. Release reference entries preserve API details that do not warrant a separate recurring rule.
