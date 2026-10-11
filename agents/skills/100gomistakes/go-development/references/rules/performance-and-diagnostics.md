# Performance and diagnostics

Load when: measured hot paths, cache/layout, escape analysis, pools, profiling, traces, GC or container quotas

<a id="g199"></a>

- **G199** When optimizing data-heavy loops. Then Arrange access to reuse nearby data and exploit temporal and spatial locality. Cache sizes and line widths depend on hardware. Counted operations alone do not predict running time. Machine cache sizes, latency ratios and typical 64-byte lines are illustrative. Consider the machine model only for measured bottlenecks. Because CPUs fetch cache lines, so useful adjacent data can amortize memory access cost.

  Sources: `BP199`.

<a id="g200"></a>

- **G200** When hot code scans only a subset of record fields. Then Consider a struct of slices instead of a slice of structs for the hot fields. This is an access-pattern tradeoff, not a universal preferred representation. Total bytes may stay unchanged while useful fields per cache line increase. Whole-record operations can favor the opposite representation. Because More useful values fit in each fetched cache line.

  Sources: `BP200`.

<a id="g201"></a>

- **G201** When choosing data structures for hot traversal. Then Prefer predictable contiguous or constant-stride access when suitable. Semantics and other operation costs may require linked structures. Measure target hardware. Even contiguous allocation of a linked structure leaves dependent pointer loads. The source's claim about non-unit strides never being prefetched is too strong to treat as a contract. Because CPUs can prefetch predictable accesses more effectively than pointer chasing.

  Sources: `BP201`.

<a id="g202"></a>

- **G202** When a hot strided access pattern has unexpected cache misses. Then Investigate cache-set conflicts and avoid critical strides when measurements justify a layout change. Architecture-specific optimization. The source's illustrative bit/byte arithmetic has inconsistencies and should not become a copied formula. Input reuse and the actual cache geometry determine whether a critical stride matters. Because Addresses mapping repeatedly to one cache set evict each other.

  Sources: `BP202`.

<a id="g203"></a>

- **G203** When independent concurrent writers update nearby fields. Then Check for false sharing and consider padding or independent local results passed through channels. Data-race freedom does not eliminate false sharing. Padding size depends on cache architecture and costs memory. The sample 56-byte padding assumes an 8-byte field and 64-byte cache line. Do not hardcode that geometry for all targets. Because Coherence works at cache-line granularity, so unrelated fields can invalidate each other's caches.

  Sources: `BP203`.

<a id="g204"></a>

- **G204** When a measured CPU-bound loop has dependent operations. Then Inspect generated code and consider equivalent transformations that reduce data dependencies. Maintain correctness and clarity. Compiler and processor changes can invalidate a micro-optimization. A temporary pre-update value can expose independence, but preserve the branch semantics as well as arithmetic results. Because Independent instruction paths allow instruction-level parallelism.

  Sources: `BP204`.

<a id="g205"></a>

- **G205** When many copies of a struct consume substantial memory. Then Inspect field layout and consider grouping fields by decreasing alignment/size to reduce padding. Do not assume the source's alignment table is universally correct. Alignment varies by type/architecture and layout changes can have API implications. Treat descending size/alignment as a layout heuristic. Verify the actual target layout before accepting byte/bit or word-size claims from the source. Do not sacrifice a clear public API merely to remove padding without a measured benefit. Because Smaller structs reduce memory traffic, GC pressure, and cache-line use.

  Sources: `BP205`.

<a id="g206"></a>

- **G206** When choosing values versus pointers for performance. Then Choose semantics first and benchmark allocation and copy costs before replacing values with pointers. A pointer is not automatically faster. Stack and heap behavior depends on escape analysis and inlining. Because Pointers can force heap allocation and GC work while value copies can be cheap.

  Sources: `BP206`.

<a id="g207"></a>

- **G207** When measuring allocation-sensitive work. Then Use benchmark allocation reporting to inspect bytes and allocations per operation. ReportAllocs measures heap allocations, not ordinary stack allocations. Heap allocation adds allocator and GC work that ordinary stack-frame reuse does not incur. Because Time alone can hide heap pressure.

  Sources: `BP207`.

<a id="g208"></a>

- **G208** When a change may make objects escape. Then Inspect compiler decisions with go build -gcflags '-m=2'. The book's sharing-up/down rules are heuristics. Compiler behavior evolves. Sending references through channels, appending and variable or large allocations are contextual examples, not an exhaustive escape law. Because Escape analysis is contextual, and returning references, sending references, dynamic sizes, or large objects may escape.

  Sources: `BP208`.

<a id="g209"></a>

