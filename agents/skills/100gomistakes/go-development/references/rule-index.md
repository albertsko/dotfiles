# Rule applicability index

This generated index supports screening. Load the detailed topic reference for applicable or uncertain rules.

## Design and measurement

- [G1](rules/design-and-measurement-principles.md#g1): designing for possible future requirements
- [G2](rules/design-and-measurement-principles.md#g2): maintaining code over years
- [G197](rules/design-and-measurement-principles.md#g197): optimizing a codebase
- [G238](rules/design-and-measurement-principles.md#g238): applying advice from the book

## Code and API design

- [G3](rules/code-and-api-design.md#g3): assigning an outer variable inside a nested block
- [G4](rules/code-and-api-design.md#g4): branches handle errors or exceptional inputs
- [G5](rules/code-and-api-design.md#g5): using several init functions
- [G6](rules/code-and-api-design.md#g6): initialization can fail or depends on external systems
- [G7](rules/code-and-api-design.md#g7): storing initialized state
- [G8](rules/code-and-api-design.md#g8): exposing struct data
- [G9](rules/code-and-api-design.md#g9): naming accessor methods
- [G10](rules/code-and-api-design.md#g10): several implementations share meaningful behavior
- [G11](rules/code-and-api-design.md#g11): tests or other callers need replaceable dependencies
- [G12](rules/code-and-api-design.md#g12): a component must only use part of another type's behavior
- [G13](rules/code-and-api-design.md#g13): considering a new interface
- [G14](rules/code-and-api-design.md#g14): a consumer needs to abstract a producer
- [G15](rules/code-and-api-design.md#g15): designing function signatures
- [G16](rules/code-and-api-design.md#g16): inputs or outputs belong to known types
- [G17](rules/code-and-api-design.md#g17): writing generic APIs
- [G18](rules/code-and-api-design.md#g18): typed collections or common algorithms would duplicate code
- [G19](rules/code-and-api-design.md#g19): a function only calls a required interface method
- [G20](rules/code-and-api-design.md#g20): considering an embedded struct field
- [G21](rules/code-and-api-design.md#g21): an exported type embeds another evolving type
- [G22](rules/code-and-api-design.md#g22): designing optional API configuration
- [G23](rules/code-and-api-design.md#g23): options should be convenient and extensible
- [G24](rules/code-and-api-design.md#g24): choosing repository structure
- [G25](rules/code-and-api-design.md#g25): separating programs, private implementation, and assets
- [G26](rules/code-and-api-design.md#g26): splitting packages
- [G27](rules/code-and-api-design.md#g27): naming packages
- [G28](rules/code-and-api-design.md#g28): deciding what to export
- [G29](rules/code-and-api-design.md#g29): a package is named utils, common, shared, or base
- [G30](rules/code-and-api-design.md#g30): a package name already supplies type context
- [G31](rules/code-and-api-design.md#g31): representing a set
- [G32](rules/code-and-api-design.md#g32): a local name matches an imported package or builtin
- [G33](rules/code-and-api-design.md#g33): exporting an API element
- [G34](rules/code-and-api-design.md#g34): deprecating an API
- [G35](rules/code-and-api-design.md#g35): documenting constants or variables
- [G36](rules/code-and-api-design.md#g36): documenting a package
- [G37](rules/code-and-api-design.md#g37): maintaining a Go project
- [G38](rules/code-and-api-design.md#g38): maintaining formatting consistency
- [G198](rules/code-and-api-design.md#g198): designing interface granularity
- [G229](rules/code-and-api-design.md#g229): initializing static configuration
- [G230](rules/code-and-api-design.md#g230): using a builder with chaining
- [G240](rules/code-and-api-design.md#g240): zero is a valid explicit option
- [G248](rules/code-and-api-design.md#g248): introducing generic aliases or newer expression syntax
- [G272](rules/code-and-api-design.md#g272): adding structured logging or custom log handlers

## Numeric correctness

- [G39](rules/numeric-correctness.md#g39): writing octal literals such as permissions
- [G40](rules/numeric-correctness.md#g40): writing long numeric literals
- [G41](rules/numeric-correctness.md#g41): choosing integer types or converting large values
- [G42](rules/numeric-correctness.md#g42): incrementing a bounded integer
- [G43](rules/numeric-correctness.md#g43): adding bounded integers
- [G44](rules/numeric-correctness.md#g44): multiplying bounded integers
- [G45](rules/numeric-correctness.md#g45): comparing approximate floating-point results
- [G46](rules/numeric-correctness.md#g46): a numeric domain can produce special floating values
- [G47](rules/numeric-correctness.md#g47): accumulating floating-point additions and subtractions
- [G48](rules/numeric-correctness.md#g48): reordering mixed floating-point operations for accuracy

## Collections and ownership

- [G49](rules/collections-and-ownership.md#g49): indexing or appending slices
- [G50](rules/collections-and-ownership.md#g50): the output slice size is known
- [G51](rules/collections-and-ownership.md#g51): filtering yields an uncertain output size
- [G52](rules/collections-and-ownership.md#g52): building an initially empty result of unknown final length
- [G53](rules/collections-and-ownership.md#g53): passing slices to serializers, reflect, or libraries
- [G54](rules/collections-and-ownership.md#g54): checking whether slices or maps contain elements
- [G55](rules/collections-and-ownership.md#g55): designing collection-returning APIs
- [G56](rules/collections-and-ownership.md#g56): copying a slice
- [G57](rules/collections-and-ownership.md#g57): passing a subslice to code that may append
- [G58](rules/collections-and-ownership.md#g58): keeping a small portion of a large slice long term
- [G59](rules/collections-and-ownership.md#g59): removing elements containing pointers from a retained backing array
- [G60](rules/collections-and-ownership.md#g60): the expected map population is known
- [G61](rules/collections-and-ownership.md#g61): a long-lived map remains large after a temporary spike
- [G62](rules/collections-and-ownership.md#g62): map values make retained storage expensive
- [G63](rules/collections-and-ownership.md#g63): comparing values with == or !=
- [G64](rules/collections-and-ownership.md#g64): comparing composite values
- [G65](rules/collections-and-ownership.md#g65): implementing a performance-sensitive comparator
- [G249](rules/collections-and-ownership.md#g249): implementing collection comparisons, copies, searches or sorting

## Iteration and control flow

- [G66](rules/iteration-and-control-flow.md#g66): mutating slice elements in a loop
- [G67](rules/iteration-and-control-flow.md#g67): iterating every collection element
- [G68](rules/iteration-and-control-flow.md#g68): a range loop changes its input expression
- [G69](rules/iteration-and-control-flow.md#g69): ranging over an array while observing mutations
- [G70](rules/iteration-and-control-flow.md#g70): retaining addresses of slice or map iteration values
- [G71](rules/iteration-and-control-flow.md#g71): depending on order from a map
- [G72](rules/iteration-and-control-flow.md#g72): adding map entries while iterating
- [G73](rules/iteration-and-control-flow.md#g73): breaking or continuing an outer loop containing switch or select
- [G74](rules/iteration-and-control-flow.md#g74): each loop iteration acquires a resource needing cleanup
- [G231](rules/iteration-and-control-flow.md#g231): choosing pointer collections
- [G250](rules/iteration-and-control-flow.md#g250): using integer or function range and iterator helpers

## Functions, methods and interfaces

- [G84](rules/functions-methods-and-interfaces.md#g84): a method changes receiver state or contains noncopyable synchronization state
- [G85](rules/functions-methods-and-interfaces.md#g85): choosing receivers for naturally small value types
- [G86](rules/functions-methods-and-interfaces.md#g86): choosing receiver kinds and consistency across a type
- [G87](rules/functions-methods-and-interfaces.md#g87): several return values have unclear meanings, especially identical types
- [G88](rules/functions-methods-and-interfaces.md#g88): using named results in an implementation
- [G89](rules/functions-methods-and-interfaces.md#g89): returning a named result after a failing call or condition
- [G90](rules/functions-methods-and-interfaces.md#g90): returning an interface, particularly error, from a pointer value
- [G91](rules/functions-methods-and-interfaces.md#g91): a function processes stream content
- [G92](rules/functions-methods-and-interfaces.md#g92): deferred work must see a variable's final value
- [G93](rules/functions-methods-and-interfaces.md#g93): deferring a method call before modifying its receiver
- [G239](rules/functions-methods-and-interfaces.md#g239): a receiver is large

## Errors and cleanup

- [G94](rules/errors-and-cleanup.md#g94): reporting normal operational failure
- [G95](rules/errors-and-cleanup.md#g95): a deliberate panic recovery boundary is needed
- [G96](rules/errors-and-cleanup.md#g96): returning an error from a lower layer
- [G97](rules/errors-and-cleanup.md#g97): callers need an error category or extra structured information
- [G98](rules/errors-and-cleanup.md#g98): the underlying error is an implementation detail
- [G99](rules/errors-and-cleanup.md#g99): matching an error type that may be wrapped
- [G100](rules/errors-and-cleanup.md#g100): matching a sentinel error that may be wrapped
- [G101](rules/errors-and-cleanup.md#g101): designing recognizable errors
- [G102](rules/errors-and-cleanup.md#g102): propagating a failure through layers
- [G103](rules/errors-and-cleanup.md#g103): an error is intentionally safe to ignore
- [G104](rules/errors-and-cleanup.md#g104): a deferred cleanup can fail
- [G105](rules/errors-and-cleanup.md#g105): propagating cleanup failure through named results
- [G253](rules/errors-and-cleanup.md#g253): combining or inspecting multiple failures

## Concurrency and lifecycles

- [G106](rules/concurrency-and-lifecycles.md#g106): designing concurrent work
- [G107](rules/concurrency-and-lifecycles.md#g107): considering parallel execution
- [G108](rules/concurrency-and-lifecycles.md#g108): recursively splitting or scheduling very small jobs
- [G109](rules/concurrency-and-lifecycles.md#g109): choosing a concurrency primitive
- [G110](rules/concurrency-and-lifecycles.md#g110): multiple goroutines access shared memory and one writes
- [G111](rules/concurrency-and-lifecycles.md#g111): output depends on execution ordering
- [G112](rules/concurrency-and-lifecycles.md#g112): publishing data between goroutines
- [G113](rules/concurrency-and-lifecycles.md#g113): changing an unbuffered channel to a buffered one
- [G114](rules/concurrency-and-lifecycles.md#g114): processing many tasks concurrently
- [G115](rules/concurrency-and-lifecycles.md#g115): choosing worker count
- [G116](rules/concurrency-and-lifecycles.md#g116): an operation becomes useless after a time limit
- [G117](rules/concurrency-and-lifecycles.md#g117): creating a cancelable or timed context
- [G118](rules/concurrency-and-lifecycles.md#g118): a long-running activity must stop with its owner
- [G119](rules/concurrency-and-lifecycles.md#g119): context values need stable keys across packages
- [G120](rules/concurrency-and-lifecycles.md#g120): implementing context-aware channel operations
- [G121](rules/concurrency-and-lifecycles.md#g121): designing a function callers may wait for
- [G122](rules/concurrency-and-lifecycles.md#g122): launching work that must outlive an HTTP request
- [G123](rules/concurrency-and-lifecycles.md#g123): starting any goroutine
- [G124](rules/concurrency-and-lifecycles.md#g124): shutting down a service or goroutine owning resources
- [G125](rules/concurrency-and-lifecycles.md#g125): goroutines capture loop variables
- [G126](rules/concurrency-and-lifecycles.md#g126): selecting among multiple ready channels
- [G127](rules/concurrency-and-lifecycles.md#g127): one producer must deliver data before a termination event
- [G128](rules/concurrency-and-lifecycles.md#g128): a termination signal should allow draining already available messages
- [G129](rules/concurrency-and-lifecycles.md#g129): a channel conveys notification with no payload
- [G130](rules/concurrency-and-lifecycles.md#g130): a select loop consumes channels that can close
- [G131](rules/concurrency-and-lifecycles.md#g131): choosing buffered versus unbuffered channels
- [G132](rules/concurrency-and-lifecycles.md#g132): sizing a buffered channel
- [G232](rules/concurrency-and-lifecycles.md#g232): carrying request metadata across API boundaries
- [G233](rules/concurrency-and-lifecycles.md#g233): choosing a root context
- [G252](rules/concurrency-and-lifecycles.md#g252): callers need a cancellation reason beyond canceled or deadline exceeded

## Shared state and synchronization

- [G133](rules/shared-state-and-synchronization.md#g133): formatting a context or object in concurrent code
- [G134](rules/shared-state-and-synchronization.md#g134): formatting an object while holding its lock
- [G135](rules/shared-state-and-synchronization.md#g135): validation does not require shared mutable state
- [G136](rules/shared-state-and-synchronization.md#g136): concurrent goroutines append from a shared slice
- [G137](rules/shared-state-and-synchronization.md#g137): partitioning concurrent collection access
- [G138](rules/shared-state-and-synchronization.md#g138): reading shared slices or maps under a mutex
- [G139](rules/shared-state-and-synchronization.md#g139): using WaitGroup with newly started goroutines
- [G140](rules/shared-state-and-synchronization.md#g140): many goroutines repeatedly wait for changing shared conditions
- [G141](rules/shared-state-and-synchronization.md#g141): waiting on a sync.Cond
- [G142](rules/shared-state-and-synchronization.md#g142): running several tasks with error propagation and cancellation
- [G143](rules/shared-state-and-synchronization.md#g143): concurrent tasks produce ordered independent results
- [G144](rules/shared-state-and-synchronization.md#g144): passing, returning, or calling methods on synchronization-containing values
- [G145](rules/shared-state-and-synchronization.md#g145): reviewing code that uses sync types
- [G251](rules/shared-state-and-synchronization.md#g251): representing independently atomic shared state

## Resources, HTTP and subprocesses

- [G160](rules/resource-and-http-lifecycles.md#g160): an HTTP client call succeeds
- [G161](rules/resource-and-http-lifecycles.md#g161): only status matters and connection reuse is desired
- [G162](rules/resource-and-http-lifecycles.md#g162): a database query returns Rows
- [G163](rules/resource-and-http-lifecycles.md#g163): opening files
- [G164](rules/resource-and-http-lifecycles.md#g164): file durability is required before return
- [G165](rules/resource-and-http-lifecycles.md#g165): an HTTP error response should terminate a handler
- [G166](rules/resource-and-http-lifecycles.md#g166): configuring a production HTTP client
- [G167](rules/resource-and-http-lifecycles.md#g167): an HTTP client makes many concurrent calls
- [G168](rules/resource-and-http-lifecycles.md#g168): serving untrusted or production HTTP traffic
- [G169](rules/resource-and-http-lifecycles.md#g169): keeping HTTP server connections alive
- [G261](rules/resource-and-http-lifecycles.md#g261): using ReverseProxy hooks
- [G262](rules/resource-and-http-lifecycles.md#g262): changing ServeMux routes or upgrading routing behavior
- [G263](rules/resource-and-http-lifecycles.md#g263): handling untrusted HTTP bodies, headers or browser-origin requests
- [G264](rules/resource-and-http-lifecycles.md#g264): accessing filesystem paths supplied outside the trusted boundary
- [G265](rules/resource-and-http-lifecycles.md#g265): launching subprocesses
- [G266](rules/resource-and-http-lifecycles.md#g266): constructing network endpoints or retrying network failures

## Database access

- [G154](rules/database-access.md#g154): startup readiness requires a reachable database
- [G155](rules/database-access.md#g155): operating a database client in production
- [G156](rules/database-access.md#g156): tuning database connection reuse
- [G157](rules/database-access.md#g157): repeating SQL or handling untrusted values
- [G158](rules/database-access.md#g158): scanning nullable database columns
- [G159](rules/database-access.md#g159): finishing a rows.Next loop

## Text and bytes

- [G75](rules/text-and-bytes.md#g75): processing text or binary data represented as a string
- [G76](rules/text-and-bytes.md#g76): iterating UTF-8 runes
- [G77](rules/text-and-bytes.md#g77): counting or indexing Unicode code points
- [G78](rules/text-and-bytes.md#g78): removing exact leading or trailing text
- [G79](rules/text-and-bytes.md#g79): concatenating many strings, especially in a loop
- [G80](rules/text-and-bytes.md#g80): writing through a strings.Builder
- [G81](rules/text-and-bytes.md#g81): a workflow starts and ends with byte slices
- [G82](rules/text-and-bytes.md#g82): slicing a string by textual position
- [G83](rules/text-and-bytes.md#g83): retaining a small substring of a large string

## Time and serialization

- [G146](rules/time-and-serialization.md#g146): supplying a duration
- [G147](rules/time-and-serialization.md#g147): a hot loop or frequently called handler needs timeout logic
- [G148](rules/time-and-serialization.md#g148): a long-running timer consumer can terminate
- [G149](rules/time-and-serialization.md#g149): a serialized struct embeds a type with custom JSON methods
- [G150](rules/time-and-serialization.md#g150): comparing times after JSON round trips
- [G151](rules/time-and-serialization.md#g151): output must use a consistent time zone
- [G152](rules/time-and-serialization.md#g152): measuring elapsed time
- [G153](rules/time-and-serialization.md#g153): decoding JSON into map[string]any
- [G259](rules/time-and-serialization.md#g259): choosing omission rules for JSON fields
- [G260](rules/time-and-serialization.md#g260): migrating JSON implementations or upgrading to Go 1.27

## Testing

- [G170](rules/testing.md#g170): organizing a testing strategy
- [G171](rules/testing.md#g171): a whole test file belongs to an optional category
- [G172](rules/testing.md#g172): individual optional tests should report why they did not run
- [G173](rules/testing.md#g173): some tests are slow even within a category
- [G174](rules/testing.md#g174): testing concurrent code
- [G175](rules/testing.md#g175): a concurrency test only occasionally exercises the relevant schedule
- [G176](rules/testing.md#g176): independent tests spend meaningful time running
- [G177](rules/testing.md#g177): checking test isolation
- [G178](rules/testing.md#g178): many cases use the same assertion structure
- [G179](rules/testing.md#g179): parallel table subtests capture iteration variables
- [G180](rules/testing.md#g180): testing asynchronous completion
- [G181](rules/testing.md#g181): synchronization is truly unavailable in an asynchronous test
- [G182](rules/testing.md#g182): testing behavior based on current time
- [G183](rules/testing.md#g183): the API can naturally accept a time boundary
- [G184](rules/testing.md#g184): testing HTTP handler behavior
- [G185](rules/testing.md#g185): testing an HTTP client
- [G186](rules/testing.md#g186): implementing a custom reader
- [G187](rules/testing.md#g187): testing I/O consumers against partial reads and failures
- [G192](rules/testing.md#g192): identifying untested behavior
- [G193](rules/testing.md#g193): tests should constrain public behavior rather than implementation
- [G194](rules/testing.md#g194): repeated test setup can fail
- [G195](rules/testing.md#g195): test helpers acquire resources
- [G196](rules/testing.md#g196): a package needs shared expensive environment setup
- [G255](rules/testing.md#g255): testing input parsers or transformations with broad input domains
- [G256](rules/testing.md#g256): integration execution needs coverage evidence
- [G257](rules/testing.md#g257): testing concurrent time-based behavior on Go 1.25+
- [G258](rules/testing.md#g258): a test changes process-wide state or allocates lifecycle resources

## Benchmarking

- [G188](rules/benchmarking.md#g188): benchmark setup is outside the work being measured
- [G189](rules/benchmarking.md#g189): interpreting small benchmark differences
- [G190](rules/benchmarking.md#g190): a benchmark calls a pure function whose result is unused
- [G191](rules/benchmarking.md#g191): repeated benchmark iterations reuse input data

## Performance and diagnostics

- [G199](rules/performance-and-diagnostics.md#g199): optimizing data-heavy loops
- [G200](rules/performance-and-diagnostics.md#g200): hot code scans only a subset of record fields
- [G201](rules/performance-and-diagnostics.md#g201): choosing data structures for hot traversal
- [G202](rules/performance-and-diagnostics.md#g202): a hot strided access pattern has unexpected cache misses
- [G203](rules/performance-and-diagnostics.md#g203): independent concurrent writers update nearby fields
- [G204](rules/performance-and-diagnostics.md#g204): a measured CPU-bound loop has dependent operations
- [G205](rules/performance-and-diagnostics.md#g205): many copies of a struct consume substantial memory
- [G206](rules/performance-and-diagnostics.md#g206): choosing values versus pointers for performance
- [G207](rules/performance-and-diagnostics.md#g207): measuring allocation-sensitive work
- [G208](rules/performance-and-diagnostics.md#g208): a change may make objects escape
- [G209](rules/performance-and-diagnostics.md#g209): a hot API produces buffers repeatedly
- [G210](rules/performance-and-diagnostics.md#g210): using byte data to look up string-keyed maps
- [G211](rules/performance-and-diagnostics.md#g211): a profile shows repeated allocations of interchangeable temporary objects
- [G212](rules/performance-and-diagnostics.md#g212): designing pooled buffer ownership
- [G213](rules/performance-and-diagnostics.md#g213): a frequently used function has a tiny fast path and complex slow path
- [G214](rules/performance-and-diagnostics.md#g214): diagnosing performance rather than guessing
- [G215](rules/performance-and-diagnostics.md#g215): cPU time is the suspected bottleneck
- [G216](rules/performance-and-diagnostics.md#g216): analyzing memory cost
- [G217](rules/performance-and-diagnostics.md#g217): investigating a suspected memory leak
- [G218](rules/performance-and-diagnostics.md#g218): investigating leaked or stuck goroutines
- [G219](rules/performance-and-diagnostics.md#g219): synchronization appears to limit throughput
- [G220](rules/performance-and-diagnostics.md#g220): collecting multiple diagnostic signals
- [G221](rules/performance-and-diagnostics.md#g221): understanding scheduling, GC pauses, or poor parallelism
- [G222](rules/performance-and-diagnostics.md#g222): trace data needs application-level meaning
- [G223](rules/performance-and-diagnostics.md#g223): gC cost appears significant
- [G224](rules/performance-and-diagnostics.md#g224): balancing memory use against GC CPU and latency
- [G225](rules/performance-and-diagnostics.md#g225): memory remains after a temporary allocation peak
- [G226](rules/performance-and-diagnostics.md#g226): evaluating the book's exceptional burst workaround
- [G227](rules/performance-and-diagnostics.md#g227): deploying Go under container CPU quotas
- [G228](rules/performance-and-diagnostics.md#g228): the runtime does not derive execution capacity from the container quota
- [G234](rules/performance-and-diagnostics.md#g234): the same function serves several workloads
- [G235](rules/performance-and-diagnostics.md#g235): enabling production diagnostics
- [G236](rules/performance-and-diagnostics.md#g236): cPU profiles show allocation, synchronization or syscall overhead
- [G237](rules/performance-and-diagnostics.md#g237): built-in profiles do not cover a resource of interest
- [G267](rules/performance-and-diagnostics.md#g267): considering GC-triggered cleanup or weak references
- [G268](rules/performance-and-diagnostics.md#g268): diagnosing suspected goroutine leaks on Go 1.26+
- [G269](rules/performance-and-diagnostics.md#g269): considering PGO or comparing performance after a Go upgrade
- [G270](rules/performance-and-diagnostics.md#g270): rare production events need execution-trace evidence
- [G271](rules/performance-and-diagnostics.md#g271): using unsafe, assembly, cgo pointers or runtime representation assumptions

## Versions and tooling

- [G241](rules/versions-and-tooling.md#g241): building, reviewing or upgrading a Go module
- [G242](rules/versions-and-tooling.md#g242): upgrading a runtime or changing GODEBUG settings
- [G243](rules/versions-and-tooling.md#g243): modernizing Go source or verification tooling
- [G244](rules/versions-and-tooling.md#g244): installing tools or updating module dependencies
- [G245](rules/versions-and-tooling.md#g245): working in a multi-module checkout
- [G246](rules/versions-and-tooling.md#g246): building for different operating systems, CPU levels or cgo environments
- [G247](rules/versions-and-tooling.md#g247): using experimental Go features
- [G277](rules/versions-and-tooling.md#g277): maintaining Go syntax/type/binary inspection tools

## Security and compatibility

- [G254](rules/security-and-compatibility.md#g254): code needs reproducible noncryptographic randomness, including production simulations, sampling, replay or tests
- [G273](rules/security-and-compatibility.md#g273): generating security-sensitive randomness
- [G274](rules/security-and-compatibility.md#g274): maintaining cryptographic protocol or primitive choices
- [G275](rules/security-and-compatibility.md#g275): upgrading TLS or certificate handling
- [G276](rules/security-and-compatibility.md#g276): tests or integrations compare exact standard-library output
