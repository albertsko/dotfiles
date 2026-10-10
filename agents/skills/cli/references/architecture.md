# Architecture rules: REF-154 to REF-235

This file holds language-neutral rules for the structure of a CLI program, from one process up to a daemon with many client programs. It defines REF-154 to REF-235.

## Terms

The terms in SKILL.md apply. New terms:

- **Domain core**: the part of the program that holds domain types, rules, and errors, with no I/O and no UI.
- **Adapter**: a module that wraps storage or a remote backend behind an interface that the domain core defines.
- **Client program** (short: client): a separate program that drives the domain core, for example the CLI, a TUI, a web UI, an MCP server, an editor plugin, or an extension. The CLI is one client program. An agent that drives the tool through its own client program (for example an MCP server) counts as that client program. Scripts, agents, and other programs (such as a plugin or a TUI) that only run the CLI command are not client programs. They use the CLI contract in cli.md.
- **Protocol**: the typed requests, responses, and events between the domain core and its clients.
- **Daemon**: a long-lived local process that owns state and serves clients over local IPC.
- **Remote authority**: a remote service that is the current source of truth for some data or decisions. That data is server-owned, even when the user created it, for example health data that a cloud service holds.
- **Hot work**: work that the user waits for now.
- **Warm work**: speculative work that prepares data for later hot work.
- **Lane**: a separate path for work, with its own queue and capacity.

## How to use this file

- The architecture of a CLI is L0, plus every level whose test in "Choose a level" holds, plus the levels those require. The levels are not one chain. For example, a CLI can use L4 with no daemon.
- Apply the rules of a level to the parts of the CLI that use the level. For example, when only the sync feature keeps a local copy of remote data, only that feature follows the L4 rules.
- Mark the REFs of an unused level `n/a`, with one line per section. Mutation pipeline and Background work apply when the CLI has that kind of work.
- Record the level decision in the design: the levels used, the result of each level test, the parts of the CLI that use each level, any caches you record (REF-175), and the triggers that would add a level.
- A level that another used level requires is never skipped. Its stay test does not apply.
- A "Choose a level" rule passes when the design records the level decision for it and the decision matches the test. It fails when the decision, or a level the design uses, does not match the test. When a draft records no decision, mark the rule `open`.
- For a built CLI with no design record, judge the levels from the code. A rule passes when the built levels match the tests. It fails when the CLI lacks a level whose test holds, or has a level that no test asks for.
- The level status rules above cover REF-154 to REF-159. Check REF-160 like any other rule.
- The numbers in this file are examples, not defaults.

## Choose a level

Applies at: every CLI.

CLI-facing rules: REF-95 (in cli.md).

| Level | Adds | Use when | Requires | Skip when |
|---|---|---|---|---|
| L0 Domain core and thin CLI | A domain core, adapters, and a thin CLI in one process | Always (REF-154) | - | Never |
| L1 Protocol | Typed messages between the domain core and its clients | L2 or L3 applies, or the interface must outlive its UI (REF-155) | - | Throwaway tool, or real-time two-way UX, when no used level requires L1 (REF-159) |
| L2 Local daemon | An auto-spawned process that owns state | In-memory state, open connections, or background work must outlive one command (REF-156) | L1 | Stateless and fast from a cold start (REF-159) |
| L3 Many clients | Peer clients, with authority in the domain core | Two or more client programs, now or expected (REF-157) | L1 | One client program and no second one in sight, or real-time two-way UX (REF-159) |
| L4 Remote authority | A local copy of remote-owned data, with sync | The CLI keeps a local copy of remote-owned data (REF-158) | - | The CLI only sends requests and keeps no copy (REF-159) |

