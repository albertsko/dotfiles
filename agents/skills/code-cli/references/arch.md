# Architecture rules

This file holds language-neutral rules for the structure of a CLI program, from a small filter to a daemon with many clients. Levels describe independent needs, not a maturity ladder.

## Terms

The terms in SKILL.md apply. New terms:

- **Domain core**: the part of the program that holds domain types, rules, and errors, with no I/O and no UI.
- **Application service**: shared orchestration that applies domain rules, calls adapters, and owns transactions and effects. In a small tool, a few functions can fill this role.
- **Adapter**: code that wraps storage or a remote backend behind an interface used by the application service.
- **Client**: an interface that calls the shared application API or protocol, such as a CLI, TUI, web UI, MCP server, or editor extension. Multiple clients may run in one process or separate programs. Scripts and agents that only invoke the CLI use its existing process contract in cli.md; they do not require an additional application interface.
- **Application API**: typed in-process calls and results exposed by the application service.
- **Protocol**: serialized requests, responses, and events exchanged across a process or transport boundary. Its compatibility requirements depend on whether peers can be upgraded independently.
- **Daemon**: a long-lived local process that owns state and serves clients over local IPC.
- **Remote authority**: a remote service that is the current source of truth for some data or decisions. That data is server-owned, even when the user created it, for example health data that a cloud service holds.
- **Hot work**: work that the user waits for now.
- **Warm work**: speculative work that prepares data for later hot work.
- **Lane**: a scheduling path with bounded queue and capacity. Lanes may share provider quotas and a state owner.
- **Durable work**: accepted obligations, such as an outbox delivery, that need completion or a recorded failure even after a client exits. This is not speculative warm work.

## How to use this file

- Apply L0 at the scale of the tool. Add levels for actual requirements or explicitly planned consumers. Record the reason, scope, and dependencies when making an architecture decision. Functions can satisfy a boundary without separate packages.
- Apply each rule only to the feature that meets its condition. An unused level is `n/a`; cross-cutting security, mutation, and background rules have their own conditions below. "Consider" is advice under the SKILL.md rubric.
- ARCH-1 to ARCH-6 evaluate the level decision, not the presence of the largest architecture. An existing design may keep a level for a justified operational or compatibility need. Missing evidence is `unverified`; an undecided draft is `open`.
- The numbers in this file are examples, not defaults.

## Choose a level

Applies at: every CLI.

CLI-facing rules: CLI-82.

| Level | Adds | Use when | Requires |
|---|---|---|---|
| L0 Domain rules and application logic | A testable separation from argument parsing and presentation | Every CLI, scaled to its complexity (ARCH-1) | - |
| L1 Protocol | Serialized messages and a transport contract | Calls cross a process or transport boundary (ARCH-2) | - |
| L2 Local daemon | A long-lived local process | Persistent resources or a long-lived owner are needed (ARCH-3) | L1 for client IPC |
| L3 Many clients | Multiple interfaces to the same application capability | Two or more interfaces exist or are concretely planned (ARCH-4) | Shared application API; L1 only across transport boundaries |
| L4 Local copies and sync | A cache, replica, or offline/synchronized data | Remote data is stored locally or synchronized (ARCH-5) | - |

