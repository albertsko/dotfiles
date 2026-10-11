# Source coverage and limits

The operational catalog contains 277 rules across 18 topics. G1-G240 retain the 240 canonical book practices, including contextual qualifications. Later rules capture selected release-driven actions. IDs are stable after delivery. Topic Markdown and the trigger index are generated from [catalog.json](../catalog.json).

[coverage.json](../coverage.json) assigns every BP and RV source an explicit disposition and links guidance in both directions. A release group can support a rule while retaining additional API details in its source reference. A reference disposition does not declare the feature irrelevant. It means that the detail is consulted when its API/platform trigger applies instead of creating another recurring checklist rule.

## Book

[data/book.json](../data/book.json) preserves canonical guidance, caveats, original EPUB member/anchor locators, all 662 raw-practice mappings, all 100 mistakes, 231 indexed headings and 36 additional source units. Source-era defects and ambiguities remain visible. Modern operational wording lives in the catalog and cites release evidence when it supersedes old behavior.

Three independent investigations were reconciled. Independent review corrected evidence claims and receiver ambiguity. A later exhaustive comparison reviewed all 662 whole practices and found 13 mapping-only gaps, now corrected in both directions. See the [practice review](../data/book-practice-review.json), [initial resolution](reviews/book-unification-resolution.md) and [follow-up resolution](reviews/book-unification-followup-resolution.md).

The initial resolution records an earlier source hash. The follow-up resolution identifies the sealed final source hash and supersedes its mapping state.

Whole-practice review is distinct from exact sentence-candidate entailment. The original evidence model still has 1,661 automatically selected sentence candidates without full semantic adjudication. Portable data omits that duplicated candidate text and does not treat it as proof. Canonical guidance and whole-practice mappings remain available for audit. The original EPUB SHA-256 and source locators identify the source without requiring a scratch directory.

## Releases

[data/releases.json](../data/releases.json) preserves 549 semantic section groups, 5,170 raw reconciliation entries, 604 sections, 747 investigation-group mappings, 32 book-update rows, source corrections, publication states and official locators. These are semantic groups, not a claim of 549 atomic APIs. Related changes and caveats can share a group.

The required scope is the published major Go 1.18-1.27 notes captured on 2026-10-11. All ten pages were available. The 112 supplemental patch-history records are status evidence, not an exhaustive patch-fix census. The [release review resolution](reviews/release-unification-resolution.md) records module-version, language-gate and TLS corrections. Full scraped pages are not required by this portable package.

## Release references

Read every crossed version relevant to a used API, tool or platform. Older entries retain their historical defaults and experiments, so inspect later entries before applying them.

| Release | Source reference |
| --- | --- |
| Go 1.18 | [Summary and dispositions](releases/go1.18.md) |
| Go 1.19 | [Summary and dispositions](releases/go1.19.md) |
| Go 1.20 | [Summary and dispositions](releases/go1.20.md) |
| Go 1.21 | [Summary and dispositions](releases/go1.21.md) |
| Go 1.22 | [Summary and dispositions](releases/go1.22.md) |
| Go 1.23 | [Summary and dispositions](releases/go1.23.md) |
| Go 1.24 | [Summary and dispositions](releases/go1.24.md) |
| Go 1.25 | [Summary and dispositions](releases/go1.25.md) |
| Go 1.26 | [Summary and dispositions](releases/go1.26.md) |
| Go 1.27 | [Summary and dispositions](releases/go1.27.md) |

## Validation boundary

The bundle checker validates IDs, source accounting, reverse links, original source anchors, local links and generated-file agreement against an independently retained baseline. Structural checks do not prove semantic completeness. Per-task ledgers likewise prove accounting and evidence presence, not truth. Final package reviews and executable checks should be reported with their actual scope and outcome.

The [final package review](reviews/final-resolution.md) records the three review scopes, corrections and validation results.