- **REF-154** Use L0 for every CLI. Add another level only when its test below holds, or when a level you add requires it. Layers that no test asks for are cost with no return. `[S2]`
- **REF-155** Use L1 (protocol) when L2 or L3 requires it, or when the interface must outlive its current UI. Protocols built for stability survive UI rewrites. `[S2]`
- **REF-156** Use L2 (local daemon) when in-memory state, open connections, or background work must outlive one command, for any reason below. State saved to a file or database between runs does not count by itself. One client is enough. L2 requires L1, because the CLI talks to the daemon through the protocol. `[S2]`
  - Rebuilding the state for each command costs a delay that users notice (for example above about 50 ms).
  - A connection must stay open, for example IMAP IDLE or a file watcher.
  - Two or more client programs run at the same time and change shared state. Without a daemon, one client becomes the state holder.
  - In-memory state must stay loaded after the client that opened it exits.
- **REF-157** Use L3 (many clients) when you have or expect two or more client programs, for example the CLI and a TUI. L3 requires L1, and needs L2 only when the L2 test (REF-156) also holds. `[S2]`
- **REF-158** Use L4 (remote authority) when the CLI keeps a local copy of data that a remote service owns (a cache, a mirror, or offline data), or syncs with it. L4 requires no other level. `[S2]`
- **REF-159** Skip a level when its stay test holds: `[S2]`
  - L1: the tool is a throwaway tool, or its UX is real-time and two-way (for example video calls or live drawing), where request and response shapes do not fit. This test applies only when no used level requires L1. Real-time two-way UX also skips L3.
  - L2: the tool is stateless, and each run is fast from a cold start (for example under about 50 ms, as in jq or ripgrep).
  - L3: the CLI is the only client program, and no second one is in sight.
  - L4: the CLI only sends requests to a remote API and keeps no local copy. The network rules of cli.md apply (REF-91).
- **REF-160** When the CLI owns its data (no remote authority), design data features for offline use from the start, because offline support is hard to add to a server-centric design. Consider a local design first, with a backend added later for sync or sharing. `[S5]`

## L0 Domain core and thin CLI

Applies at: every CLI.

CLI-facing rules: REF-14, REF-19, REF-93 (in cli.md).