- **G209** When a hot API produces buffers repeatedly. Then Consider accepting caller-provided storage instead of always allocating and returning it. Passing storage down does not guarantee stack allocation. Check escape analysis. Because Callers can reuse storage and avoid forcing a fresh escaping allocation.

  Sources: `BP209`.

<a id="g210"></a>

- **G210** When using byte data to look up string-keyed maps. Then Consider direct m[string(bytes)] lookup and verify compiler allocation behavior. Optimization details change by compiler version. Do not generalize to map insertion or retained strings. A separately stored conversion may compile differently from direct lookup. Do not extrapolate the optimization to insertion, retained strings or unsafe mutation. Because The compiler can avoid a temporary conversion allocation in this expression.

  Sources: `BP210`.

<a id="g211"></a>

- **G211** When a profile shows repeated allocations of interchangeable temporary objects. Then Consider sync.Pool with a factory, reset acquired objects, and return them after use. A pool is not a durable cache or a bounded resource pool. Objects may disappear and concurrent pool safety does not make checked-out objects safe to share. Do not access an object after returning it to the pool. A creation path must handle empty pools. BOOK-ERA GC-removal timing is simplified and retention is never guaranteed. Because Reuse can lower amortized allocations and GC pressure.

  Sources: `BP211`.

<a id="g212"></a>

- **G212** When designing pooled buffer ownership. Then Ensure the active slice length and state are reset and subsequent writes are reflected in the object actually used and returned. The source's getResponse(buffer) sketch does not show how updated length is returned. Treat it as illustrative, not runnable final code. Reset logical slice length and all other reusable state. Return ownership only after the active operation finishes. Because Stale state or a lost updated slice header defeats correctness despite lower allocations.

  Sources: `BP212`.

<a id="g213"></a>

- **G213** When a frequently used function has a tiny fast path and complex slow path. Then Consider extracting the slow path so the fast wrapper can inline, then verify compiler output and benchmarks. Inlining budgets and compiler decisions are version-dependent. Avoid refactoring without evidence. Use -gcflags=-m=2 diagnostics to verify inlining decisions. Fast-path inlining may enable escape and constant optimizations beyond removing a call. Because Inlining removes call overhead and can enable further escape and constant optimizations.

  Sources: `BP213`.

<a id="g214"></a>

- **G214** When diagnosing performance rather than guessing. Then Collect the relevant pprof profile and inspect hot functions, call chains, and source lines. Choose sampling rates deliberately. Profile overhead and representative load matter. Because Profiling identifies actual CPU, allocation, goroutine, and contention costs.

  Sources: `BP214`.

<a id="g215"></a>

- **G215** When cPU time is the suspected bottleneck. Then Use a bounded CPU profile, including -cpuprofile for benchmarks, and inspect call graph, top, or flame graph views. Sampling is statistical, not exact per-call timing. Labels can separate callers sharing a function. A sampling interval is not a hard minimum function duration visible in a CPU profile. Shorter intervals increase overhead. The source assertion that work shorter than a 10 ms sampling interval cannot appear is overbroad. Because Locates expensive paths and suggests allocation, contention, or I/O-buffering work.

  Sources: `BP215`.

<a id="g216"></a>

- **G216** When analyzing memory cost. Then Distinguish cumulative allocation count/bytes from in-use object count/bytes. Profiles concern heap allocations and are sampled. The source profile keys are alloc_objects, alloc_space, inuse_objects and inuse_space. Heap sampling trades precision against overhead and does not count stack storage. Because High allocation churn and retained memory are different problems.

  Sources: `BP216`.

<a id="g217"></a>

- **G217** When investigating a suspected memory leak. Then Compare heap profiles over time after GC and look for sustained retained growth. A single increase can reflect an in-flight request. Repeat under comparable workloads. Forced GC perturbs execution. Compare meaningful intervals and comparable load, and state the direction of the diff-base comparison. Because A pre-GC spike may merely be collectible garbage.

  Sources: `BP217`.

<a id="g218"></a>

- **G218** When investigating leaked or stuck goroutines. Then Inspect goroutine profiles or a full goroutine stack dump. Use debug=2 for a full textual dump and compare lifecycle expectations. Inspect wait states, durations and creation sites against expected lifecycle. One blocked-stack snapshot is a diagnostic lead, not proof of a leak. Because Stacks reveal where goroutines remain active or blocked.

  Sources: `BP218`.

<a id="g219"></a>

- **G219** When synchronization appears to limit throughput. Then Enable SetBlockProfileRate or SetMutexProfileFraction deliberately before the interval of interest. Use block profiles for supported synchronization waits rather than assuming they cover arbitrary network/filesystem I/O. Go 1.22+ mutex samples sum goroutine delay: 100 goroutines waiting 10 ms can contribute 1 second. Go 1.25 improves runtime-lock attribution. Rates affect overhead and CPU samples alone may hide waiting. Because Attributes waits and contention to relevant code.

  Sources: `BP219`, `RV277`, `RV434`.

