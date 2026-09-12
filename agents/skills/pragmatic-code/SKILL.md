---
name: pragmatic-code
description: Pragmatic Programmer design principles for shaping code. Load only on explicit pragmatic-code skill request. Use when designing new modules or features, making architectural choices, refactoring, or deciding an approach before writing non-trivial code.
---

# Pragmatic Code

Design lens for code that must survive change. Apply while deciding structure, not while typing lines.

**Root value: ETC (Easier To Change).** Every rule below serves it. When two rules collide, pick the option that leaves the system easier to change; the rule's stated _why_ tells you what it protects, so weigh the whys instead of following whichever rule you read last.

## What good design means

**ETC.** Requirements, environments, and understanding keep changing; design quality means adaptability to that change.

- Before committing to a structure, ask: does the structure make the system easier or harder to change?
- When future change is unclear, make the code _replaceable_ (decoupled, cohesive, small enough to rewrite) instead of guessing a flexible abstraction.

**DRY (Don't Repeat Yourself).** One piece of knowledge, one authoritative representation. Duplicated knowledge means a change must land in N places; the missed one becomes a contradiction.

- Needing to edit multiple places or formats for one rule change is evidence of duplicated knowledge; centralize it.
- DRY is about knowledge, not text. Identical code expressing independent rules that merely coincide is _not_ duplication: unify only same intent. Wrong-abstraction merges couple unrelated rules and cost more than the repetition.
- Compute derived values from source data; if caching, hide the cache behind accessors that keep it synchronized.
- Expose data through uniform accessors so callers can't tell stored from computed.
- Generate boundary artifacts (clients, mocks, docs, data containers) from one neutral spec or introspected schema instead of hand-maintaining parallel copies.

**Orthogonality.** Independent components: changing one never forces changes in an unrelated one. Orthogonal pieces compose multiplicatively; coupled pieces make every edit ripple.

- One module, one well-defined responsibility, stable narrow interface.
- Design test: how many modules does one functional change touch? Target: one.
- Layer components; depend only on abstractions below.
- Keep code shy: reveal nothing unnecessary, depend on no other module's internals. Pass context explicitly.
- Global state (including read-only globals and singletons) couples every user invisibly; pass what's needed instead.
- Isolate libraries that force unrelated code changes behind narrow interfaces of your own.
- Never build identity on properties you don't control (emails, phone numbers as keys).

**Reversibility.** Critical choices (database, vendor, framework, deployment model) go stale; a choice treated as permanent becomes prohibitively expensive to undo.

- Treat every technical and vendor decision as provisional; know the plausible alternative and roughly what switching costs.
- Hide third-party application programming interfaces (APIs) and persistence behind abstractions you control; expose persistence as a service instead of scattering database calls.
- Split into decoupled components even when deploying as one unit: deployment shape changes too.

## Expressing intent

**Naming.** Names are how the next reader (or you, deciding) understands the code; a wrong name misleads harder than no name.

- Name for role and intent, never mechanics. If you can't name it, you don't understand its purpose yet: the pause is a design check, not a formality.
- Replace generic labels (`user`, `amount`, `data`) with precise domain terms (`buyer`, `discount`).
- Introduce explicit types when primitives leave units, ranges, or expectations unclear.
- Follow the language and project naming culture; use project vocabulary consistently.
- Rename the moment a name turns misleading. A function whose honest name lists several jobs just named your refactoring target. A name that's _hard_ to change reveals a design problem: fix the coupling first, then rename.

**Commenting.** Comments explain what the code cannot express clearly itself; comments that merely restate code duplicate knowledge and drift when the code changes.

- Explain _why_: intent, constraints, tradeoffs, surprising decisions, and assumptions. Let names and structure explain _what_ and _how_.
- Delete or rewrite comments when the code changes; a wrong comment is worse than no comment because readers trust it.
- Prefer improving unclear code over explaining it with prose. Keep comments for irreducible context, not as compensation for poor naming or structure.

**Guard clauses and the happy path.** Code should read as a clear narrative of its primary purpose; deep nesting hides this intent behind layers of edge cases. Express the main intent un-indented straight down the left margin.

- Fail fast and exit early. Validate inputs, check permissions, and handle anomalies at the very top of the routine. Abandon the task the moment a show-stopping condition is met.
- Invert wrapping conditions to keep the main flow flat. Instead of `if (isValid) { doWork(); }`, write `if (!isValid) return; doWork();`.
- Treat `else` as a structural smell. If an if block returns or throws, the `else` keyword is redundant and forces unnecessary indentation on the core logic that follows.
- Return early. Early returns free the reader's working memory because they don't have to hold a failure condition in mind while reading the main logic.
- Avoid the code deep nesting. If you still need deep nesting after applying guard clauses, the nested block likely represents a separate domain concept that deserves its own named function.

**Code organization and ordering.** Source should reveal concepts in the order a reader needs them. Physical proximity is part of design: code that belongs to the same concept should be easy to find, understand, and change together.

- Organize by concept, not declaration kind. Keep a type near its constructors, methods, and helpers.
- Put primary types and entry points before implementation details.
- Keep methods of the same type together when practical; put common operations before specialized ones.
- Keep small helpers near the code they support; move shared helpers only as far as needed.
- Prefer files named around domain concepts over generic types, helpers, or interfaces files.
- Follow the surrounding package's convention when multiple orders are equally clear.
- If related code cannot be kept reasonably close, reconsider the boundaries or split the file.

## Keeping code flexible

**Decoupling.** Coupling forces components to change together, and transitive coupling spreads the blast into code that looks unrelated.

- Tell, don't ask: tell the object what result you need; don't read its state, decide elsewhere, write state back. Rules and validation live beside the state they govern.
- One method or property hop per access. A chain like `order.customer.address.zip` couples you to three implementations; replace it with an intention-revealing operation on the responsible object. Chain freely only across genuinely stable interfaces (language standard library).
- Prefer pipelines with explicit data formats over traversal through hidden object structure.
- Wrap global mutable data (and databases, filesystems, shared services) behind APIs you control; the wrapper preserves compatibility when representation changes, though the data stays shared.

**Events over polling and hard-wiring.** React to information as it arrives; event designs decouple producer from consumer.

- Persist state outside the process when a workflow spans requests or long delays.
- For simple local notification, use Observer and accept coupling to the source and a synchronous bottleneck. For independent lifecycles or asynchronous communication use publish/subscribe and accept harder-to-trace flow.
- Model event sequences as streams; filter, transform, and merge them like collections.

**Transformation pipelines.** Programs are input-to-output transformations; designing around data flow instead of mutable object webs keeps functions small, reusable, loosely coupled.

- Define input and output first, list intermediate data forms, decompose until every transformation is a small obvious function.
- Pass state through the flow; hidden mutable state in communicating objects is coupling in disguise.
- Wrap results as success or error values so a failure stops downstream stages; let types catch incompatible stages.

**Inheritance tax.** Inheritance couples subclass and clients to ancestor APIs and internal state; deep hierarchies turn brittle; single trees can't model overlapping roles.

- Before subclassing, name the actual goal, then use the direct tool: an interface or protocol for type compatibility, delegation (exposing only needed operations) for using a service, a mixin or trait for shared code.
- Separate domain rules from persistence and other infrastructure the object needn't manage.
- Compose context-specific variants from focused capabilities (e.g., validation sets) instead of one class with behavior flags.

**Configuration.** Values that change after deploy or vary by environment or customer don't belong in code: credentials, endpoints, tunable parameters, rates.

- Externalize them; expose via a thin API, never a global configuration structure, so code doesn't depend on the storage representation.
- Configure genuine variability only. A setting added to dodge a product decision trades feedback for permanent complexity: pick one behavior, ship, learn.

## Concurrency

**Break temporal coupling.** Fixed ordering that exists only because the first design was linear wastes waits and hides flexibility.

- Map the workflow; separate genuine ordering constraints from steps that merely happened to be written sequentially.
- Overlap work with waits (input/output, services, user input); parallelize independent processor-heavy chunks; synchronize only where downstream work needs completed inputs.

**Shared state is incorrect state.** Any value read from a shared mutable resource is stale by the time you act on it; separate reasonable check and update combine into a race. Shared means memory, files, databases, services, process-wide settings.

- Make check-decide-update one atomic operation; never act on an unprotected snapshot.
- Encapsulate locking inside the resource's interface: a convention every caller must remember will be forgotten. Guarantee lock release on every path including exceptions.
- Multi-resource operations succeed or fail as one unit, returning partial acquisitions on failure; hide that coordination behind a transaction interface.
- Prefer immutability and clear ownership; the best shared mutable state is none.

**Actors.** An actor (private state, a mailbox, one message processed to completion at a time) gives concurrency without shared state, locks, or architecture-specific code.

- Model each concurrent responsibility as an actor; coordinate through one-way messages (include a reply mailbox when a response is needed).
- Expect message timing and ordering to vary without breaking correctness; keep actor code independent of core and machine layout.
- Add supervision to restart failed actors.
- Code guarded by mutexes is a candidate for actor conversion.

**Blackboards.** For independent contributors and inputs arriving in unpredictable order: post facts to a shared persistent space, let rules trigger processing as prerequisites become satisfied. Decouples contributors from each other and isolates changing policies from the workflow.

- Cost is indirection: keep message and API definitions in one central spec, propagate a trace identifier through every participant, deploy agents independently.

## Honest, correct programs

**Design by contract.** Precondition (caller's duty), postcondition (routine's guarantee), invariants (state anyone may rely on). A routine does no more and no less than it claims; blame for a failure lands on whoever broke their side.

- Define valid inputs, guarantees, and deliberate non-guarantees _before_ implementing.
- Accept only clearly valid input; promise only what's reliably deliverable. Restrict direct mutation of invariant-participating data.
- A contract violation is a bug, never routine input validation. Fail at the violation point with precise diagnostics.
- Without native support, bracket routines with assertions, use guard clauses to make invalid dispatch impossible, record the rest in tests.
- State the requirements that define the system's meaning as prominent semantic invariants; keep changeable policy separate.

**Assert the impossible.** "Can't happen" is an assumption; assert it so the bug surfaces at its origin, not three modules downstream.

- Assert invariants, parameters, results, algorithm postconditions, with descriptive messages and diagnostic data.
- Expected errors and invalid user input get normal error handling, never assertions.
- Assertion conditions stay side-effect-free; assert against stored results of state-changing operations.
- Leave assertions on in production: tests can't cover every execution and production fails in ways test environments don't. Disable individual checks only on measured cost.

**Crash early.** After an impossible state, the program's own state is untrustworthy; continuing risks corrupting data, which is worse than dying.

- Treat every error as evidence state may already be invalid; read the actual message instead of ruling it impossible.
- Default branch in every switch; reaching it unexpectedly is an error.
- Let exceptions propagate; catch only when the handler does more than log-and-rethrow: enumerated catches hide logic and couple callers to callee internals.
- Terminate promptly on impossible state, after releasing resources and closing transactions when the environment requires cleanup. For resilience, isolate fallible work under supervisors that restart it.

**Never code by coincidence.** Code that works without you knowing _why_ it works is an accident waiting for a different machine, input, or library release; false confidence makes the eventual failure undiagnosable.

- Make environmental assumptions (locale, clocks, file permissions, network availability, configuration, execution order) explicit and tested; assert them so verified assumptions double as documentation. Use Coordinated Universal Time (UTC) when systems span time zones.
- Copied solutions carry their original context's assumptions; re-verify them in yours.

**Balance resources.** Cleanup separated from allocation gets skipped on some path eventually.

- Whoever allocates, deallocates. Keep lifetimes narrow; use scope-bound cleanup (RAII, `with`, `defer`) or `finally`, allocating _before_ the protected block so failed allocation can't trigger phantom cleanup.
- Acquire shared resource sets in one consistent order everywhere; release in reverse. Inconsistent order causes deadlock.
- Per aggregate structure, pick one deallocation policy (recursive free, free-self-only, or refuse-while-populated) and apply it everywhere.
- Long-lived artifacts (logs, caches, records) consume finite capacity: rotate or expire them.

**Assume hostility.** Every connected system is attacked; obscurity protects nothing.

- Minimize attack surface: simple code, few access points, least privilege for the shortest time, fine-grained permissions, most-secure defaults with explicit opt-out.
- Validate and sanitize all external input before storing, rendering, or executing it.
- Remove default and unused credentials; return only data the requester is authorized for; hide stack traces and debug facilities.
- Encrypt sensitive data at rest; keep secrets out of version control, in deployment configuration or environment.
- Never implement cryptography yourself; use vetted, maintained libraries.

## Proving and improving

**Refactor continuously.** Code is a garden, not a building: structure decays as knowledge and usage change, and postponed restructuring accrues dependencies and risk.

- Refactor as soon as awkward code or new knowledge reveals a better design; duplication, rippling changes, outdated assumptions, and newly passing tests are the triggers.
- Never mix refactoring with behavior change; tests green before, one small change at a time, tests after each: a failure then indicts one recent edit.
- A change too disruptive for increments is a scheduled rewrite, named as such.

**Test to design.** The test is the code's first user; writing it first exposes unclear requirements, awkward interfaces, and hidden dependencies before implementation hardens them. A hard-to-test unit is a badly coupled unit.

- Think through the test before the implementation; pass dependencies in rather than hiding them in global state.
- Test-driven development (TDD) cycle: add one failing test, confirm it is the only failure, write the minimum code, refactor with tests green. Skip coverage-chasing and redundant tests; keep the destination in view instead of following passing-test momentum.
- Test each unit against its _contract_ (normal, boundary, invalid, contrived), verifying both that code honors the contract and that the contract means what you intended. Verify dependencies first so failures localize.
- Preserve every useful debugging check as a regression test; build in test access (structured logs, diagnostic switches).
- Keep the whole suite green: routine failures train everyone to ignore it. Avoid asserting incidental details (timestamps, exact wording).

**Property-based tests.** Example tests encode the author's assumptions: the code's same wrong assumptions, so both pass together. Generated inputs challenge assumptions independently.

- State contracts and invariants as properties; drive them with composable generators over broad input ranges.
- Assert properties of results and state, not just expected examples.
- For every generated failure: capture the exact inputs, freeze as a focused unit test, fix the assumption, keep as regression guard.
- Complement to unit tests, not replacement; keep clear examples of known cases.