- **ARCH-1** Use L0 for every CLI: separate domain decisions and application work from argument parsing and rendering where those concerns exist. A simple filter may need only a few functions. Add levels for a concrete requirement, not as a mandatory progression. `[S2]`
- **ARCH-2** Use L1 when calls cross a process or transport boundary. An in-process CLI and TUI can share a typed application API without serialization, session setup, or version negotiation. Define compatibility rules when peers can be versioned independently. `[S2]`
- **ARCH-3** Use L2 when the tool must keep a local process alive beyond a command to own persistent connections, resident state with a demonstrated startup cost, or resident background execution. Submitting durable work to an external queue, service, or scheduler does not by itself require a local daemon. Multiple writers alone do not require a daemon. Transactions or locks can coordinate independent processes. L2 needs L1 for client IPC; choose the process lifecycle from its operational requirements. `[S2]`
- **ARCH-4** Use L3 when two or more interfaces use the same application capability, for example a CLI and TUI. Share domain rules and application services. Use L1 only across process or transport boundaries and L2 only when ARCH-3 applies. `[S2]`
- **ARCH-5** Use L4 for a local cache or read replica of remote data, offline edits, or synchronization. Name which role each copy serves and apply only the corresponding rules. A disposable cache and an offline writable store have different durability contracts. `[S2]`
- **ARCH-6** Skip L1 for in-process calls, L2 when no resource or owner needs to outlive a command, L3 when there is one interface, and L4 when no local copy or sync exists. Real-time interaction may use streams and events; it does not remove application API or transport boundaries. `[S2]`
- **ARCH-7** When local ownership fits the product, consider designing local operations for offline use before adding sync or sharing. A remote-service client can legitimately require its service for remote operations. Keep independent local features available (CLI-98). `[S5]`

## L0 Domain core and thin CLI

Applies at: every CLI.

CLI-facing rules: CLI-1, CLI-6, CLI-80.

- **ARCH-8** Keep domain types and rules free of I/O and presentation. Put effectful orchestration and transactions in the application service, with storage and remote access behind adapters. Scale the separation to the program; separate packages are optional. `[S2]`
- **ARCH-9** Keep the CLI layer focused on input parsing, application calls, and rendering. Call the application service in process or through L1 when a transport boundary exists. `[S2]`
- **ARCH-10** Consider publishing a library when there is a concrete in-process consumer and a supportable public API. Scripts may already be served by the CLI process contract. A published library needs its own documented compatibility policy. `[S2,S6]`
- **ARCH-11** On Unix, choose and test a broken-pipe policy for output consumed by tools such as `head`. Conventional SIGPIPE termination is valid for filters. If graceful cleanup requires handling write errors, configure the runtime accordingly, stop writing after EPIPE, and keep expected early pipe closure free of noisy diagnostics. `[S2]`

## Shared application API and L1 protocol

Applies at: shared application APIs and transport protocols. ARCH-14, ARCH-16, and ARCH-17 apply only to their stated wire/compatibility conditions. ARCH-21 and ARCH-22 apply to every CLI.

CLI-facing rules: CORE-6, CORE-7, CLI-39, CLI-40, CLI-42, CLI-43, CLI-46, CLI-93, CLI-94, CLI-95, CLI-99.

- **ARCH-12** Give each shared state invariant an explicit owner or transaction boundary in the application service. A daemon may be that owner; a transactional store may coordinate independent processes. Clients own view state. The pure domain core defines rules without owning effectful execution. `[S2]`
- **ARCH-13** Expose application capabilities through the shared application API and, across transports, protocol messages. UI code should not bypass authorization or invariants through direct store access. A composition root may instantiate and wire concrete services and adapters behind these interfaces. `[S2]`
- **ARCH-14** Define transport messages, error semantics, and compatibility before adding an independently versioned peer. Apply CLI-93 to CLI-95 to published contracts. In-process clients can evolve together through ordinary typed API changes. `[S2]`
- **ARCH-15** When a second interface is planned, consider building a small representative path early to test the shared API. Missing reusable behavior may require application-service work as well as API changes. Keep presentation-specific behavior in its client. `[S2]`
- **ARCH-16** When peers are independently versioned, define supported protocol versions and capability discovery. Negotiate at session start for sessionful protocols, or use the transport's version mechanism for stateless calls. Reject unsupported versions clearly; accept compatible versions according to the contract. CLI-39 and CLI-43 apply to the corresponding structured wire contracts. `[S2]`
- **ARCH-17** Consider JSON and an established message protocol such as JSON-RPC for inspectable IPC. Select its transport binding as well: JSON-RPC alone defines no byte-stream framing (ARCH-46). High-volume binary or streaming use cases may need another contract. In-process APIs need no serialization. CLI output follows CORE-6. `[S2]`
- **ARCH-18** Define domain and application error kinds in the shared application API and carry stable codes across client and transport boundaries (CLI-46). Clients render errors rather than classifying message text. `[S2]`
- **ARCH-19** When clients subscribe to shared state changes, publish committed changes only to authorized, interested subscribers. An optimistic view is provisional until the application service confirms or reconciles it. Define missed-event recovery, such as a versioned snapshot, when delivery can be lost. `[S2]`
- **ARCH-20** Consider a durable authoritative store, separate session state, and rebuildable derived indexes. State the consistency contract: asynchronous indexes can lag, and operations that require current indexed data must wait, fall back, or report that limitation. `[S2]`
- **ARCH-21** Consider computing results on demand until a measurement on real data shows a slowdown that users notice. A build or query time measured on real data, for example in the design brief, counts. `[S2]`
- **ARCH-22** Consider recording each cache or index with its refresh rule and its invalidation trigger, and each deferred one with the measured trigger that will force it. Staleness is an error when it violates the declared freshness contract; documented stale reads may be valid (ARCH-56, ARCH-73). `[S2]`
- **ARCH-23** Consider sorting every request into a few fixed groups (for example domain, platform, admin, client-specific), and record each new group as a design decision. `[S2]`

