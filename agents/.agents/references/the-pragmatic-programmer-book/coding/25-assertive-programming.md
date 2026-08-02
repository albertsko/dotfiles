## 25. Assertive Programming

Treat every “impossible” state as an invariant to enforce, because production exposes code to untested combinations, resource failures, and environmental conditions. Use assertions to detect defects close to the violated assumption and report enough context to diagnose them, but handle expected input, system, and operational failures through normal error paths. Keep assertion expressions free of side effects, and leave assertions enabled in production unless profiling shows that a specific expensive check must become optional.

### The Pragmatic Approach

- Turn assumptions about parameters, results, and internal state into explicit assertions with descriptive messages, such as `assert result != null && !result.isEmpty() : "Empty search result"`.
- Assert important algorithm postconditions, such as verifying that a custom sort returns an ordered collection.
- Reserve assertions for conditions that indicate defects. Validate user input and recover from expected failures with normal error handling instead of terminating the process.
- Evaluate state-changing operations once, store their results, and assert against the stored values. Never advance an iterator, mutate state, or perform input and output inside an assertion condition.
- Choose assertion failure behavior deliberately. Assertions need not terminate the process; if a failure does stop execution, intercept it when necessary so cleanup and error handling can run without relying on the invalid data that triggered the failure.
- Keep assertions active in production so they can catch states that tests did not cover and failures caused by real operating conditions.
- Disable or make optional only the assertions that profiling proves too expensive, such as a full second pass that verifies a large collection is sorted.
