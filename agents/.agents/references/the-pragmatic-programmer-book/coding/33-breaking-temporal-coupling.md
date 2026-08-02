## 33. Breaking Temporal Coupling

Temporal coupling forces operations into a fixed order or makes unrelated work wait even when correctness requires neither constraint. Treat time as a design element by distinguishing genuine ordering dependencies from work that can proceed concurrently, especially while the program waits for a database, external service, file operation, or user input. Use concurrency to let multiple activities make progress during overlapping periods, and use parallelism to run independent chunks simultaneously across multiple processors before combining their results. Removing unnecessary time dependencies makes systems more flexible, responsive, reliable, and easier to reason about, but every concurrent design must preserve the dependencies that correctness actually requires.

### The Pragmatic Approach

- Map each workflow as actions, prerequisite arrows, and synchronization points; allow actions with no prerequisites to start independently, and join branches only when downstream work needs every result.
- Challenge every sequence by asking whether correctness requires the order or whether habit made the design linear. For example, fetch independent customer and inventory data concurrently, then generate the response after both results arrive.
- Use waiting time productively. Start independent work while a database query, external service call, file operation, or user interaction is pending instead of blocking the entire workflow.
- Separate independent, processor-intensive work into chunks, run the chunks in parallel on available processors, and combine results as they complete. For example, convert unrelated formulas in parallel rather than one at a time.
- Keep real dependencies explicit. Pause only the work that needs an unfinished result while allowing unrelated work to continue, as a build can compile independent modules while a dependent module waits.
- Evaluate whether concurrency is worth implementing before adding it. Favor long waits and independent work, and account for the workers and processors required to execute the activities simultaneously.
- Exercise concurrent paths under different completion orders and verify the combined result, because removing ordering assumptions can expose concurrency errors that a linear execution concealed.
