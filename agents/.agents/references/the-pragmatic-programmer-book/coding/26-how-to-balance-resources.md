## 26. How to Balance Resources

Balance every finite resource, including memory, transactions, threads, network connections, files, and timers, by giving the code that allocates it responsibility for releasing it. Keep ownership and lifetime local and visible, preferably through a scope-bound block or resource-owning object that releases the resource on normal exit, early return, or exception. Apply the same discipline to nested resources, long-lived artifacts such as logs, and aggregate data structures by defining explicit ownership rules, consistent allocation order, reverse deallocation order, and checks that expose leaks.

### The Pragmatic Approach

- Make the function or object that allocates a resource release it; pass the resource to helper functions instead of hiding ownership in shared state.
- Reduce resource scope to the smallest block that needs it, and use language constructs that close or release it automatically when the block ends.
- Protect cleanup from exceptions. Allocate the resource before entering a `try` block, then release it in `finally`, so failed allocation never triggers cleanup of an uninitialized value.
- Acquire multiple resources in the same order everywhere to reduce deadlock risk, and release them in reverse order so dependent resources are not orphaned.
- Define and enforce one ownership rule for aggregate data structures: recursively free contained data, leave independently owned data intact, or refuse deletion while children remain.
- Encapsulate complex resource types behind modules or classes that provide consistent allocation, deallocation, traversal, serialization, and diagnostic operations.
- Balance resources over time. Rotate and delete logs, expire database records, and clean up debug artifacts before they exhaust finite storage.
- Wrap resource operations to count allocations and releases, assert expected usage at stable points such as the top of a request loop, and use leak-detection tools to verify the balance during execution.
