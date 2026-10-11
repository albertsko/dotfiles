# Concurrency and lifecycles

Load when: goroutine structure, worker bounds, contexts, cancellation, joins, channels or leak prevention

<a id="g106"></a>

- **G106** When designing concurrent work. Then Separate work structure and coordination from simultaneous execution, and parallelize actual bottlenecks. Adding workers to a non-bottleneck stage may not improve throughput. Because Concurrency enables independent stages, while parallelism adds execution capacity.

  Sources: `BP106`.

<a id="g107"></a>

- **G107** When considering parallel execution. Then Begin with a simple sequential version unless measurements justify concurrency. Goroutines are lightweight, not free. Profile and benchmark in a production-like environment. Scheduling, queuing, stack memory, context switches and contention all contribute overhead. BOOK-ERA scheduler timings, initial stack sizes and G/M/P descriptions are explanatory, not tuning contracts. Because Goroutine creation, scheduling, contention, and coordination can outweigh work.

  Sources: `BP107`.

<a id="g108"></a>

- **G108** When recursively splitting or scheduling very small jobs. Then Use a measured granularity threshold and keep small jobs sequential. The threshold is machine- and workload-dependent, not the example's fixed 2048 universally. Because Tiny tasks can cost less than their scheduling overhead.

  Sources: `BP108`.

<a id="g109"></a>

- **G109** When choosing a concurrency primitive. Then Use mutexes for exclusive access to shared state and channels for communication, coordination, or ownership transfer. They are complementary. The book's parallel/concurrent classification is a heuristic, not a channel synchronization prohibition. Because The primitives express different responsibilities.

  Sources: `BP109`.

<a id="g110"></a>

- **G110** When multiple goroutines access shared memory and one writes. Then Use suitable atomic operations, one mutex protecting the critical section, or a single owner receiving messages. Atomicity of an individual operation does not make a whole algorithm correct. Protect reads as well as writes and synchronize before observing completion. Multiple individually atomic operations do not automatically protect a compound invariant. Because Unsynchronized read/write combinations cause data races and invalid results.

  Sources: `BP110`.

<a id="g111"></a>

- **G111** When output depends on execution ordering. Then Coordinate the required sequence explicitly, even after removing data races. Use channels or another sequencing design when state transitions must happen in order. Mutual exclusion alone does not choose which independently scheduled assignment should win. Because A race-free program can still have timing-dependent logical results.

  Sources: `BP111`.

<a id="g112"></a>

- **G112** When publishing data between goroutines. Then Establish an actual happens-before path through synchronization. Reason about channel send/receive and observed closure precisely. A send happens before completion of its matching receive. Closing a channel happens before a receive that observes closure. Because Launching establishes startup ordering, but goroutine exit alone does not publish completion.

  Sources: `BP112`.

<a id="g113"></a>

- **G113** When changing an unbuffered channel to a buffered one. Then Recheck ordering assumptions in both directions. A send still precedes completion of its corresponding receive. Closing precedes a receive observing closure. Because Unbuffered receive-before-send-completion guarantees do not simply carry over to arbitrary buffering.

  Sources: `BP113`.

<a id="g114"></a>

- **G114** When processing many tasks concurrently. Then Use a bounded worker pool rather than unbounded per-task goroutines. Close the job channel and wait for workers when work finishes. Because Limits resource use and pressure on downstream systems.

  Sources: `BP114`.

<a id="g115"></a>

- **G115** When choosing worker count. Then Start CPU worker counts near runtime.GOMAXPROCS(0), then measure. Size I/O work around downstream sustainable capacity. NumCPU may differ. Go 1.25+ runtime defaults can track CPU availability and Linux quotas, but older module defaults and explicit overrides affect that behavior. Mixed workloads need measurements. Because CPU work is limited by available execution capacity, while I/O work waits on external systems.

  Sources: `BP115`, `RV396`, `RV433`.

<a id="g116"></a>

- **G116** When an operation becomes useless after a time limit. Then Derive a deadline or timeout context from the existing parent and pass it to context-aware operations. Use Background only for a deliberate root when no parent exists. Cancellation is cooperative. Because Allows stale or stalled work to stop.

  Sources: `BP116`.

<a id="g117"></a>

- **G117** When creating a cancelable or timed context. Then Call the returned cancel function on every exit path when the owning work is done, commonly with defer. Do not assume that creating a cancellable context always creates a goroutine. Because Releases associated resources earlier than eventual timeout.

  Sources: `BP117`.

<a id="g118"></a>

- **G118** When a long-running activity must stop with its owner. Then Propagate a cancellation context and arrange graceful resource cleanup. Signaling cancellation alone does not prove cleanup completed. Because Cancellation communicates lifecycle termination.

  Sources: `BP118`.

<a id="g119"></a>

- **G119** When context values need stable keys across packages. Then Use an unexported custom key type and controlled key values. Values are suited to cross-boundary information such as tracing or middleware metadata. WithValue derives a child context instead of mutating its parent. Keep key values controlled as well as using a private key type. Because Plain string keys can collide between packages.

  Sources: `BP119`.

<a id="g120"></a>

- **G120** When implementing context-aware channel operations. Then Select between the send or receive and ctx.Done, then report ctx.Err on cancellation. Done is a broadcast closure signal. Err distinguishes deadline from cancellation. Check channel closure and other protocol conditions separately from cancellation. Standard contexts can be shared concurrently. Because A blocking channel operation otherwise prevents prompt cancellation.

  Sources: `BP120`.

<a id="g121"></a>

- **G121** When designing a function callers may wait for. Then Accept a context so upstream callers can control cancellation. Use TODO when the right context is not yet clear, rather than disguising the uncertainty as Background. TODO identifies incomplete propagation. Background states an intentional root. Because Long-running work needs caller-controlled lifetime.

  Sources: `BP121`.

