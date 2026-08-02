## 13. Prototypes and Post-it Notes

Prototypes cheaply isolate risky, unfamiliar, experimental, or critical aspects of a system so teams can learn and correct mistakes before full-scale development. They may use code, scripts, interface mock-ups, whiteboards, Post-it notes, or index cards, and they answer a few specific questions by deliberately ignoring irrelevant correctness, completeness, robustness, and style. Their value lies in the lessons learned rather than the artifact produced, so code-based prototypes must remain explicitly disposable and must never be mistaken for production software.

### The Pragmatic Approach

- Prototype any architecture, functionality, external data, third-party component, performance concern, or interface design that creates uncertainty or risk.
- Define the specific questions the prototype must answer before building it.
- Choose the cheapest medium that exposes the target behavior, structure, appearance, or interaction.
- Omit details that do not affect the questions: use dummy data, support only a predefined path, leave error handling incomplete, and minimize prototype-code comments and documentation. Record the lessons the prototype produces.
- Use high-level scripting languages, interface-design tools, or lightweight physical materials to assemble and revise ideas quickly. Use scripts as glue to test new combinations of existing low-level components, and do not let the prototype language constrain the production implementation.
- Prototype architecture as a whole without making every module functional. Evaluate whether responsibilities and collaborations are well defined, coupling is minimized, duplication is identifiable, interfaces and constraints are acceptable, and every module can access required data when needed.
- Tell every stakeholder before code-based prototyping that prototype code is incomplete, disposable, cannot be completed into production software, and is unsuitable for deployment.
- Discard the prototype after extracting its lessons; build a production-quality foundation instead when details cannot be omitted or stakeholders may treat the result as deployable software.
