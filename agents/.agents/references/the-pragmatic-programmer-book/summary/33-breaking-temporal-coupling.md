## 33. Breaking Temporal Coupling

Temporal coupling arises when software unnecessarily requires operations to occur in a fixed order or one at a time. Treat time as a design element by separating genuine ordering constraints from work that can proceed concurrently, then use concurrency to stay productive during waits and parallelism to distribute independent, processor-intensive work across available hardware. Workflow analysis can expose hidden opportunities, but the design must account for resource limits and safe synchronization to produce systems that are more flexible, responsive, reliable, and easier to reason about.

### The Pragmatic Approach

- Map each workflow and distinguish required ordering from activities that can begin or proceed concurrently.
- Remove time and order dependencies that exist only because the original design was linear.
- Overlap useful work with waits for databases, external services, user input, files, or external programs.
- Split independent, processor-intensive work into chunks, process the chunks in parallel, and combine the results.
- Preserve genuine dependencies and synchronize only where downstream work requires completed inputs.
- Evaluate whether available people, resources, and processors make each concurrency opportunity worthwhile.
- Test concurrent execution carefully for coordination errors.
