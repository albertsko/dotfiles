# Release-unification review resolution

All three findings in the independent release-unification review are addressed. Corrections are applied by the artifact builder from `unified-releases/review-corrections.json`, so rebuilding preserves them. Canonical IDs and raw provenance remain unchanged.

- **F1, resolved:** RV396 and RM5 now state that the new GOMAXPROCS defaults apply from effective language version Go 1.25. For Go 1.24 and earlier, `containermaxprocs=0` and `updatemaxprocs=0` are defaults. Both retain Linux-only quota awareness, updates on all platforms, and explicit-override caveats. Both cite the official [runtime.GOMAXPROCS documentation](https://pkg.go.dev/runtime#GOMAXPROCS), checked on 2026-10-11. Exact quota arithmetic was not added.
- **F2, resolved:** RV5 now identifies a compiler diagnostic correction with no documented older-module escape. RV65 identifies a specification clarification with no program change. All 14 former language-template entries now have specific applicability text. The [Go 1.18 bug-fix notes](https://go.dev/doc/go1.18#bug_fixes) were rechecked, and the other entries were checked against their captured release evidence.
- **F3, resolved:** RV201 now restricts the missing-client-certificate alert to TLS 1.3 with `RequireAnyClientCert` or `RequireAndVerifyClientCert`. Its expiry alert explicitly covers expired and not-yet-valid certificates. The [Go 1.21 TLS notes](https://go.dev/doc/go1.21#cryptotlspkgcryptotls) were rechecked.

RV4 also has a clearer display section, "Experimental maps and initial generic implementation restrictions". Its original heading remains in `source_section`, its official locator is unchanged, and no restriction is represented as specific to maps.

## Applicability audit

| Canonical item | Gate or context retained |
|---|---|
| RV1 | Go 1.18 syntax, initial compiler caution, separate experimental-module stability |
| RV2 | Experimental constraints module and generics support |
| RV3 | Experimental slices module, distinct from the later standard package |
| RV4 | Experimental maps plus historical initial compiler/language restrictions |
| RV5 | Go 1.18 compiler diagnostics, not new syntax permission |
| RV65 | Specification clarification with no existing-program change |
| RV115 | Go 1.20 language changes, library availability, and existing comparison semantics separated |
| RV179 | Built-ins/inference, initialization clarification, loop experiment and panicnil runtime defaults separated |
| RV239 | Go 1.22 loop semantics and separate function-range experiment |
| RV286 | Go 1.23 function range and separate intra-package alias experiment |
| RV332 | Go 1.24 aliases and temporary implementation opt-out |
| RV393 | Specification exposition only, no new permission |
| RV445 | Go 1.26 language features |
| RV502 | Go 1.27 language features and interface-method restriction |

## Verification and limits

The builder regenerated the canonical JSON, all per-release Markdown, main index and audit. Validation confirms all 549 semantic groups, 5,170 unique raw reconciliation entries, 604 section locations, 747 investigation-group mappings, 32 matrix rows and 112 supplemental patch records remain. Raw targets and reverse links are valid, and all primary release anchors exist in the captured HTML. A render check confirms every canonical summary and applicability statement appears in its release Markdown, and the changed matrix text and runtime citation appear in the main index.

This was a bounded correction pass. No compiler reproduction, full API-contract audit or new change inventory was added. The independent review's broader semantic-review limits remain, but no requested finding is left unresolved.

## Coordinator follow-up

RV201 now explicitly scopes the client expiry check under `InsecureSkipVerify` to session resumption, matching RB-1.21-066. The wording makes no claim that ordinary handshakes with verification disabled always check expiry. The canonical JSON, persistent review correction and Go 1.21 rendering agree. Only the affected summary/render checks were rerun.
