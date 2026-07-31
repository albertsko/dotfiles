## Topic 8: The Essence of Good Design

Good design makes software easier to change (ETC). Software designs succeed when they adapt to changing user requirements, making ease of change the foundational principle behind all effective software design practices like decoupling, single responsibility, and clear naming.

### The Pragmatic Approach

- Treat ETC as a guiding value rather than a rigid rule to evaluate daily design choices.
- Ask whether recent changes make the overall system easier or harder to modify after writing tests, fixing bugs, or saving code.
- Write replaceable code with high cohesion and low coupling when future requirements remain uncertain.
- Log design decisions and predictions about future changes in an engineering log or source code tags to build design instincts over time.

### Common Mistakes

- Treating design patterns and acronyms as rigid rules rather than application-specific choices that serve ease of change.
- Over-engineering complex flexibility for hypothetical changes instead of building easily replaceable components.
- Failing to reflect on past design decisions when requirements change, missing opportunities to refine design instincts.
