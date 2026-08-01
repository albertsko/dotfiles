## 38. Programming by Coincidence

Programming by coincidence means trusting code because it appears to work without understanding why, turning accidental success into false confidence and making failures hard to diagnose. It includes depending on undocumented behavior, incorrect call order, unnecessary calls, unexplained boundary conditions, approximate corrections that mask flawed models, imagined causal patterns, copied solutions from mismatched contexts, and environmental assumptions about locale, files, clocks, networks, or configuration. Such dependencies may vary across machines, inputs, or library releases, reduce performance, and introduce bugs, so reliable software depends on documented behavior and explicit, tested assumptions.

### The Pragmatic Approach

- Understand every piece of code well enough to explain why it works and why it might fail.
- Proceed from a plan and rely on documented behavior, well-defined interfaces, and sound domain models.
- Remove unnecessary calls and accidental workarounds once you identify the behavior that the code actually requires.
- Prove suspected causes and patterns with evidence instead of inferring them from intermittent results or limited tests.
- Identify and document assumptions about inputs, execution order, locale, files, configuration, clocks, hardware, and network conditions.
- Test assumptions directly with experiments and assertions, and treat unsupported assumptions as unreliable.
- Prioritize correct fundamentals and infrastructure before adding secondary features.
- Refactor or replace existing code when its design no longer fits, while weighing the change against the cost of preserving it.