## L2 Local daemon

Applies at: CLIs that use L2.

CLI-facing rules: CORE-13, CLI-78, CLI-79, CLI-80, CLI-81, CLI-100, CLI-101, CLI-102, CLI-103. The CLI client follows CLI-101 and CLI-102, and the daemon follows ARCH-30.

- **ARCH-24** For an on-demand daemon, consider client auto-spawn using the same binary with a daemon subcommand. Use a service manager when startup, restart, environment, or unattended operation requires it. Document which component owns lifecycle and startup failure reporting. `[S2]`
- **ARCH-25** When directly spawning a detached daemon on Unix, create an independent session/process group, choose a safe working directory, and redirect standard streams to explicit log sinks or the null device. Use the platform's lifecycle mechanism elsewhere. Service-managed and foreground daemons follow their supervisor's contract. `[S2]`
- **ARCH-26** Make the launcher wait for readiness, not liveness: poll a status request with backoff and a budget that covers the slowest normal startup step. As an alternative, answer status early, and report slow parts as degraded. `[S2]`
- **ARCH-27** Name the exact readiness signal in docs and tests, for example "status returns a compatible protocol version". Give each readiness fact its own state, such as "running, player degraded". `[S2]`
- **ARCH-28** Allow one daemon per runtime identity (ARCH-33), with an exclusive lock held for its whole life. When the selected lifecycle uses a PID file, write it atomically. Remove a stale socket or PID file only under the lock. A supervisor can track process identity without a PID file; singleton coordination remains a separate requirement. `[S2]`
- **ARCH-29** Treat PID files as hints: verify identity before signaling or declaring a daemon live, because PIDs can be reused. Use the lifetime lock and authenticated or identity-checked readiness endpoint as the authority. Process-name matches alone do not prove ownership. `[S2]`
- **ARCH-30** Turn SIGTERM, SIGINT, and a shutdown command into one shutdown event, and run the steps below under one deadline. Init systems send SIGKILL after a grace period (for example about 30 s). `[S2]`
  - Stop accepting requests.
  - Finish or cancel in-flight work.
  - Flush state, and reap child processes.
  - Remove the PID file if this lifecycle uses one, and exit.
