## Topic 34: Shared State Is Incorrect State

Shared mutable state causes concurrency bugs because no process can guarantee its local view of memory remains consistent. When multiple threads or processes fetch and update shared data nonatomically, intermediate changes create invalid application states and unpredictable race conditions. Concurrency issues extend beyond shared memory to any shared mutable resource, including files, databases, and working directories.

### The Pragmatic Approach

- Centralize concurrency protection inside resources using atomic transactional operations rather than relying on caller discipline.
- Use mutual exclusion mechanisms like semaphores or mutexes, ensuring code releases locks inside cleanup blocks (`ensure` or `finally`) when exceptions occur.
- Wrap multi-resource transactions into dedicated composite abstractions to prevent partial allocations and messy failure handling.
- Treat sporadic, non-deterministic runtime failures as potential concurrency issues.
- Avoid shared mutable state entirely by using immutable data or isolated ownership patterns.

### Common Mistakes

- Delegating locking responsibility to external callers, which fails as soon as one caller omits the lock convention.
- Forgetting exception handling during lock execution, leaving semaphores locked permanently when an operation throws an error.
- Splitting resource checks and modifications into separate non-atomic calls, allowing state to change between checking and updating.
- Holding onto partial resources after a subsequent resource acquisition fails, leaving dependent systems in an inconsistent state.
- Mutating shared process-level state, such as changing the current working directory, in multithreaded environments.
