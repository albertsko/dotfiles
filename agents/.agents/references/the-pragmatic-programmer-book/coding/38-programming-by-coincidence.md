## 38. Programming by Coincidence

Programming by coincidence means accepting code that appears to work without understanding the behavior, guarantees, and environmental assumptions that make it work. It produces fragile systems that depend on undocumented implementation details, accidental call sequences, approximate corrections, imagined patterns, or context-specific conditions. Program deliberately by using explicit models, relying on documented guarantees, testing assumptions, and correcting flawed foundations instead of preserving accidental success.

### The Pragmatic Approach

- Explain in detail why each important piece of code works before extending it. If you cannot explain the causal path to another engineer, investigate until you can.
- Start from a plan that defines inputs, outputs, invariants, dependencies, failure modes, and supported environments.
- Depend only on documented library and framework behavior. When an undocumented behavior is unavoidable, isolate the dependency, record the exact assumption, and protect it with a focused test.
- Reduce trial-and-error call sequences to the smallest supported sequence. Remove redundant calls that hide the real fix, waste resources, or introduce new failure modes.
- Treat “close enough” results as evidence of a flawed model. Fix the model instead of accumulating local compensations such as scattered `+1` and `-1` adjustments for incorrect time handling.
- Identify context assumptions explicitly, including concurrency, locale, language, units, time zones, clock accuracy, writable storage, configuration, network availability, and hardware characteristics.
- Verify copied code against your own inputs, runtime, constraints, and failure cases. Reproduce the reasoning, not just the code’s shape.
- Prove suspected causes by changing one relevant condition at a time and reproducing the result. Do not infer causality from an intermittent frequency, a single passing run, or success on one machine.
- Turn assumptions into assertions and tests, especially at boundaries and under adverse conditions. Vary environment details such as core count, resolution, locale, configuration, and network behavior.
- Prioritize correct fundamentals over extra features. Refactor or replace code when evidence shows that its design is inappropriate, even if its current behavior appears successful.