- **ARCH-31** Consider an optional idle shutdown after a configurable time with no client activity. Keep it off by default when latency matters more than memory, because the next command pays the cold start again. `[S2]`
- **ARCH-32** When supervising children, continuously drain or safely redirect every captured output stream, including stdout and stderr. A protocol reader can satisfy stdout draining. Retain bounded diagnostics and exit status; waiting for exit before reading a full pipe can deadlock. `[S2]`
- **ARCH-33** Derive every path, socket, store, token file, and credential name from one runtime identity. Choose the identity before you open any durable handle, and scope it to its state (per user or per project). `[S2]`
- **ARCH-34** Give installed, development, and demo runs separate runtime identities. Otherwise a copied development config can read production secrets through a shared credential name. `[S2]`
- **ARCH-35** Make clients find the daemon for the selected runtime identity, spawning it only when the client owns startup under ARCH-24. Print resolved identity and paths in authorized status output. A client using a different identity must not silently reach another instance. `[S2]`
- **ARCH-36** Keep credential reads that can show an OS prompt out of daemon startup and polling. Resolve credentials when an account connects, from a non-interactive source first. One prompt at startup can block the daemon for every account. `[S2]`
- **ARCH-37** For failures requiring intervention, hold a "needs the user" state per affected account or resource. Fail fast only for dependent operations, and notify clients once per scoped incident and error kind. Clear the state after successful revalidation, whether triggered by repair, changed credentials/configuration, or reconnect. Keep repair and diagnostics available without the daemon and unrelated operations usable (CLI-98). `[S2]`
- **ARCH-38** Give finite external operations of the daemon bounded timeouts, including provider calls, keychain reads, IPC requests, and player calls. For persistent subscriptions, bound setup and define liveness, cancellation, and reconnect behavior. A healthy subscription may have an indefinite lifetime and legitimate quiet periods. CLI-78 covers the network calls of the CLI. `[S2]`
- **ARCH-39** For finite long-running daemon operations, consider streaming meaningful progress, with a stall timeout that heartbeats alone cannot reset. Support cancellation and a configurable total budget for unattended callers. Individual network operations retain CLI-78 timeouts; persistent subscriptions follow ARCH-38. `[S2]`
- **ARCH-40** Consider logging to a file per runtime identity with size-based rotation, a foreground mode that logs to stderr, and structured logs at every IPC boundary. A detached daemon has no stdout. `[S2]`
- **ARCH-41** Consider capturing activity at the application dispatcher so clients share one audit policy. Classify logged and skipped operations; redact secret-bearing fields in both operational and audit diagnostics (CLI-47, CLI-48, CLI-77). `[S2]`

## Transport and filesystem trust

Applies at: the selected transport. Local-daemon rules require L2; framing, message limits, and browser rules also apply to L1 transports without L2. ARCH-49 applies wherever untrusted paths require filesystem confinement, even without a daemon or transport.

CLI-facing rules: CORE-13.

- **ARCH-42** Prefer owner-restricted local IPC for a local daemon: Unix domain sockets on Unix or access-controlled named pipes on Windows. Loopback network ports are reachable by other local processes unless protected, so authenticate them and apply ARCH-61. `[S2]`
- **ARCH-43** Keep application protocol semantics independent of platform transport details. Use a transport abstraction appropriate to the selected protocol; byte-stream, HTTP, and WebSocket framing need not be identical. `[S2]`
- **ARCH-44** Choose TCP or HTTP when remote, browser, third-party, or operational integration requires it. Local sockets are a useful default for local-only clients, with explicit authentication and authorization where the trust boundary requires them. `[S2]`
- **ARCH-45** For Unix domain sockets, put the socket in an owner-only directory, and set owner-only permissions on the socket file without relying on umask (for example 0600 in a 0700 directory under `$XDG_RUNTIME_DIR`). In /tmp, anyone can plant symlinks. `[S2]`
- **ARCH-46** Use the selected protocol/transport binding's framing when it defines one. Otherwise define bounded unambiguous framing for the byte stream, even when messages use an established protocol such as JSON-RPC. For example, specify a fixed-size length prefix, byte order, and exact-length reads. Preserve an established binding rather than adding an incompatible wrapper. `[S2]`
- **ARCH-47** Reject a message above a fixed size cap before you allocate, and keep every payload, events included, below the cap (for example 16 MiB). One unbounded event once crossed the cap and silently closed connections. `[S2]`
- **ARCH-48** For HTTP/WebSocket endpoints reachable by browsers, including loopback APIs with no intended browser UI, authenticate protected routes and validate Host and Origin according to the protocol and threat model. Use a narrow CORS policy when browser access is supported. Preflight and explicitly public health routes may need distinct handling but must expose no protected data or mutations. CORS is not authentication. A loopback bridge to local IPC is an optional topology choice. `[S2]`
- **ARCH-49** When untrusted paths must stay within an allowed filesystem scope, enforce that scope during resolution and open, including against symlink replacement races. This applies to archive inputs, helpers, and local or remote API clients regardless of process lifetime or transport. Use directory-relative, race-safe operations where confinement is required, private file permissions, and bounded remote bodies where fetched. A separate path check followed by an unrestricted open is insufficient. Trusted user-selected paths retain their declared access contract. `[S2]`

