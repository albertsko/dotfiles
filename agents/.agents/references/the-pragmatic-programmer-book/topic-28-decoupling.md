## Topic 28: Decoupling

Decoupled software components operate independently, allowing developers to change individual modules without breaking unrelated parts of the system. Coupling links components together, making software rigid and difficult to modify. Because coupling is transitive, a component implicitly depends on all downstream dependencies of its direct partners. Decoupling minimizes shared knowledge between components, ensuring that code changes remain localized.

### The Pragmatic Approach

- Follow the Tell, Don't Ask principle. Delegate operations to the object holding the relevant data instead of fetching state and executing logic externally.
- Limit method chaining. Avoid navigating deep object hierarchies with multiple dot calls. Keep method calls to a single level for application objects.
- Wrap shared resources in APIs. Encapsulate global state, singletons, and external infrastructure such as databases and remote services behind controlled application interfaces.
- Distinguish data pipelines from object method chains. Composing functions into data transformation pipelines does not introduce object coupling because pipelines transform data structures without depending on hidden object implementations.

### Common Mistakes

- Navigating intermediate objects in method chains. Writing call chains like `customer.orders.find(id).getTotals().amount` leaks implementation details and couples callers to internal data structures.
- Exposing mutable global data. Using global variables, shared singleton state, or raw external resources creates hidden dependencies across every module and complicates unit testing.
- Querying object state to make decisions. Inspecting internal fields of an object to perform actions on its behalf breaks encapsulation and duplicates business logic.
- Applying decoupling rules dogmatically. Hiding core domain abstractions unnecessarily or applying method-chaining restrictions to stable standard language libraries adds complexity without benefit.
