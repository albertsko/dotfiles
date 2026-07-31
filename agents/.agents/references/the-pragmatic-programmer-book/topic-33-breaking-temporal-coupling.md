## Topic 33: Breaking Temporal Coupling

Temporal coupling occurs when software design imposes rigid time dependencies, forcing operations to execute in a strict linear sequence or wait unnecessarily. Traditional programming often assumes a step-by-step order: method A must run before method B, or the UI must wait for screen redraws. This linear thinking creates fragile, slow systems. Pragmatic programmers treat time as a first-class design element, focusing on concurrency (tasks executing during overlapping periods) and ordering (true step dependencies).

Analyzing workflows with tools like activity diagrams reveals which tasks require strict sequence and which can run simultaneously. Decoupling time dependencies allows software to remain responsive during blocking operations (such as database queries or network requests) and allows independent tasks to run across multiple hardware cores in parallel.

### The Pragmatic Approach

- **Analyze workflows for hidden concurrency**: Map business processes with activity diagrams to identify tasks that can start independently or run in parallel.
- **Exploit I/O stalls**: Design software to perform useful work while waiting for slow operations like disk access, network requests, or user input.
- **Decompose independent tasks for parallelism**: Divide large, independent workloads into chunks that execute simultaneously across multiple processor cores.
- **Decouple execution order from state**: Remove rigid caller sequencing requirements unless a genuine data dependency exists.

### Common Mistakes

- **Defaulting to linear execution**: Designing systems sequentially simply because human thinking is naturally linear.
- **Conflating concurrency with parallelism**: Treating software mechanisms for handling asynchronous work (concurrency) as identical to hardware capabilities for simultaneous execution (parallelism).
- **Coupling method calls in time**: Requiring caller code to invoke methods in a strict order when no true data dependency exists between them.
- **Idling during blocking operations**: Allowing the CPU to stall while waiting for external services, database queries, or I/O.
