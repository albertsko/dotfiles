## 33. Breaking Temporal Coupling

Temporal coupling forces operations into a fixed order or makes unrelated work wait even when correctness requires neither constraint. Treat time as a design element by distinguishing genuine ordering dependencies from work that can proceed concurrently, especially while the program waits for a database, external service, file operation, or user input. Concurrency lets activities make progress during overlapping periods, while parallelism uses multiple local or remote processors to execute independent work simultaneously; removing unnecessary time dependencies can make systems more flexible, responsive, reliable, and easier to reason about.

### The Pragmatic Approach

- Map each workflow as actions, prerequisite arrows, and synchronization points. Start actions with no prerequisites independently, and join branches only after all results required by downstream work are ready.
- Challenge every sequence by asking whether correctness requires the order or habit made the design linear. For example, fetch independent customer and inventory data concurrently, then generate the response after both results arrive.
- Use waiting time productively. Start independent work while a database query, external service call, file operation, or user interaction is pending instead of blocking the entire workflow.
- Run independent pipeline stages concurrently when each stage can consume the previous stage's output while producing input for the next.
- Split independent, processor-intensive work into chunks, run the chunks in parallel on available local or remote processors, and combine results as they become available. For example, convert unrelated formulas in parallel instead of one at a time.
- Keep real dependencies explicit. Pause only the work that needs an unfinished result while unrelated work continues, as a build can compile independent modules while a dependent module waits.
- Evaluate whether concurrency is worth implementing before adding it. Favor long waits and independent work, and account for the workers and processors required to execute activities simultaneously.
- Exercise concurrent paths under different completion orders and verify the combined result, because removing ordering assumptions can expose concurrency errors that linear execution concealed.