## L3 Many clients

Applies at: CLIs that use L3. ARCH-51 to ARCH-53 also apply to a single interface when it handles authorization, restricted callers, or untrusted action inputs.

CLI-facing rules: CORE-1, CLI-7, CLI-66, CLI-69, CLI-72, CLI-125, CLI-126, CLI-127, CLI-128.

- **ARCH-50** Expose shared application capabilities consistently to each interface. Different authenticated callers may have different permissions; equal API semantics do not imply equal authority. `[S2]`
- **ARCH-51** Keep account scope, previews, authorization, outbound-action checks, and audit policy in the application service. New surfaces such as MCP use that boundary rather than bypassing policy through provider internals. `[S2]`
- **ARCH-52** Treat origin labels (human CLI, agent, MCP) as audit metadata, not proof of identity. Enforce restricted profiles using authenticated principals, capabilities, or an entrypoint whose credentials and accessible operations are actually restricted. A caller using the same human executable and credentials has the same authority; an origin string cannot distinguish it. `[S2]`
- **ARCH-53** When untrusted content influences an action, distinguish user-authorized extraction of fields from instructions that attempt to grant authority. Validate derived targets and scope against the caller's permissions again at mutation. Content cannot grant credentials, permissions, or new tool authority. `[S2]`
- **ARCH-54** When accounts require setup, offer it in the interactive client and provide a noninteractive repair path. Distinguish securely saved configuration from verified or connected status. If live verification is unavailable, report that state clearly rather than claiming the account works or discarding valid offline configuration. `[S2]`

## L4 Local copies and sync

Applies at: CLIs that use L4, according to the role of each local copy. ARCH-61 applies at every external API boundary, even without L4.

CLI-facing rules: CLI-78, CLI-89, CLI-98, CLI-100. CLI-98 governs which local operations remain available when the service is unavailable.

- **ARCH-55** For each data type and operation, identify the authoritative owner, permitted writers, freshness requirements, and offline behavior. Decide whether the local copy is disposable, a read replica, or durable writable state. User-created data can still be server-authoritative under the product contract. `[S5]`
- **ARCH-56** For disposable caches, define refresh, invalidation, schema migration or rebuild, and stale-read behavior. Preserve unsynchronized edits outside disposable storage. Local derived results and cached server decisions are valid only within their stated authority and freshness contracts; facts versus judgments is not an ownership boundary. `[S2]`
- **ARCH-57** For incremental sync, prefer the provider's supported change cursor and deletion records. Commit each page and its continuation atomically, replay safely after failure, and handle expired cursors with reconciliation. A timestamp alone is insufficient: a custom cursor needs a total order, stable pagination under concurrent changes, and tombstones or complete reconciliation for deletions. Test equal timestamps, updates during paging, deletions, and crash/retry boundaries. `[S2]`
- **ARCH-58** For independent offline replicas, define conflict and delivery semantics using a supported sync mechanism, explicit merge policy, or a single authoritative writer. Multiple processes writing one transactional database can rely on its concurrency controls without a separate sync layer. CRDTs fit some data types, not every multi-writer system. `[S5]`
- **ARCH-59** Consider treating an external registry as a snapshot that may lag, and count local ownership of a live resource as evidence. Keep the snapshot, owner state, validity, and reconciliation result as separate fields. `[S2]`
- **ARCH-60** When coordinating a remote provider, consider per-account scheduling for sync, scheduled work, and mutations. Respect provider-wide quotas as well as account limits; bound occupancy and prioritize interactive work. Schedule follow-up work without holding a lane across recursive requests. `[S2]`
- **ARCH-61** At every external API boundary, regardless of architecture level, define authentication, caller identity, authorization, and credential lifecycle. Restrict local IPC to its intended principals; authenticate network calls rather than trusting origin tags. Scope credentials to the required authority and keep public unauthenticated operations explicitly limited. `[S2]`
- **ARCH-62** Consider keeping the local identity check (which account may claim an identity) apart from provider authorization. Call local records "registered", show the resolved identity in previews, and report provider rejections as distinct errors. `[S2]`