<a id="g122"></a>

- **G122** When launching work that must outlive an HTTP request. Then Give detached work an explicit owner, lifetime bound and completion path. From Go 1.21, context.WithoutCancel preserves values while removing cancellation and deadline, and its Done channel is nil. Add a fresh cancelable/timeout context when needed. On older versions, choose a deliberate root or a carefully defined value-preserving wrapper. Request completion must not accidentally terminate required background work. Because Request cancellation or handler completion can abort asynchronous publication.

  Sources: `BP122`, `RV195`.

<a id="g123"></a>

- **G123** When starting any goroutine. Then Identify its exit condition and the owner responsible for stopping it. A receive loop requires a known channel closure or cancellation path. Because Leaked goroutines retain stacks, referenced memory, and external resources.

  Sources: `BP123`.

<a id="g124"></a>

- **G124** When shutting down a service or goroutine owning resources. Then Wait for cleanup to finish before the parent or application exits. Provide a close/join lifecycle appropriate to the component. A synchronous Close can provide the join guarantee when it actually releases owned resources before returning. Because A cancellation signal alone does not guarantee cleanup completes.

  Sources: `BP124`.

<a id="g125"></a>

- **G125** When goroutines capture loop variables. Then Check the effective module/file language version. Go 1.22+ gives fresh per-iteration variables when the loop declares them with :=, including three-clause loops. Assignment with = still reuses existing variables. In older language modes or with explicitly shared variables, copy the value or pass it as an argument. Distinct value copies differ from pointers to original slice elements obtained by index. Fresh loop variables do not determine goroutine or parallel-subtest execution order. Because Capturing a shared variable can observe a later value and race. A new toolchain alone does not change an older file language mode.

  Sources: `BP125`, `RV239`, `RV242`.

  Example: [Older language-mode loop captures](../../examples/loops-go121/loop_test.go).

<a id="g126"></a>

- **G126** When selecting among multiple ready channels. Then Do not use case source order to express priority. A default branch only runs when none can proceed. A ready case is chosen pseudo-randomly. This does not make case order a priority mechanism. Default runs only when no other case can proceed. Because select chooses among ready operations rather than taking the first textual case.

  Sources: `BP126`.

<a id="g127"></a>

- **G127** When one producer must deliver data before a termination event. Then Use one ordered event channel or a suitable unbuffered handoff. This ordering argument assumes a single producer. More than one producer needs additional coordination. A single-producer ordering argument is not enough. Because A separate buffered data channel can retain messages when termination is selected.

  Sources: `BP127`.

<a id="g128"></a>

- **G128** When a termination signal should allow draining already available messages. Then After termination, drain messages with an inner select and default before returning. Messages arriving after the drain can be missed. Handle closed channels and producer coordination deliberately. A closed channel remains ready and must be handled with the receive ok result to avoid endless zero-value draining. Because The drain consumes currently ready data without blocking indefinitely.

  Sources: `BP128`.

<a id="g129"></a>

- **G129** When a channel conveys notification with no payload. Then Use chan struct{}. Choose actual data types when values do have meaning. Because The type communicates absence of data meaning and empty elements require no payload storage.

  Sources: `BP129`.

<a id="g130"></a>

- **G130** When a select loop consumes channels that can close. Then Use the two-result receive and set closed input channels to nil to disable their cases. Exit when all inputs are disabled. Sending or receiving on a nil channel outside select blocks forever. Plan output consumption and cancellation too. Finish and close an owned output after all input channels are disabled. Because Closed channels remain ready and can cause zero-value streams or busy loops.

  Sources: `BP130`.

<a id="g131"></a>

- **G131** When choosing buffered versus unbuffered channels. Then Use unbuffered channels when the protocol needs a rendezvous and buffering when justified by decoupling or bounded capacity. Buffered channels also have memory-model guarantees. The book's synchronization wording should not be treated as an absolute. An unbuffered channel is also sufficient for closure-only notifications because there is no payload queue to buffer. Because Buffering changes blocking and ordering behavior and may obscure deadlocks.

  Sources: `BP131`.

<a id="g132"></a>

- **G132** When sizing a buffered channel. Then Start with a small justified capacity and tie larger capacities to worker count, a resource limit, or measurements. The book proposes 1 as a default heuristic. Explain non-obvious sizes. Burst requirements can justify more capacity. Tie a buffer used for workers or rate limiting to the corresponding bound. Because Queue capacity trades memory against contention and rarely stays perfectly balanced.

  Sources: `BP132`.

<a id="g232"></a>

- **G232** When carrying request metadata across API boundaries. Then Use context values for cross-cutting information such as correlation IDs or middleware metadata. Mutable values require their own synchronization, context concurrency safety does not protect pointees. Standard context concurrency safety does not synchronize mutable values or pointees stored in that context. Because Related operations can share metadata without invasive plumbing.

  Sources: `BP232`.

<a id="g233"></a>

- **G233** When choosing a root context. Then Use Background for a deliberate root and TODO when the correct context is unresolved. Because TODO documents incomplete context propagation.

  Sources: `BP233`.

<a id="g252"></a>

- **G252** When callers need a cancellation reason beyond canceled or deadline exceeded. Then Use context.WithCancelCause and Cause on Go 1.20+, or WithDeadlineCause/WithTimeoutCause on Go 1.21+ for expiry reasons. Keep cancellation cooperative, call the owning cancel function, and separately join work that must finish cleanup. Go 1.26 signal.NotifyContext also records the signal cause. Because A cause carries diagnostic meaning without replacing lifetime and completion protocols.

  Sources: `RV136`, `RV195`, `RV489`.
