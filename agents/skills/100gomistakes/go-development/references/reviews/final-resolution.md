# Final package review

Three separate reviewers examined the completed package. The unbiased reviewer read all 277 rule bodies. The informed reviewer compared all 240 canonical book practices and all 549 release groups with their final guidance and dispositions. The general reviewer exercised the workflow, a small Go task and adversarial ledger inputs. Their scopes overlap but do not amount to execution of every rule on every supported platform or historical toolchain.

## Corrections

- F1: Program GODEBUG defaults now distinguish the active workspace or work module from per-file language permissions. G95, G147, G227, RV396 and RM5 describe the relevant selector and overrides. RV396 exposes the [official compatibility documentation](https://go.dev/doc/godebug#default).
- F2: G70 distinguishes ordered slice iteration, unspecified map order and goroutine scheduling. Concurrent loop rules state their scheduling limit explicitly.
- F3: G8, G56, G116 and G117 retain each distinct qualification once.
- F4: G268 now routes Go 1.26 leak investigations to the experimental profile and distinguishes supported Go 1.27 behavior.
- F5: G68 states the specified non-evaluation guarantee and links the [range specification](https://go.dev/ref/spec#For_range).
- F6: G254 now covers production reproducible randomness as well as tests. Its topic router and full index expose simulations, sampling and replay, including work on a fixed version without an upgrade.

IDs and source mappings remain stable. Topic references and the applicability index were regenerated after corrections.

## Validation

The bundle checker passes with 277 rules, 18 topics, 240 canonical book practices, 549 release groups, 662 raw book practices and 5,170 raw release records/units. It checks bidirectional mappings, expected IDs, anchors, local links and generated references. These counts describe accounting, not a number of independently tested language behaviors.

All 11 Python verification test groups pass. The general review rejected 15 invalid ledger cases, including malformed evidence, unknown/missing/duplicate rules, stale catalogs and unresolved decisions. A small Go clone task passed tests and vet. An honest partial ledger remained incomplete. A fabricated blanket-exclusion ledger passed only structural validation, as documented. Semantic review must reject unsupported exclusions.

Supplied Go examples pass on Go 1.27.2 darwin/arm64, with race checking in the parent module. Separate Go 1.21 and Go 1.22 module language modes pass on that same toolchain. This does not establish behavior on historical runtimes, Linux containers or every supported platform.

The informed comparison found no canonical book practice wholly absent. Whole-practice comparison does not resolve every automatic sentence candidate. The [source coverage limits](../sources.md) remain part of the evidence boundary.
