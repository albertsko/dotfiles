## 28. Decoupling

Coupling makes software harder to change because components that share knowledge, state, or behavior must change together, and transitive dependencies spread the impact beyond direct connections. Train-wreck call chains couple callers to several levels of object structure; prefer encapsulated operations that tell an object what outcome to perform instead of reading its state, deciding elsewhere, and writing the state back. Global data, including singletons and mutable external resources such as databases, file systems, and service APIs, implicitly couples every consumer to shared implementation and state, while subclassing couples classes through inherited state and behavior. Keep components shy by making them interact through direct, stable interfaces; accept explicit data compatibility in transformation pipelines when it avoids reliance on hidden implementation details.

### The Pragmatic Approach

- Minimize every component's direct dependencies, and account for the indirect dependencies reached through them.
- Replace call chains that traverse application internals with operations that express intent. For example, replace `customer.orders.find(orderId).getTotals().applyDiscount(discount)` with `customer.findOrder(orderId).applyDiscount(discount)`.
- Tell an object what to do instead of reading its state, making a decision elsewhere, and updating the object. Put discount limits inside the object that manages order totals so every caller follows the same rule.
- Treat multiple member-access hops as a coupling warning, even when intermediate variables hide the chain. Assume application and third-party interfaces can change; allow chains only across interfaces stable enough to justify the dependency, such as long-established language-library operations.
- Use Tell, Don't Ask as a diagnostic, not a rigid law. Expose domain concepts that have an independent identity through deliberate APIs instead of forcing all behavior through an enclosing object.
- Compose transformation pipelines around explicit input and output formats. Keep each stage independent of the hidden implementation of adjacent stages.
- Remove global data from application logic. Treat each global as an implicit input to every method that can reach it, and pass required state through explicit interfaces so code can be extracted and tested without recreating a global environment.
- Treat singleton state and globally accessible modules as global data, even when methods hide their fields. Use an API to isolate representation changes, but do not mistake encapsulation for removal of shared state.
- Wrap databases, data stores, file systems, and service APIs behind code you control so resource changes do not propagate through every consumer.
- Count inherited state and behavior as coupling before subclassing. Avoid the hierarchy when parent and child must be able to change independently.
- Investigate coupling when a small change breaks unrelated modules, tests require extensive global setup, developers fear unknown side effects, or every change requires broad coordination.
