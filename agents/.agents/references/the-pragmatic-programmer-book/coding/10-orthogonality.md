## 10. Orthogonality

Orthogonality is the independence of components: changing one concern should not force changes in unrelated concerns. Build cohesive, self-contained modules with one well-defined responsibility and a stable interface so user interfaces, business rules, storage, and external services can evolve independently. Localized changes shorten development and testing, improve reuse and fault isolation, make systems easier to extend and maintain, and reduce fragility and dependence on a vendor, product, or platform.

### The Pragmatic Approach

- Give each component one well-defined responsibility, hide its implementation, and expose only the stable interface collaborators need.
- Keep components small enough to design, build, and test in isolation, then leave them unchanged when adding unrelated functionality.
- Test a design by imagining a dramatic requirement change and counting the affected modules. Restructure the design when one functional change spreads beyond the module responsible for that function.
- Separate concerns into layers and make each layer depend on abstractions rather than implementation details. For example, let web and mobile interfaces call the same application logic instead of embedding business rules in either interface.
- Combine independent components to multiply useful behavior without duplicating effort or creating overlap between their responsibilities.
- Isolate third-party libraries, persistence frameworks, vendors, and platforms behind application-owned interfaces. Keep framework-specific object creation, access patterns, and conventions from spreading through application code.
- Prefer declarative configuration or composition when adding behavior without changing the code that performs the underlying work.
- Pass required context explicitly through parameters or constructors. Avoid global data, including read-only globals, and singleton objects used as globals because every consumer becomes coupled to shared state, lifecycle assumptions, and possible concurrency constraints.
- Ask an object to perform its own state changes instead of reading its internals and changing them elsewhere.
- Replace families of similar functions with a shared workflow and a replaceable algorithm. Do not copy common setup and cleanup around several slightly different implementations.
- Check the wider codebase while coding, and refactor duplicated functionality or knowledge that weakens component boundaries.
- Use stable internal identifiers instead of treating phone numbers, email addresses, postal codes, domains, or government identifiers as permanent identities.
- Use unit-test setup as a coupling diagnostic. If testing one module requires importing or initializing a large part of the system, narrow the module's dependencies and formalize its boundaries.
- Automate component tests in the regular build so independent behavior remains verifiable as implementations change.
- Inspect every bug fix for change scatter. Refactor when a local defect requires edits across unrelated modules or when one fix creates secondary failures elsewhere.
- Track how many files each bug fix changes so trends expose deteriorating component boundaries.
- Keep content separate from presentation in generated documentation and other rendered outputs so either can change independently.
