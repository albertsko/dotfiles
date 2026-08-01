## 13. Prototypes and Post-it Notes

Prototypes cheaply isolate risky, unfamiliar, experimental, or critical aspects of a system so teams can learn and correct mistakes before full-scale development. They may use code, scripts, interface mock-ups, whiteboards, Post-it notes, or index cards, and they answer a few specific questions by deliberately ignoring irrelevant correctness, completeness, robustness, and style. Their value lies in the lessons learned rather than the artifact produced, so code-based prototypes must remain explicitly disposable and must never be mistaken for production software.

### The Pragmatic Approach

- Prototype any architecture, functionality, external data, third-party component, performance concern, or interface design that creates uncertainty or risk.
- Define the specific questions the prototype must answer before building it.
- Choose the cheapest medium that exposes the target behavior, structure, appearance, or interaction.
- Ignore correctness, completeness, robustness, documentation, and polish when they do not affect the questions under investigation.
- Use high-level scripting languages, interface-design tools, or lightweight physical materials to assemble and revise ideas quickly.
- Model architectural responsibilities, collaborations, coupling, duplication, interfaces, constraints, and the timing of each module's data access.
- Tell every stakeholder that prototype code is incomplete, disposable, and unsuitable for deployment.
- Discard the prototype after extracting its lessons; build a production-quality foundation instead when details cannot be omitted or stakeholders may treat the result as deployable software.
