## 34. Shared State Is Incorrect State

When concurrent code shares a mutable resource, each participant can make a decision from a value that becomes stale before the update, so separately reasonable checks and writes combine into races, overselling, overdrawing, or random failures. Shared resources include memory, files, databases, external services, and process-wide settings such as the current working directory. Mutual exclusion can make a check-and-update sequence atomic, but it works only when every access honors the same lock and always releases it, including after an exception. Encapsulating synchronization inside a transactional resource interface protects invariants more reliably than requiring callers to manage locks. Operations spanning multiple resources must succeed or fail as one unit, return anything acquired if a later step fails, and hide that coordination behind a composite resource or generic transaction interface. Ownership rules and immutable data reduce accidental sharing, but mutable boundaries remain difficult, so the safest design avoids shared mutable state when possible.

### The Pragmatic Approach

- Identify every mutable resource that concurrent code can access, including files, services, databases, and process-wide settings.
- Combine each check, decision, and update into one atomic operation; never act on an unprotected snapshot of mutable state.
- Encapsulate locking and invariant enforcement inside the resource's interface instead of relying on every caller to follow a convention.
- Protect critical sections with mutual exclusion and guarantee release through exception-safe cleanup or a library-provided protection construct.
- Model operations involving multiple resources as a composite resource or transaction; hide acquisition and rollback housekeeping behind its interface, succeed only when the whole operation succeeds, and return every partial acquisition after any failure.
- Investigate intermittent, location-dependent, or seemingly random failures as possible concurrency defects.
- Prefer ownership controls and immutable data, and avoid shared mutable state whenever the design permits.
