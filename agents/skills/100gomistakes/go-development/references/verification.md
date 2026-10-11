# Verification ledger

The ledger records what was assessed and why each rule passes or does not apply. Initialize it from the complete catalog. Each new row starts pending. The catalog fingerprint detects changes that require reconciliation.

## Scope

Record the repository, task, supported Go versions, actual toolchains, platforms and inspected paths. Scope includes the affected behavior and relevant callers, ownership boundaries and configuration, not only edited lines. Explain limits when external systems or supported platforms cannot be tested. Do not silently narrow scope to obtain a complete result.

## Decisions

| Status | Required meaning |
| --- | --- |
| `pass` | The trigger applies and evidence establishes the required behavior within the recorded scope. |
| `not_applicable` | Inspected scope makes the trigger false. Record that scope and the specific reason. |
| `pending` | Applicability, implementation or verification remains unexamined. |
| `blocked` | The rule applies but missing access, infrastructure or information prevents completion. |
| `fail` | Evidence shows an unresolved violation. |

Every decision needs a reason. Both pass and not_applicable need nonempty evidence arrays. Cite file paths and relevant symbols or lines for inspections. For commands, record the actual command, toolchain, outcome and what that outcome establishes. Keep failed or skipped steps visible where they affect confidence.

For example, a slice-copy rule can pass with an inspection showing destination length equals source length and a boundary test that confirms independent element storage. The same test does not establish deep copying of pointer-valued elements. An exclusion can cite an inspected call graph with no slice copy in the affected path. "All tests pass" or "not relevant" alone supports neither conclusion.

## Screening and refresh

Read the full applicability index in topic-sized batches. Details need loading only for applicable or uncertain triggers. Each row receives its own decision, even when several rows share one source of evidence. A keyword scan can locate candidates but cannot prove absence of a semantic condition. Unsupported topic-wide exclusions remain incomplete work even if their text satisfies the JSON schema.

After edits, recheck any assumptions and evidence affected by the change, including callers, tests and version settings. Preserve unrelated evidence only when its inputs remain valid. If the catalog changes, initialize a fresh ledger and transfer only reviewed decisions instead of merely changing the fingerprint.

## Completion

The verifier rejects missing, duplicate or unknown rule IDs, stale catalog identity, invalid states, empty reasons, missing evidence, and unresolved rows. Its evidence-presence checks cannot determine whether a claim is true. Review actual applicability and supporting evidence before calling a run complete.

Compiler success proves accepted source for that build configuration. Race detection covers exercised paths. Coverage records execution, not useful assertions. A newer compiler with an older module directive checks some language/API gates but does not reproduce an older runtime. Name actual checks and residual limits in the report.

An incomplete report is a valid outcome when work cannot finish. Retain blocked/failed/pending rows, explain their impact and identify the ledger path. Do not label an incomplete ledger as completed verification.
