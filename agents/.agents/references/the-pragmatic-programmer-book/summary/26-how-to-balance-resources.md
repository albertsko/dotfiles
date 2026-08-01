## 26. How to Balance Resources

Resource use stays balanced when the code that allocates a finite resource also guarantees its deallocation, keeping ownership and lifetime local, visible, and resistant to skipped paths. Scope-bound blocks, resource-wrapping objects, and `finally` clauses can guarantee cleanup after normal exits or exceptions, but allocation must occur before the protected block so failed allocation does not trigger deallocation of a nonexistent resource. When code needs several resources, it should acquire the same sets in a consistent order and release them in reverse order to prevent deadlocks and orphaned dependencies. Long-lived artifacts such as logs and aggregate data structures also need explicit, consistently enforced cleanup and ownership policies, while wrappers, state checks, and leak-detection tools verify that resource use returns to its expected level.

### The Pragmatic Approach

- Make the function or object that allocates a resource responsible for releasing it.
- Keep resource lifetimes narrow, pass resource handles explicitly, and use scope-bound cleanup when the language provides it.
- Allocate a resource before entering a protected block, then release it in a `finally` clause when scope-based cleanup is unavailable.
- Acquire shared resource sets in a consistent order and release nested resources in reverse order.
- Define and enforce who owns and frees every aggregate structure and each structure it contains.
- Rotate or expire logs, debug files, database records, and other persistent artifacts that consume finite capacity.
- Wrap resource operations, check allocation counts at stable execution points, and use leak-detection tools to confirm that cleanup succeeds.
