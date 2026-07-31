## Topic 26: How to Balance Resources

Resource management follows a standard cycle: allocate the resource, use the resource, and deallocate the resource. Developers must manage resources explicitly to prevent memory leaks, open handles, deadlocks, and system crashes.

### The Pragmatic Approach

Pragmatic developers apply consistent patterns to maintain resource equilibrium across applications.

- **Finish What You Start**: Ensure the function or object that allocates a resource also deallocates that resource.
- **Act Locally**: Reduce resource scope by binding resource lifetimes to code blocks or stack variables. Modern languages support block-scoped allocations and automatic destruction.
- **Nest Allocations Systematically**:
  - Deallocate multiple resources in the reverse order of their allocation to prevent orphaned references.
  - Allocate identical resource sets in the exact same sequence across different code paths to avoid deadlocks.
- **Handle Exceptions Safely**: Allocate resources before entering a guarded block, then release resources inside a `finally` clause or rely on language-level stack unwinding.
- **Define Ownership Invariants**: Establish clear semantic rules for dynamic data structures. Specify whether container objects recursively free sub-components, orphan child references, or reject deletion when non-empty.
- **Verify Resource Balance**: Wrap resource managers to track active allocations and monitor memory usage at key execution loop boundaries. Balance long-term resources such as log files and database debug records.

### Common Mistakes

Unbalanced resource management leads to leaks and unexpected runtime failures.

- **Coupling Allocation Across Functions**: Opening a resource in one routine and relying on a separate routine to close the resource creates tight coupling and silent leaks.
- **Placing Allocations Inside Try Blocks**: Placing resource allocation inside a `try` block causes `finally` handlers to attempt cleanup on invalid handles when allocation fails.
- **Neglecting Unhandled Execution Paths**: Adding conditional logic without ensuring all code paths release allocated resources causes resource exhaustion over time.
- **Inconsistent Allocation Orders**: Claiming multiple resources in varying sequences across concurrent routines leads to deadlock conditions.
