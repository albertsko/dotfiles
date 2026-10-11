# Shared state and synchronization

Load when: shared memory, happens-before, mutexes, snapshots, WaitGroup, Cond, errgroup or atomics

<a id="g133"></a>

- **G133** When formatting a context or object in concurrent code. Then Inspect what formatting traverses or calls, and prefer a stable explicit key over formatting mutable state. Mutable context values need their own synchronization. Because Formatting can read shared values and introduce data races.

  Sources: `BP133`.

<a id="g134"></a>

- **G134** When formatting an object while holding its lock. Then Avoid invoking a String method that reacquires the same lock. Format safe fields directly or narrow lock scope. Test error branches that trigger formatting. Formatting can call methods implicitly. Test error branches that perform the formatting, even when validation looks trivial. Because The indirect method call can deadlock.

  Sources: `BP134`.

<a id="g135"></a>

- **G135** When validation does not require shared mutable state. Then Validate before acquiring a mutex and keep critical sections focused. Validation that depends on protected state must remain synchronized. Because Avoids unnecessary locking and reduces indirect side effects.

  Sources: `BP135`.

<a id="g136"></a>

- **G136** When concurrent goroutines append from a shared slice. Then Isolate backing storage or synchronize instead of relying on current spare capacity. A full slice can allocate separate arrays, but this fragile condition should not dictate correctness. Shared headers and elements need separate analysis. Synchronize shared slice-header writes as well as backing-array writes. Because Append can mutate shared backing storage when capacity remains.

  Sources: `BP136`.

<a id="g137"></a>

- **G137** When partitioning concurrent collection access. Then Disjoint slice indexes may be handled independently, but synchronize concurrent map access involving writes. Pointer-referenced data or shared slice headers can reintroduce races. Different map keys do not provide isolation. Because Different slice cells are separate memory locations while map writes affect shared state.

  Sources: `BP137`.

<a id="g138"></a>

- **G138** When reading shared slices or maps under a mutex. Then Protect the entire use or copy actual elements while locked, then work on the snapshot. Snapshots cost memory and copying. For pointer elements, copy depth must match mutation needs. For light work, holding the lock may be simpler than making a snapshot. For expensive processing, copying can reduce lock contention. Because Assigning the slice or map only copies a descriptor and leaves shared storage.

  Sources: `BP138`.

<a id="g139"></a>

- **G139** When using WaitGroup with newly started goroutines. Then Register Add before launch and call Done on every worker exit, with consistent counts. On Go 1.25+, WaitGroup.Go combines registration and launch when its callback obeys the no-panic contract. When the group is empty, start work before Wait. Reuse only after the previous Wait returns. Wait joins work but does not itself cancel it. Because Wait may otherwise see zero and return before workers register.

  Sources: `BP139`, `RV395`, `RV435`.

  Example: [Cancellation and join](../../examples/lifecycle_test.go).

<a id="g140"></a>

- **G140** When many goroutines repeatedly wait for changing shared conditions. Then Consider sync.Cond instead of busy polling or assuming channel sends broadcast. Notifications are not queued for future waiters. Signal wakes one waiter. Channel closure broadcasts only once. One channel send reaches one receiver. The source's round-robin receiver distribution statement is not adopted as an ordering guarantee. Because Broadcast wakes all current waiters without a busy loop.

  Sources: `BP140`.

<a id="g141"></a>

- **G141** When waiting on a sync.Cond. Then Hold its lock, test the predicate in a loop, call Wait, and recheck after waking. Update the condition under the same lock and signal/broadcast as appropriate. Because Wait unlocks while waiting and relocks before returning, while state can change before the waiter runs.

  Sources: `BP141`.

<a id="g142"></a>

- **G142** When running several tasks with error propagation and cancellation. Then Use errgroup.WithContext, return errors from Go callbacks, and check Wait. Tasks must observe the derived context. Wait waits for all tasks, not merely the first failure. The group returns the first non-nil error rather than an aggregate. Cancellation is cooperative and Wait still joins every task. Because It coordinates completion and returns a failure while canceling shared work.

  Sources: `BP142`.

<a id="g143"></a>

- **G143** When concurrent tasks produce ordered independent results. Then Preallocate a results slice and assign each task its own index. Read results only after task completion and avoid shared element referents. Index/value capture still must follow the applicable loop semantics. Because Preserves input ordering without a separate reorder stage and avoids overlapping writes.

  Sources: `BP143`.

<a id="g144"></a>

- **G144** When passing, returning, or calling methods on synchronization-containing values. Then Share the same synchronization instance and avoid copying active Mutex, RWMutex, Cond, Map, Once, Pool or WaitGroup values. Inspect assignments, arguments, returns and receivers, including structs that contain them. Use initialized pointers where appropriate. Go 1.22 three-clause loops can implicitly copy newly declared variables each iteration, so keep no-copy state outside the loop. Because Copies create unrelated locks or corrupt coordination expectations.

  Sources: `BP144`, `RV239`, `RV336`.

<a id="g145"></a>

- **G145** When reviewing code that uses sync types. Then Run go vet and inspect value receivers and arguments for accidental copies. Covers Mutex, RWMutex, Cond, Map, Once, Pool, and WaitGroup as discussed. Because Copies can be hidden inside enclosing structs.

  Sources: `BP145`.

<a id="g251"></a>

- **G251** When representing independently atomic shared state. Then Consider Go 1.19+ typed atomics, including atomic.Pointer[T], and retain sequentially consistent synchronization reasoning. Typed Int64/Uint64 supply needed 64-bit alignment on 32-bit targets. Go 1.23 adds atomic And/Or. Keep compound invariants under a suitable lock or protocol. TryLock availability from Go 1.18 does not justify busy polling. Because Atomic access is not whole-algorithm correctness or a substitute for ownership.

  Sources: `RV58`, `RV66`, `RV77`, `RV320`.