## Mutation pipeline

Applies at: every CLI with mutations.

CLI-facing rules: CORE-9, CORE-10, CLI-22, CLI-60, CLI-83, CLI-84, CLI-86, CLI-87, CLI-88, CLI-89, CLI-90, CLI-92, CLI-133. CLI-83 decides when a mutation needs a dry run.

- **ARCH-63** Resolve mutation targets using documented exact identifiers, aliases, selectors, or owned identities. Validate scope and permissions before effects and fail closed when resolution is ambiguous or an operational check fails. Bind dangerous previews to stable target identities and meaningful state preconditions (CLI-83, CLI-86, CLI-89, CLI-133). If state changes, reject or re-plan with the required confirmation. Report the intended and resolved targets without leaking unauthorized data. `[S2]`
- **ARCH-64** Consider treating optimistic UI as a promise that the intent was accepted. When the effect can happen locally, resolve the command fully first, run the effect as hot work, and reconcile later without a replay. `[S2]`
- **ARCH-65** Consider bounded retries for transient mutation failures only when replay is safe, such as an idempotent operation or a provider-supported idempotency key. Reconcile ambiguous outcomes before repeating non-idempotent effects. Show terminal failure for user requests and record it for durable obligations; speculative failures can remain best effort. `[S2]`
- **ARCH-66** Consider a single-use override token for a safety blocker (a check that stops a mutation): scoped to that blocker, checked again on use, and audited. Allow no session-wide or config override, and keep warnings on CORE-9. `[S2]`

## Background work

Applies at: every CLI with background or parallel work. Hot/warm scheduling rules apply only when speculation exists; durable obligations follow their own delivery contract.

CLI-facing rules: CLI-27, CLI-31, CLI-75, CLI-76, CLI-78.

- **ARCH-67** When speculative warm work exists, prioritize hot work within shared scheduler, provider, and lock limits. Bound warm occupancy, reserve capacity where feasible, and measure interactive latency. Durable obligations need their own completion and fairness policy rather than being treated as disposable speculation. `[S2]`
- **ARCH-68** When hot and warm work share a quota, state owner, or lock, use bounded batches, short critical sections, priority scheduling, and cancellation where safe. Separate queues alone do not establish isolation. Respect the same external rate limit and define how lower-priority durable work avoids starvation. `[S2]`
- **ARCH-69** Bound background queues and units of work. For speculative jobs, deduplicate, debounce where useful, tag input versions, discard stale results, and treat failures as best effort. For durable obligations, persist accepted work or use another explicit delivery guarantee, with retry, cancellation, recovery, and recorded terminal outcomes. `[S2]`
- **ARCH-70** Use bounded concurrency for parallel calls and bounded queues and result buffers at each stage. Size limits from real bottlenecks and apply backpressure or an explicit drop policy. Expose tuning only when callers or operators need it; warm work usually needs tighter limits. `[S2]`
- **ARCH-71** Choose execution primitives for the kind of work: async I/O, short CPU work, bounded blocking, persistent loops, or saturating CPU work. Protect shared mutable invariants with an explicit ownership, locking, or transaction model. A single owner task is one option, not a requirement for every async program. `[S2]`
- **ARCH-72** When reusable speculative work is justified, run its effects in the application service and key reusable results by inputs with an invalidation policy. Keep client-specific speculation in the client where appropriate. A second interface or parallel execution does not itself require a cache. `[S2]`
- **ARCH-73** Choose hot-read behavior per operation: fresh fetch, cache with refresh, or cache-only. Use cache-only reads only with an explicit freshness and missing-data contract, and provide repair or synchronization when needed. A cache miss may be normal; distinguish it from corruption or violated completeness promises. `[S2]`
- **ARCH-74** Consider requesting preload through the subsystem that owns the resource (player, database, HTTP cache), not through a parallel path. A parallel preload can succeed and still be invisible to the code that uses the resource. `[S2]`
- **ARCH-75** Expose the status of user-visible nonblocking operations where the caller can observe it, such as queued, running, ready, failed, or stale. Include freshness and completion semantics for machine callers that need them. Internal timers and speculative tasks need no separate user-visible status unless they affect the result. `[S2]`