- **REF-161** Keep the domain core free of I/O and UI, and put storage and backend details in adapters. Every client can then reuse the domain core unchanged. `[S2]`
- **REF-162** Keep the CLI layer thin: it parses input, calls the domain core, and renders the result. It calls the domain core in process, or through the protocol when the CLI uses L1. `[S2]`
- **REF-163** When other programs need the capability, also ship it as a library with its own contract, docs, and versions (for example Willison's `llm`). Publish bounded contracts, not every module that splits off easily. `[S2,S6]`
- **REF-164** On Unix, keep SIGPIPE from killing the process (for example, ignore it), and handle write errors as normal return values. Otherwise the process dies when its output goes through `head`. `[S2]`

## L1 Protocol

Applies at: CLIs that use L1. REF-174 and REF-175 apply to every CLI.

CLI-facing rules: REF-6, REF-7 (in SKILL.md), REF-52, REF-53, REF-55, REF-56, REF-59, REF-106, REF-107, REF-108, REF-112 (in cli.md).

- **REF-165** Give state one owner: the domain core (the daemon, with L2) owns domain state, background work, and execution flow. Clients keep only view state, such as focus and scroll. `[S2]`
- **REF-166** Let clients reach the domain core only through protocol types, also when speed tempts you. Store reads, imports of internal modules, and shared memory bypass the protocol. In-process calls through protocol types, with no daemon, are fine. `[S2]`
- **REF-167** Define the protocol (messages, error model, versioning rule) before the second client. Change it by the Future-proofing rules (REF-106 to REF-108), and retire old capabilities on a schedule. `[S2]`
- **REF-168** Build the second client early, even a small one, as the test of the protocol. When it needs changes inside the domain core or the daemon, fix the protocol. `[S2]`
- **REF-169** Exchange version and capabilities at session start, in explicit lifecycle messages (initialize, work, shutdown). Apply REF-52 to every protocol message, and make the client refuse a version mismatch with a clear error (REF-56). A client can then ask what the domain core supports. `[S2]`
- **REF-170** Use JSON and an existing message format such as JSON-RPC for the protocol, unless you have a strong reason not to. People and agents can then read the traffic with `socat`. CLI output still follows REF-6. `[S2]`
- **REF-171** Decide each error kind once in the domain core, and carry its stable code to every client (REF-59). A client that derives the kind from message text breaks when the wording changes. `[S2]`
- **REF-172** Publish every change of shared state from the domain core as an event to all clients. A client may show an optimistic view, but only a domain core event changes shared state. `[S2]`
- **REF-173** Consider one durable store for the main state, memory for session state, and derived state (such as a search index) rebuilt from the store. Reads, sync, and writes then never wait for a derived layer. `[S2]`
- **REF-174** Consider computing results on demand until a measurement on real data shows a slowdown that users notice. A build or query time measured on real data, for example in the design brief, counts. `[S2]`
- **REF-175** Consider recording each cache or index with its refresh rule and its invalidation trigger, and each deferred one with the measured trigger that will force it. A stale cache returns wrong answers with no error. `[S2]`
- **REF-176** Consider sorting every request into a few fixed groups (for example domain, platform, admin, client-specific), and record each new group as a design decision. `[S2]`

## L2 Local daemon

Applies at: CLIs that use L2.

CLI-facing rules: REF-13 (in SKILL.md), REF-91, REF-92, REF-93, REF-94, REF-113, REF-114, REF-115, REF-116 (in cli.md). The CLI client follows REF-114 and REF-115, and the daemon follows REF-183.

- **REF-177** Auto-spawn the daemon from the client: connect when a daemon answers, and otherwise start the same binary with a daemon subcommand. Use an init-managed service only for a daemon that must run at boot or before login. `[S2]`
- **REF-178** Detach a spawned daemon into its own session and process group, with its working directory at `/` and its standard streams on the null device. Harnesses may kill the whole process group of the client. `[S2]`
- **REF-179** Make the launcher wait for readiness, not liveness: poll a status request with backoff and a budget that covers the slowest normal startup step. As an alternative, answer status early, and report slow parts as degraded. `[S2]`
- **REF-180** Name the exact readiness signal in docs and tests, for example "status returns a compatible protocol version". Give each readiness fact its own state, such as "running, player degraded". `[S2]`
- **REF-181** Allow one daemon per runtime identity (REF-186), with an exclusive lock held for its whole life. Write the PID file atomically, and remove a stale socket or PID file only under the lock. `[S2]`
- **REF-182** Consider trusting a PID file that the daemon wrote until proven wrong, and treating a process-scan match as foreign until proven to be the daemon. The wrong default once deleted the PID files of live daemons. `[S2]`
- **REF-183** Turn SIGTERM, SIGINT, and a shutdown command into one shutdown event, and run the steps below under one deadline. Init systems send SIGKILL after a grace period (for example about 30 s). `[S2]`
  - Stop accepting requests.
  - Finish or cancel in-flight work.
  - Flush state, and reap child processes.
  - Remove the PID file, and exit.
- **REF-184** Consider an optional idle shutdown after a configurable time with no client activity. Keep it off by default when latency matters more than memory, because the next command pays the cold start again. `[S2]`
- **REF-185** When the daemon supervises child processes, drain the stderr of each child continuously in its own task, and keep the last stderr line and the exit status. A full pipe buffer blocks the child silently. `[S2]`
- **REF-186** Derive every path, socket, store, token file, and credential name from one runtime identity. Choose the identity before you open any durable handle, and scope it to its state (per user or per project). `[S2]`
- **REF-187** Give installed, development, and demo runs separate runtime identities. Otherwise a copied development config can read production secrets through a shared credential name. `[S2]`
- **REF-188** Make every client spawn and find the daemon of the same runtime identity, and print the resolved identity and paths in status output. One client outside the identity breaks the boundary. `[S2]`
- **REF-189** Keep credential reads that can show an OS prompt out of daemon startup and polling. Resolve credentials when an account connects, from a non-interactive source first. One prompt at startup can block the daemon for every account. `[S2]`
- **REF-190** Hold a "needs the user" state in the daemon: notify clients once per error kind, and fail fast until a repair command runs. Keep that command and diagnostics working without the daemon. `[S2]`
- **REF-191** Give every external operation of the daemon a bounded timeout, for example provider calls, keychain reads, IPC requests, and player calls. REF-91 covers the network calls of the CLI. `[S2]`
- **REF-192** Consider streaming progress for long daemon operations, and let a client give up only after a stall window with no progress. A fixed total deadline kills slow but healthy first runs. Each network call keeps REF-91. `[S2]`
- **REF-193** Consider logging to a file per runtime identity with size-based rotation, a foreground mode that logs to stderr, and structured logs at every IPC boundary. A detached daemon has no stdout. `[S2]`
- **REF-194** Consider capturing the activity log at the daemon dispatcher, not in each client. Classify each request as logged or skipped, and keep secret-bearing payloads out of the skipped-request log. `[S2]`

## L2 Transport

Applies at: CLIs that use L2.

CLI-facing rules: REF-13 (in SKILL.md).

- **REF-195** Use local-only IPC for a daemon: a Unix domain socket on Unix, and a named pipe restricted to the owner on Windows (for example through `SECURITY_ATTRIBUTES`). A network port is open to every local process. `[S2]`
- **REF-196** Put one stream interface between the protocol and the transport. Every platform and extra path (for example loopback TCP with a token, or a child command over SSH) then carries the same messages and encoding. `[S2]`
- **REF-197** Use TCP or HTTP only when a client is on another machine, is a browser, or is a third-party client that needs HTTP tools (curl, OpenAPI). Otherwise a local socket is faster, safer, and simpler. `[S2]`
- **REF-198** Put the socket in an owner-only directory, and set owner-only permissions on the socket file without relying on umask (for example 0600 in a 0700 directory under `$XDG_RUNTIME_DIR`). In /tmp, anyone can plant symlinks. `[S2]`
- **REF-199** Frame stream messages with one fixed-size length prefix and one byte order, and read exactly that many bytes (for example a 4-byte big-endian prefix). `[S2]`
- **REF-200** Reject a message above a fixed size cap before you allocate, and keep every payload, events included, below the cap (for example 16 MiB). One unbounded event once crossed the cap and silently closed connections. `[S2]`
- **REF-201** When a browser must be a client, consider a separate bridge to the local IPC that binds to loopback only. Check a bearer token, a Host allowlist, and a CORS allowlist on every route, API docs included. `[S2]`
- **REF-202** Consider treating every local entrypoint as reachable by a hostile local client. Build file writes in the daemon under an allowlisted root, reject `..` and symlinks, set private permissions, and cap remote bodies before buffering. `[S2]`

## L3 Many clients

Applies at: CLIs that use L3.

CLI-facing rules: REF-1 (in SKILL.md), REF-20, REF-79, REF-82, REF-85, REF-138, REF-139, REF-140, REF-141 (in cli.md).

- **REF-203** Make every client an equal peer of the same protocol, including your own main UI and every AI integration. A privileged main UI turns the other clients into second-class ones. `[S2]`
- **REF-204** Keep authority in the domain core: account scope, previews, permission checks, checks on outbound actions, and the activity log. New surfaces such as an MCP server enter only through the domain core, never through provider internals. `[S2]`
- **REF-205** Tag each request with its origin (human CLI, agent, MCP), and check agent and MCP origins at one dispatch point against a profile (for example reads only). Human defaults stay (REF-1). Doc examples do not stop an agent. `[S2]`
- **REF-206** Consider treating untrusted content (mail, web pages, and their summaries) as data. It may describe an action, but it cannot choose recipients, tools, credentials, scope, or permissions, so check policy again at the mutation. `[S2]`
- **REF-207** Send a user with no or broken accounts into setup in the client they use, with credential prompts visible there. Test each account before you report it saved, so first run ends working or in one repairable error. `[S2]`

## L4 Remote authority

Applies at: CLIs that use L4.

CLI-facing rules: REF-91, REF-102, REF-111, REF-113 (in cli.md). REF-111 still applies: the CLI keeps working on local data when the remote service is gone.

- **REF-208** Decide who owns each kind of data. Keep user-owned data primary on the device, read and written locally and synced in the background. Leave server-owned facts and judgments with the remote authority. `[S5]`
- **REF-209** Consider treating the local copy of remote data as a disposable mirror that answers facts only. Send judgments (scores, advice, decisions) to the remote authority, and re-sync when the cache version changes. `[S2]`
- **REF-210** When the upstream is not append-only, consider syncing the mirror on a change stamp that the server writes on every insert and update. Move the cursor to the highest stamp of each page. `[S2]`
- **REF-211** Give data with more than one writer a dedicated sync layer (for example CRDTs), or, as this skill's default, a single writer. Hand-written diff and merge code is often unreliable and brittle. `[S5]`
- **REF-212** Consider treating an external registry as a snapshot that may lag, and count local ownership of a live resource as evidence. Keep the snapshot, owner state, validity, and reconciliation result as separate fields. `[S2]`
- **REF-213** When the daemon wraps a remote provider, consider one lane per provider account for sync, scheduled work, and mutations. Run the follow-up work of a sync outside the lane. An unscoped sync can block an account. `[S2]`
- **REF-214** When the domain core serves clients over a network, make auth part of the API. Give each client its own user identity (for example a short-lived signed token), not a shared static key or a bypass. `[S2]`
- **REF-215** Consider keeping the local identity check (which account may claim an identity) apart from provider authorization. Call local records "registered", show the resolved identity in previews, and report provider rejections as distinct errors. `[S2]`

## Mutation pipeline

Applies at: every CLI with mutations.

CLI-facing rules: REF-9, REF-10 (in SKILL.md), REF-35, REF-73, REF-96, REF-97, REF-99, REF-100, REF-101, REF-102, REF-103, REF-105, REF-146 (in cli.md). REF-96 decides when a mutation needs a dry run.

- **REF-216** Fail closed on mutation targets: `[S2]`
  - Accept only an exact match, a configured alias, or an owned identity.
  - Fall back to another target only when the product decides so.
  - Name the intended and the visible targets in the error.
  - Treat an operational failure as unknown, not as a policy answer.
- **REF-217** Consider treating optimistic UI as a promise that the intent was accepted. When the effect can happen locally, resolve the command fully first, run the effect as hot work, and reconcile later without a replay. `[S2]`
- **REF-218** Consider bounded retries for transient failures of idempotent mutations while the optimistic state stays. Retry no sends, charges, or validation and permission errors, and show an error after the last retry only for explicit user intent. `[S2]`
- **REF-219** Consider a single-use override token for a safety blocker (a check that stops a mutation): scoped to that blocker, checked again on use, and audited. Allow no session-wide or config override, and keep warnings on REF-9. `[S2]`

## Background work

Applies at: every CLI with background or parallel work.

CLI-facing rules: REF-40, REF-44, REF-88, REF-89, REF-91 (in cli.md).

- **REF-220** Give hot work first claim on scheduler time, handlers, provider budget, and locks. Give warm work bounded capacity, its own lane, and separate tracing. Warm work that slows the current action has failed. `[S2]`
- **REF-221** Keep hot and warm lanes apart downstream: no shared lock, owner task, rate limit, or long command. Make the state owner read a dedicated hot channel first. Two lanes that wait on one lock are fake parallelism. `[S2]`
- **REF-222** Bound background work and keep it fresh: `[S2]`
  - Use finite queues, and small units and batches.
  - Tag each job with the version of its inputs, and drop stale results.
  - Remove duplicate jobs.
  - Treat a failure as best effort, unless the user asked for the work.
  - Start work on demand, after the input stops changing for a moment, and not on every sync tick.
- **REF-223** Default to bounded concurrency for parallel calls, with a tunable limit at every stage (channels, result buffers, retry queues). Size each limit from the real bottleneck, and tighter for warm work. One unbounded stage defeats back-pressure. `[S2]`
- **REF-224** When the program runs async work, classify each task (async I/O, short CPU, bounded blocking, endless loop, saturating CPU), and pick the primitive from its class. Keep shared mutable state in one owner task. `[S2]`
- **REF-225** Run warm work on reusable domain data in the domain core, keyed by durable inputs and not by one client's screen. Seed a new client from that cache with no provider calls. `[S2]`
- **REF-226** Serve hot reads from the cache only, and move repair to an explicit command or a lower-priority background path. Report a missing row that the cache promised as a cache error. `[S2]`
- **REF-227** Consider requesting preload through the subsystem that owns the resource (player, database, HTTP cache), not through a parallel path. A parallel preload can succeed and still be invisible to the code that uses the resource. `[S2]`
- **REF-228** Show the result of nonblocking work where the user already looks, with a state from the backend (queued, running, ready, failed, stale). Show cached and fresh results, and failures, in the same place. `[S2]`

## Enforcement and testing

Applies at: every CLI. REF-229 applies with L1, and REF-230 with L2.

CLI-facing rules: REF-142, REF-143, REF-144, REF-145, REF-146, REF-147 (in cli.md).

- **REF-229** Before the second client exists, enforce module boundaries in the build: client modules depend only on the protocol and shared pure modules. When a feature needs to cross the boundary, change the architecture, not the check. `[S2]`
- **REF-230** Test the daemon path end to end against a fake backend, with isolated IPC and runtime identity: auto-spawn on the first call, respawn after a kill, and the exact readiness signal (REF-180). `[S2]`
- **REF-231** Refactor only behind a behavior test on the public interface that passes before and after. Otherwise record a deferral with the fix and the missing test harness. `[S2]`
- **REF-232** Consider enforcing code rules in the build: clean a lint to zero, turn it on as an error, and run lints and tests after every autofix. A lint policy only in a doc is a wish. `[S2]`
- **REF-233** Publish only artifacts whose promise you can defend: current code, clean-machine launch, a packaged smoke test, platform trust, and matching docs. Mark the others as previews. `[S2]`
- **REF-234** Encode that promise in release gates: block on deterministic failures and on dirty derived state (versions, lockfiles, generated docs), and warn on optional signals. Consider failing on a half-configured credential pair. `[S2]`
- **REF-235** Consider an end-to-end CI test of first run, from a clean state with a realistic demo fixture, within a time budget on the slowest supported machine. `[S2]`

## Worked example

Example only, not a rule: mxr, a Rust email CLI.

```
mxr (L0, L1, L2, L3, no L4)
 CLI | TUI | MCP server | web SPA -> web bridge (HTTP+WS)
       (the agent skill runs the CLI, so it is not a client program)
       protocol: length-prefixed JSON (REF-170, REF-199)
       over an owner-only Unix socket, token-authenticated loopback TCP,
       or a child command (REF-196)
                                   v
       daemon (auto-spawned, owns all state: REF-165, REF-177)
       main store (SQLite) | rebuildable index (Tantivy) | provider adapters
 Build rule: clients depend on the domain core and protocol only (REF-229)
```

## Not covered

The sources raise these topics but give no rules.

- Daemon and CLI version mismatch after an upgrade.
- Socket path length limits (`sun_path`) and network home directories.
- Windows beyond named pipes.
- Log redaction beyond the skipped-request log (REF-194).
- What the CLI does when it cannot spawn a daemon.
- A live but stuck daemon (the status request hangs).
- Event streams: backpressure, slow clients, reconnect, missed events.
- How a client proves its origin, and socket auth beyond file permissions.
- How sandboxed agents with no socket access reach the daemon.
- Adding a level to an existing CLI, and per-user against per-project instances.
- Background state (stale, syncing) in machine output, and how a script waits for it.
- L4 sync details: mirror location, edit conflicts, offline writes (an outbox), invalidation, token storage.
