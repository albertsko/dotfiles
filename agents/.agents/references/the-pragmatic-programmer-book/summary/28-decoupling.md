## 28. Decoupling

Coupling makes software rigid by forcing connected components to change together, and transitive dependencies spread the impact into code that may appear unrelated. Decoupled software stays flexible by keeping each component “shy”: it deals only with things it directly knows through narrow interfaces. Long chains of method or property access expose hidden implementation layers, while Tell, Don’t Ask preserves encapsulation by placing decisions, validation, and state changes inside the object that owns the data. Data pipelines also couple adjacent functions through compatible formats, but they avoid dependence on hidden object structure and usually impede change less than chained traversal. Global mutable data, including singletons, modules, databases, file systems, and service APIs, secretly couples every user and makes code harder to extract and test; an API under your control can contain that dependency. Inheritance also couples subclasses to inherited state and behavior, so limiting all these dependencies reduces surprise breakage, fear of change, and unnecessary coordination.

### The Pragmatic Approach

- Minimize the components and implementation details that each unit knows about.
- Tell an object what result to produce instead of reading its internal state, deciding elsewhere, and writing the state back.
- Put business rules and validation beside the state they govern.
- Replace chains of method and property access with intention-revealing operations on responsible objects.
- Expose meaningful domain objects when they have an independent role; apply decoupling guidelines pragmatically instead of hiding every relationship.
- Chain calls only across interfaces that are genuinely stable, and treat application and third-party interfaces as likely to change.
- Prefer pipelines with explicit, compatible data formats over traversal through hidden object structure.
- Eliminate global mutable data, including disguised globals in singletons and modules.
- Wrap databases, file systems, services, and other shared external resources behind APIs that you control.
- Avoid inheritance when it would bind a subclass unnecessarily to another class’s state or behavior.
- Investigate unrelated dependencies, far-reaching changes, surprise breakage, fear of editing, and oversized coordination meetings as signs of excessive coupling.
