## 20. Debugging

Debugging is disciplined problem solving: reproduce the failure, gather accurate evidence, and find the root cause instead of patching symptoms or assigning blame. Treat every surprising result as evidence that an assumption is wrong, compare the program's actual behavior with its intended behavior, and consider a fix complete only when a regression test proves it and safeguards prevent the same defect from escaping again.

### The Pragmatic Approach

- Stay calm and accept that an observed failure is possible; focus on solving the problem, regardless of who introduced it.
- Start from a clean build with the strictest practical compiler warnings enabled, then read the complete error message before inspecting code.
- Reproduce the report firsthand with the exact input, environment, action sequence, and direction of interaction; interview or observe the reporter when details are missing.
- Exercise realistic usage and boundary conditions systematically instead of relying on a narrow artificial example.
- Reduce the failure to a deterministic, single-command test before changing production code, and retain the test to prevent regression.
- Confirm the incorrect value or state in the failing run, then inspect the call stack, local variables, and data flow to find where the state first became wrong.
- Record observations, hypotheses, and eliminated paths while investigating so each experiment advances the search.
- Divide large search spaces in half repeatedly: bisect stack frames to locate state corruption, input data to isolate a minimal failing dataset, or revisions to identify the change that introduced a regression.
- Add consistently formatted, machine-parseable tracing when behavior unfolds over time, especially in concurrent, real-time, or event-driven systems; log paired operations such as resource acquisition and release so tools can reveal imbalances.
- Explain the code's expected behavior step by step to another person or an inanimate listener, and state every assumption explicitly.
- Suspect application code and incorrect library usage before blaming the operating system, compiler, framework, or dependency; read the documentation and eliminate mistakes in your code before escalating a third-party defect.
- Investigate the most recent change first when a previously working system fails, including indirect effects from operating system, compiler, database, dependency, application programming interface, or configuration upgrades.
- Prove trusted code under the failing data, context, and boundary conditions; do not treat old success or passing incomplete tests as evidence that the code cannot be responsible.
- Fix the root cause, add checks that reject bad data near its origin, search for the same vulnerable pattern elsewhere, and extend tests to cover every discovered condition.
- Improve diagnostic hooks, logs, or analysis tools when a defect was slow to locate, and share the invalid assumption with the team so the lesson prevents related failures.
