## Topic 11: Reversibility

Software requirements, business goals, and technologies change constantly over time. Critical architectural or vendor decisions lock projects into rigid paths that become expensive to undo. Pragmatic programmers treat decisions as temporary choices written in sand rather than permanent rules carved in stone.

### The Pragmatic Approach

- **Hide third-party dependencies:** Wrap external APIs and database calls behind internal abstraction layers so changing vendor software requires replacing only the interface implementation.
- **Maintain architectural flexibility:** Decouple software components to support different deployment models, such as running services on a single server, inside containers, or across cloud infrastructure.
- **Treat decisions as reversible:** Avoid locking into a single technology early in development. Assume any decision may change as project requirements evolve.
- **Avoid technology fads:** Evaluate tools based on current project needs rather than popularity or industry trends.

### Common Mistakes

- **Carving decisions in stone:** Assuming early architectural, vendor, or database choices are permanent.
- **Coupling code directly to third-party APIs:** Scattering direct calls to vendor libraries throughout the codebase, making replacement difficult and costly.
- **Following architectural fads:** Adopting trendy server or framework paradigms without evaluating their long-term stability or relevance to project requirements.
- **Assuming singular solutions exist:** Believing there is only one correct way to build a system, leaving the team unprepared when constraints change.
