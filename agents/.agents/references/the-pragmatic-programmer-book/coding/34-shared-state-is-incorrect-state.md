## 34. Shared State Is Incorrect State

Concurrent code becomes incorrect when multiple executions make decisions from the same mutable resource: each can read a valid value that becomes stale before the update, so a read-check-write sequence is unsafe unless it is atomic. Treat mutable memory, files, databases, external services, and process-wide settings such as the current directory as shared state whenever multiple code paths can access them at the same time; random, irreproducible failures often expose these races. Protect complete operations with a mutex, semaphore, or monitor and guarantee release on every path, but prefer resource APIs that own synchronization and combine validation with mutation in one transactional call because caller-managed locking depends on every caller following the same convention. When an operation spans resources, model the combined result as one transaction or composite resource that either fully succeeds or fails without retaining partial acquisitions, and reduce the risk further through exclusive ownership or immutable data.

### The Pragmatic Approach

- Identify every mutable resource that concurrent executions can share, including memory, files, databases, external services, and process-wide settings.
- Replace separate check-then-act calls with one atomic operation. For example, use `take_if_available()` instead of calling `count()` and then `take()`.
- Put synchronization inside the resource API so callers cannot bypass the protection accidentally.
- Lock before reading the decision-making state, keep the lock through every dependent update, and unlock only after the operation reaches a consistent state.
- Release locks with an `ensure`, `finally`, scoped guard, or synchronization helper so exceptions cannot leave the resource permanently locked.
- Enforce one locking convention across every access path when the resource cannot encapsulate its own synchronization, and audit new paths for compliance.
- Represent a multi-resource request as one composite transaction. Acquire all required components and publish the result only when every acquisition succeeds.
- Roll back every partial acquisition when a combined operation fails, and centralize that cleanup so business logic remains readable.
- Investigate intermittent failures as potential concurrency defects, especially when parallel work changes files, directories, or other implicit global state.
- Prefer designs that avoid shared mutable state through exclusive ownership or immutability when the language and problem permit it.