<a id="g220"></a>

- **G220** When collecting multiple diagnostic signals. Then Collect intrusive diagnostic profiles separately when simultaneous instrumentation could distort measurements. The book says one profiler at a time. Treat as a measurement precaution, not a claim that default heap data must be disabled. Default heap data need not be disabled merely because another diagnostic is active. The concern is observer interference from simultaneous expensive instrumentation. Because Observation can perturb the behavior being measured.

  Sources: `BP220`.

<a id="g221"></a>

- **G221** When understanding scheduling, GC pauses, or poor parallelism. Then Capture an execution trace and inspect goroutine activity across processors. Do not equate every blank interval with one cause without investigation. Many tiny execution segments and orchestration gaps can suggest scheduling overhead. Trace overhead and representative workload still matter. Because Trace events reveal scheduling overhead and runtime pauses that aggregate profiles obscure.

  Sources: `BP221`.

<a id="g222"></a>

- **G222** When trace data needs application-level meaning. Then Annotate tasks and regions with runtime/trace and end tasks appropriately. Instrumentation adds work and should target useful boundaries. Execution trace is event-based while CPU profiling is sampled. Their evidence is complementary. Because Connects runtime events to operations and duration distributions.

  Sources: `BP222`.

<a id="g223"></a>

- **G223** When gC cost appears significant. Then Measure GC behavior, using gctrace or diagnostics, before tuning. Runtime internals and defaults are version-sensitive. The source's mark/sweep wording is simplified. GODEBUG=gctrace=1 exposes collection frequency and costs. Live references, allocation rate, concurrent work and brief stop-the-world phases matter. Fixed CPU percentages and pause figures in the source are historical simplifications. Because Heap size, allocation rate, and collection effort interact.

  Sources: `BP223`.

<a id="g224"></a>

- **G224** When balancing memory use against GC CPU and latency. Then Tune GOGC only under representative load. Higher values generally allow more heap growth and fewer collections, with memory and per-cycle cost tradeoffs. Go 1.19+ GOMEMLIMIT provides a separate soft Go-managed-memory limit even with GOGC=off. Leave headroom for non-Go allocations and OS memory. Near the live-heap size the runtime can exceed the limit to make progress. Because More growth between collections reduces frequency but increases memory and potentially cycle cost.

  Sources: `BP224`, `RV73`.

<a id="g225"></a>

- **G225** When memory remains after a temporary allocation peak. Then Allow the scavenger to return unused memory, and consider debug.FreeOSMemory only for a demonstrated need. Manual collection/scavenging has costs and is not routine application logic. Distinguish retained live objects, reusable heap space and memory actually returned to the OS. Forced release does not fix unwanted live references. Because Heap capacity and OS-reported memory do not immediately track live objects.

  Sources: `BP225`.

<a id="g226"></a>

- **G226** When evaluating the book's exceptional burst workaround. Then Prefer measuring GOGC and, from Go 1.19, GOMEMLIMIT before considering retained ballast. Ballast is a historical exceptional technique, not a default. Its address-space use, physical pages touched, OS lazy allocation and container accounting need dedicated validation. The book's 1 GB size is not reusable configuration. Because The book proposes increasing the minimum live heap to reduce burst-triggered GC frequency.

  Sources: `BP226`, `RV73`.

<a id="g227"></a>

- **G227** When deploying Go under container CPU quotas. Then Inspect runtime.GOMAXPROCS(0), CPU affinity/quota and program GODEBUG settings. On Go 1.25+, Linux quota awareness and periodic updates on all platforms default on for program compatibility defaults >=1.25, and off for defaults <=1.24. These defaults follow the active workspace or work module, then godebug and main-package //go:debug overrides. Per-file language gates do not select them. Inspect go list -f '{{.DefaultGODEBUG}}' for the main package and runtime GODEBUG environment overrides. A positive GOMAXPROCS environment override or value-setting runtime.GOMAXPROCS call disables automatic updates. runtime.SetDefaultGOMAXPROCS (Go 1.25+) restores managed defaults. Quotas differ from Kubernetes CPU requests, and matching them does not guarantee zero throttling. Measure throttling and tail latency before changing settings. Because Host-core-based concurrency can exhaust a quota early and cause pauses.

  Sources: `BP227`, `RV396`, `RV433`.

<a id="g228"></a>

