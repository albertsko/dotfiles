# Strategic programming

Architecture: boundaries, dependencies, knowledge ownership, and the cost of changing decisions.

## Boundaries and coupling

Give each module a cohesive responsibility and a narrow interface. Keep rules near the state they govern. Pass needed context explicitly.

When one functional change touches unrelated modules, inspect the coupling. Hide internal representations that callers need not know. Prefer operations expressing intent over callers traversing internals and coordinating another module's state.

Keep domain rules separate from infrastructure when infrastructure details would otherwise drive domain changes. Shared mutable state creates hidden dependencies. Prefer clear ownership and explicit data flow.

## Knowledge ownership

Centralize a rule when one change must be repeated across several representations. Compute derived values from authoritative data. When parallel boundary artifacts drift, consider generating them from a shared schema.

Duplicate text is not necessarily duplicate knowledge. Keep independently owned business rules separate when they merely coincide today. Two policies with the same threshold need separate ownership if either can change independently. Unify code when its intent and reasons for change are shared.

## Reversibility and abstractions

When future needs are unclear, keep concrete code replaceable instead of guessing a framework. Prefer deletion or a direct implementation when indirection adds no useful boundary.

A new abstraction earns its cost through an observed need: repeated change, unrelated code affected by a dependency, or actual variants sharing a contract. Reuse an existing abstraction when it fits that need.

For a single provider, a direct integration can be sufficient. Introduce a narrow interface you own when vendor details spread, replacement becomes a real requirement, or a useful testing boundary needs isolation. Match the interface to current operations.

Before committing to a costly technical choice, consider a plausible alternative and the effort to switch. Keep deployment choices separate from component responsibilities when they may change independently.

Prefer composition or delegation when sharing capabilities. Use inheritance when the subtype relationship and inherited contract fit. Configure values that vary by environment or customer. Resolve product decisions directly instead of creating settings for hypothetical variability.
