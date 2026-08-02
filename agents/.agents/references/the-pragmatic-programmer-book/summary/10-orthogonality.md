## 10. Orthogonality

Orthogonality is independence among components: changing one does not force unrelated changes elsewhere, so each component has a single, well-defined purpose and interacts through limited, stable interfaces. Orthogonal systems localize development and testing, support reuse and flexible recombination, reduce fragility and vendor or platform dependence, and contain defects; nonorthogonal systems make each adjustment trigger compensating changes throughout the system. Combining orthogonal components multiplies their capabilities instead of losing functionality to overlap, yielding more functionality per unit effort. Orthogonality reduces interdependency, while the Don't Repeat Yourself principle reduces duplicated knowledge; applying both makes systems more flexible, understandable, testable, debuggable, and maintainable. Build orthogonality through modular, layered designs; isolation from third-party details and uncontrolled external identifiers; decoupled code that avoids global state, singleton-based globals, duplicated knowledge, and families of similar functions; focused unit tests that expose excessive dependencies; and documentation that separates content from presentation.

### The Pragmatic Approach

- Divide the system into cohesive modules with one well-defined responsibility and stable external interfaces.
- Test the design by asking how many modules each functional requirement change affects, and aim to confine each functional change to one module.
- Organize components into layers that depend only on the abstractions provided below them.
- Reject or isolate toolkits and libraries that force unrelated code changes or special object construction and access patterns; keep vendor, platform, persistence, and transaction details behind narrow interfaces.
- Add behavior without changing core application code when possible, using declarative configuration or disciplined composition.
- Do not rely on properties you cannot control; in particular, avoid using changeable real-world data, such as phone numbers or email addresses, as stable identifiers.
- Keep code shy: reveal no unnecessary details and do not depend on other modules' implementations. Pass required context explicitly, ask objects to manage their own state, and avoid global data and singletons used as globals; even read-only globals create coupling and can obstruct later changes such as multithreading.
- Extract shared structure from similar functions, vary their algorithms independently, and refactor whenever changes begin to ripple.
- Use unit-test setup and the spread of bug-fix edits as coupling diagnostics, and automate focused tests in the regular build. Tag tested bug fixes in version control and track how many source files each fix affects over time.
- Separate documentation content from presentation with markup, styles, or equivalent mechanisms.
