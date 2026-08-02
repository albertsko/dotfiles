## 38. Programming by Coincidence

Programming by coincidence means trusting code because it appears to work without understanding why, turning accidental success into false confidence and making failures hard to diagnose. It includes depending on undocumented behavior, incorrect call order, unnecessary calls, unexplained boundary conditions, approximate corrections that mask flawed models, imagined causal patterns, copied solutions from mismatched contexts, and environmental assumptions about locale, files, clocks, networks, or configuration. Such dependencies may vary across machines, inputs, or library releases, reduce performance, and introduce bugs, so reliable software depends on documented behavior and explicit, tested assumptions.

### The Pragmatic Approach

- Understand the code, application, and technologies well enough to explain in detail why the code works and why it might fail.
- Proceed from a plan and rely on documented behavior, sound domain models, and small, well-documented interfaces that hide implementation details.
- Remove unnecessary calls and accidental workarounds once you identify the behavior that the code actually requires.
- Prove suspected causes and patterns with evidence instead of inferring them from intermittent results or limited tests.
- Identify, reconcile, and document assumptions across requirements, implementation, and testing, including assumptions about inputs, execution order, users, locale, file permissions, configuration, runtime environments, clock accuracy, hardware, and network availability and speed.
- Use Coordinated Universal Time when systems span time zones.
- Rely only on behavior you know is reliable. If reliability is uncertain, assume the worst; if you must depend on undocumented behavior, record the assumption clearly.
- Test assumptions directly with experiments and assertions so verified assumptions also document the code.
- Prioritize correct fundamentals and infrastructure before adding secondary features.
- Refactor or replace existing code when its design no longer fits, while weighing the change against the cost of preserving it. Do not rewrite suitable code merely to impose personal preferences.