- **G228** When the runtime does not derive execution capacity from the container quota. Then First inspect actual runtime and module behavior using the container rule. If quota-aware defaults are unavailable or intentionally disabled, consider an explicit quota-aware adjustment such as automaxprocs. Measure its effect and avoid an unnecessary override of working Go 1.25+ managed defaults. Because Bounds simultaneous execution to the container's intended capacity.

  Sources: `BP228`, `RV396`, `RV433`.

<a id="g234"></a>

- **G234** When the same function serves several workloads. Then Attach pprof labels where differentiation matters. Label selection should support the diagnostic question. Because Separates costs by logical caller or workload.

  Sources: `BP234`.

<a id="g235"></a>

- **G235** When enabling production diagnostics. Then Consider net/http/pprof or programmatic/benchmark profile collection with awareness of sampling cost. Profiles such as CPU are collected for a chosen interval. Endpoint exposure/security is outside this local-source investigation. The source pprof endpoint example establishes a diagnostic mechanism, not a production endpoint-exposure policy. Because Provides actionable diagnostics without continuously enabling every expensive profile.

  Sources: `BP235`.

<a id="g236"></a>

- **G236** When cPU profiles show allocation, synchronization or syscall overhead. Then Reduce unnecessary allocations, investigate contention, or consider I/O buffering based on the observed hotspot. These are diagnostic hypotheses, not automatic fixes. Because Targets the runtime cost actually dominating execution.

  Sources: `BP236`.

<a id="g237"></a>

- **G237** When built-in profiles do not cover a resource of interest. Then Consider a custom pprof.Profile. The book's threadcreate broken-status note is historical, not a current recommendation. BOOK-ERA: the threadcreate broken-status observation is historical and must not be carried forward as current tool behavior. Because Extends diagnostics to application-specific accounting.

  Sources: `BP237`.

<a id="g267"></a>

- **G267** When considering GC-triggered cleanup or weak references. Then Keep explicit Close and ownership as the primary resource lifetime. Go 1.24+ AddCleanup is preferred over new SetFinalizer usage for supplementary cleanup. Avoid callback/argument references that keep the object alive, preserve required liveness, and account for concurrent callbacks on Go 1.25+. Keep long blocking work off cleanup queues. Use weak pointers only when the data structure deliberately permits collection. Because Reachability-based cleanup is not deterministic ownership and can run concurrently.

  Sources: `RV344`, `RV345`, `RV433`.

<a id="g268"></a>

- **G268** When diagnosing suspected goroutine leaks on Go 1.26+. Then Use the goroutineleak profile with goroutine stacks and lifecycle analysis. Go 1.26 offers it experimentally with GOEXPERIMENT=goroutineleakprofile. Go 1.27 supports it and removes that switch. The detector finds unreachable synchronization objects with no possible unblocker but can miss globally or otherwise reachably held deadlocks. Because No profile samples cannot establish absence of leaks.

  Sources: `RV451`, `RV515`.

<a id="g269"></a>

- **G269** When considering PGO or comparing performance after a Go upgrade. Then Use representative CPU profiles and benchmarks on the deployment workload. PGO is generally supported from Go 1.21 and -pgo=auto uses default.pgo per main package. Record whether the profile is present. Reassess allocation, map, collector and inlining assumptions after upgrades. Green Tea was experimental in Go 1.25 and default in Go 1.26. Published percentages are workload observations, not guarantees. Because Compiler/runtime changes alter costs while measured evidence determines useful optimization.

  Sources: `RV181`, `RV184`, `RV293`, `RV338`, `RV397`, `RV448`, `RV514`.

<a id="g270"></a>

- **G270** When rare production events need execution-trace evidence. Then On Go 1.25+, consider trace.FlightRecorder with deliberate time and memory retention, then snapshot after the event. Bound instrumentation cost and protect diagnostic data. Go 1.27 trace -http=:port binds localhost, and go1.27+ traceback labels can expose pprof labels, controlled by tracebacklabels. Avoid putting secrets in diagnostic labels. Because A bounded recent trace can capture an event without storing every trace indefinitely.

  Sources: `RV398`, `RV512`, `RV513`.

<a id="g271"></a>

- **G271** When using unsafe, assembly, cgo pointers or runtime representation assumptions. Then Check documented lifetimes, alignment and ownership, and avoid depending on slice growth, map layout, heap allocation, closure symbol names or function code pointers as closure identity. Go 1.20 unsafe helpers avoid header-layout tricks but remain unsafe. New stack placement can expose existing lifetime bugs. Diagnostic compiler escape hatches do not establish a valid fix. Because Safe source semantics do not promise implementation representation or pointer lifetime extensions.

  Sources: `RV26`, `RV115`, `RV222`, `RV246`, `RV403`, `RV452`, `RV516`.
