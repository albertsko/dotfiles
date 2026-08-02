## 11. Reversibility

Requirements, infrastructure, vendor capabilities, and technology constraints change, so treat every technical decision as provisional and preserve affordable paths to alternatives. Reversible software isolates volatile choices behind stable interfaces, separates components, and moves environment-specific behavior into configuration so a database, client, deployment model, or vendor integration can change without forcing a system-wide rewrite. Architecture cannot predict every future, but it can limit the cost and reach of change.

### The Pragmatic Approach

- Identify decisions that would be expensive to undo, such as choosing a database, vendor service, architectural pattern, or deployment model, and design explicit replacement boundaries around them.
- Evaluate more than one viable implementation before committing, and record the constraints that justify the current choice so new evidence can trigger a review.
- Hide third-party application programming interfaces behind interfaces and adapters that your application owns. For example, make business logic call a persistence interface instead of a vendor-specific database client.
- Separate business logic from presentation, persistence, infrastructure, and deployment concerns. Let a new mobile client consume an application programming interface instead of requiring a rewrite of server-side behavior.
- Put environment-specific values and replaceable policies in external configuration rather than scattering them through code.
- Divide the system into cohesive components with explicit contracts so each component can change or move without dragging unrelated code with it.
- Centralize each volatile assumption so a change requires one focused edit instead of synchronized edits across the codebase.
- Test important alternatives at their riskiest boundaries. For example, benchmark persistence adapters with representative workloads before database performance becomes a late-stage constraint.
- Revisit major decisions when requirements, staffing, performance data, vendor ownership, or infrastructure changes invalidate their original constraints.
- Choose technology for demonstrated project needs, not popularity, and keep adoption costs proportional to the evidence supporting the choice.
