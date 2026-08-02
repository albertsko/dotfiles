## 13. Prototypes and Post-it Notes

A prototype is a disposable learning tool that isolates a risky, uncertain, unproven, or critical aspect of software so engineers can correct mistakes before production work makes changes expensive. A prototype may use code, scripts, interface mock-ups, whiteboards, Post-it notes, or index cards, and its value lies in the questions it answers rather than the implementation it produces. A focused prototype deliberately sacrifices irrelevant correctness, completeness, robustness, style, or interfaces to evaluate architecture, functionality, external data, third-party components, performance, workflows, or user interactions quickly.

### The Pragmatic Approach

- Define the question and the evidence needed to answer it before building anything. For example, test whether a payment component meets the required throughput instead of prototyping the entire checkout flow.
- Prototype the highest-risk or least-understood part first, especially an experimental dependency, a critical performance path, or a new interaction model.
- Choose the cheapest medium that preserves the behavior under investigation. Use Post-it notes for workflows, cards or a whiteboard for component relationships, a clickable mock-up or interface builder for appearance and interactions, or a high-level script for combining existing components into a testable configuration.
- Remove details that cannot affect the answer. Use dummy data for an interface experiment, one fixed input for an algorithm experiment, or no interface for a performance experiment.
- Accept limited correctness, completeness, error handling, code documentation, and polish, but constrain the experiment so those omissions cannot invalidate its result.
- Prototype architecture as a whole without implementing each module's behavior. Check component responsibilities, collaborations, coupling, duplicated work, interface constraints, and whether each component can access required data at the exact time it needs it.
- Time-box the prototype, record the lessons, decisions, and production guidance it produces, then discard the implementation rather than treating prototype code as a production foundation.
- Tell engineers, managers, and sponsors before any demonstration that the prototype is incomplete, disposable, and unsuitable for deployment.
- Build a small production-quality implementation instead when the team cannot omit production details or the organization is unlikely to discard prototype code.
