# Topic router

Read each topic's trigger list before excluding its rules. The task ledger retains every rule until a decision is recorded.

- [Design and measurement](rules/design-and-measurement-principles.md): architecture, readability, speculative abstractions, optimization tradeoffs or contextual advice
- [Code and API design](rules/code-and-api-design.md): scope, initialization, interfaces, generics, embedding, options, packages, documentation or logging
- [Numeric correctness](rules/numeric-correctness.md): integer ranges, numeric literals, floating-point calculations or numerical comparisons
- [Collections and ownership](rules/collections-and-ownership.md): slice/map allocation, copying, aliasing, retention, comparison or pointer collections
- [Iteration and control flow](rules/iteration-and-control-flow.md): range semantics, iteration addresses, map order, loop exits, per-iteration cleanup or iterators
- [Functions, methods and interfaces](rules/functions-methods-and-interfaces.md): receivers, named results, typed nil, stream APIs or deferred argument/receiver evaluation
- [Errors and cleanup](rules/errors-and-cleanup.md): panic/recover, error contracts, wrapping/matching, logging, ignored errors or cleanup failures
- [Concurrency and lifecycles](rules/concurrency-and-lifecycles.md): goroutine structure, worker bounds, contexts, cancellation, joins, channels or leak prevention
- [Shared state and synchronization](rules/shared-state-and-synchronization.md): shared memory, happens-before, mutexes, snapshots, WaitGroup, Cond, errgroup or atomics
- [Resources, HTTP and subprocesses](rules/resource-and-http-lifecycles.md): files, durability, HTTP bodies/timeouts/routes, proxies, filesystem confinement or subprocesses
- [Database access](rules/database-access.md): database readiness, sql.DB pools, parameterization, NULL or Rows lifecycle
- [Text and bytes](rules/text-and-bytes.md): Unicode/encoding, byte versus rune indexes, trimming, building strings or retained substrings
- [Time and serialization](rules/time-and-serialization.md): duration units, timers, JSON, monotonic time, time zones or omission/presence semantics
- [Testing](rules/testing.md): test selection/isolation, concurrency, clocks, HTTP/I/O tests, fuzzing, coverage or test cleanup
- [Benchmarking](rules/benchmarking.md): benchmark timing, optimization elimination, representative inputs or statistical comparison
- [Performance and diagnostics](rules/performance-and-diagnostics.md): measured hot paths, cache/layout, escape analysis, pools, profiling, traces, GC or container quotas
- [Versions and tooling](rules/versions-and-tooling.md): any Go build/review/upgrade, baseline selection, modules/workspaces, platforms, experiments or developer tools
- [Security and compatibility](rules/security-and-compatibility.md): randomness, reproducible simulations/sampling/replay, crypto/TLS/trust policy, external compatibility or exact implementation-output assertions
