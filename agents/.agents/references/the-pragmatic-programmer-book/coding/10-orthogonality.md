## 10. Orthogonality

Orthogonality is the independence of components: changing one concern should not force changes in unrelated concerns. Build cohesive modules with one well-defined responsibility and a stable interface so user interfaces, business rules, storage, and external services can evolve independently. Localized changes improve development speed, testing, reuse, and fault isolation while reducing fragility and dependence on a vendor, product, or platform.

### The Pragmatic Approach

- Give each component one well-defined responsibility, hide its implementation, and expose only the interface collaborators need.
- Test a design by imagining a dramatic requirement change and counting the affected modules. Restructure the design when one functional change spreads beyond the module responsible for that function.
- Separate concerns into layers and make each layer depend on abstractions rather than implementation details. For example, let both web and mobile interfaces call the same application logic instead of embedding business rules in either interface.
- Isolate third-party libraries, persistence frameworks, vendors, and platforms behind application-owned interfaces. Keep framework-specific object creation, annotations, and access patterns from spreading through domain code.
- Pass required context explicitly through parameters or constructors. Avoid global data and singleton objects used as globals because every consumer becomes coupled to shared state and lifecycle assumptions.
- Ask an object to perform its own state changes instead of reading its internals and changing them elsewhere.
- Replace families of similar functions with a shared workflow and a replaceable algorithm. Do not copy common setup and cleanup around several slightly different implementations.
- Use stable internal identifiers instead of treating phone numbers, email addresses, postal codes, domains, or government identifiers as permanent identities.
- Use unit-test setup as a coupling diagnostic. If testing one module requires importing or initializing a large part of the system, narrow the module's dependencies and formalize its boundaries.
- Automate component tests in the regular build so independent behavior remains verifiable as implementations change.
- Inspect every bug fix for change scatter. Refactor when a local defect requires edits across unrelated modules or when one fix creates secondary failures elsewhere.
- Keep content separate from presentation in generated documentation and other rendered outputs so either can change independently.