## Enforcement and testing

Applies at: every CLI. ARCH-76 applies to shared APIs and transport boundaries, and ARCH-77 with L2. Test auto-spawn only when that lifecycle is selected.

CLI-facing rules: CLI-129, CLI-130, CLI-131, CLI-132, CLI-133, CLI-134.

- **ARCH-76** For multiple clients or a transport boundary, enforce shared application API boundaries with checks proportionate to the codebase. Client behavior depends on the public API and shared pure types. The composition root may import implementations to wire them behind interfaces. Avoid forcing separate modules on a small single-client tool. `[S2]`
- **ARCH-77** Test the selected daemon lifecycle end to end against a fake backend with isolated IPC and runtime identity: initial startup, recovery after termination, startup failure, and the exact readiness signal (ARCH-27). Include auto-spawn when the client owns startup. `[S2]`
- **ARCH-78** Match refactor verification to the behavior at risk. For contract-sensitive or broad structural changes, establish public-interface behavior tests before refactoring and run them afterward. Bounded internal changes may use focused unit tests, type checks, or static checks that cover the affected behavior. Record important coverage gaps and any resulting deferral. `[S2]`
- **ARCH-79** Consider enforcing code rules in the build: clean a lint to zero, turn it on as an error, and run lints and tests after every autofix. A lint policy only in a doc is a wish. `[S2]`
- **ARCH-80** Define the support promise for each published artifact and require matching evidence: source revision and docs, supported platforms, installation or build path, and any promised signing or notarization. Test packaged executables from clean state; test source artifacts through their documented build path. Mark artifacts with unmet support promises as previews and name the limits. `[S2]`
- **ARCH-81** Encode the artifact-specific promise from ARCH-80 in explicit release gates. Block on failed required checks and dirty derived state (versions, lockfiles, generated docs), and report unavailable required evidence as unverified. Optional signals may warn. Consider failing on a half-configured credential pair. `[S2]`
- **ARCH-82** Consider an end-to-end CI test of first run, from a clean state with a realistic demo fixture, within a time budget on the slowest supported machine. `[S2]`

## Worked example

Illustrative design, not a rule or a claim about an existing product: an email application.

```
Email application (L0, L1, L2, L3, L4 when it stores remote mail)
 CLI | TUI | MCP server | web SPA -> web bridge (HTTP+WS)
       (an agent invoking the CLI uses the existing CLI contract)
       protocol: length-prefixed JSON (ARCH-17, ARCH-46)
       over an owner-only Unix socket, token-authenticated loopback TCP,
       or a child command (ARCH-43)
                                   v
       daemon (application services, on-demand lifecycle: ARCH-12, ARCH-24)
       main store (SQLite) | rebuildable index (Tantivy) | provider adapters
 Domain core: pure mail rules and types, called by application services
 Build rule: client behavior uses the public application API or protocol;
 composition roots wire implementations behind interfaces (ARCH-76)
```

## Not covered

These details still require product- and platform-specific design:

- Product-specific upgrade and rollback migration strategy.
- Socket path length limits (`sun_path`) and network home directories.
- Windows beyond named pipes.
- Detailed event-stream backpressure and reconnect implementations.
- Platform-specific credential isolation and peer-identity implementations.
- How sandboxed agents with no socket access reach the daemon.
- Adding a level to an existing CLI, and per-user against per-project instances.
- Product-specific background-status schemas and wait commands.
- L4 storage placement, product-specific edit-conflict rules, outbox implementation, and token storage.
