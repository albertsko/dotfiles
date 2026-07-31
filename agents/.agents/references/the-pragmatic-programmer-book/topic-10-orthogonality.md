## Topic 10: Orthogonality

Orthogonality signifies independence and decoupling between software components. Two components are orthogonal if changes to one do not affect the other. Designing orthogonal systems increases productivity and reduces risk by isolating changes, facilitating component reuse, limiting bug spread, and enabling modular testing.

### The Pragmatic Approach

- **Design modular abstractions**: Divide systems into isolated layers or independent modules so that changing a requirement affects only a single component.
- **Isolate external dependencies**: Keep third-party toolkits, frameworks, and persistence mechanisms decoupled from core application logic.
- **Write shy, decoupled code**: Expose minimal implementation details and explicitly pass required context to modules instead of accessing global state.
- **Avoid uncontrollable external data**: Refrain from using external identifiers, such as phone numbers or postal codes, as core system keys.
- **Automate unit testing**: Use unit tests to verify component isolation. Difficulty in testing a module signals unwanted coupling.
- **Separate content from presentation**: Apply orthogonal principles to documentation by separating raw text from output formatting.

### Common Mistakes

- **Coupling control paths**: Building systems where every control input or modification creates side effects in unrelated modules.
- **Relying on global data or singletons**: Sharing global state across modules, which creates hidden linkages and complicates concurrency.
- **Duplicating function structures**: Writing functions with identical control flows and minor algorithmic differences rather than abstracting common logic.
- **Leaking framework requirements**: Allowing third-party libraries to dictate domain model design or object access methods.
