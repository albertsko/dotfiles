## 20. Debugging

Debugging is disciplined problem solving: set aside blame, panic, and assumptions; gather accurate firsthand evidence; distinguish symptoms from root causes; and remember that software does what it was told, not what was intended. Start from a clean, warning-free build, reproduce the failure with a single automated test, read error messages, confirm the bad state in a debugger, and inspect values and the call stack while recording clues. Isolate faults by dividing stack frames, inputs, or version history; use consistent tracing for behavior over time; explain code aloud to expose assumptions; suspect application code before platforms or libraries; and after proving and fixing the cause, strengthen tests, validation, diagnostics, and similar code paths so the failure is caught earlier and cannot quietly recur.

### The Pragmatic Approach

- Treat every bug as a problem to solve, regardless of who introduced it.
- Stay calm, accept that observed failures are possible, and search beyond visible symptoms for the root cause.
- Set compiler warning levels as high as possible and remove all warnings before debugging so automated checks handle the problems they can detect.
- Gather precise, firsthand evidence by interviewing and observing the user, then test realistic usage patterns and boundary conditions.
- Create a single-command test that reproduces the failure before changing the code; use the isolation and test-writing process to inform the solution.
- Read the complete error message before inspecting code.
- Reproduce the incorrect value in a debugger, inspect the call stack and local state, and record clues before following them.
- Reproduce data-sensitive failures locally with the actual dataset before reducing it to the minimum failing input set.
- Divide large search spaces in half repeatedly to isolate the faulty call-stack region, input set, or code change, using automated version-control bisection when available.
- Add tracing while descending the call tree when behavior over time, concurrency, real-time activity, or event sequences matter, and format trace messages consistently for automatic processing.
- Explain the code and its expected behavior aloud, step by step, to expose hidden assumptions.
- Eliminate mistakes in application code and verify library usage against its documentation before blaming the operating system, compiler, framework, or other dependency.
- Investigate the sole recent change first, including platform or dependency upgrades; retest after upgrades, account for new bugs, changed interfaces or behavior, and invalidated workarounds, and avoid upgrading just before a release when the schedule cannot absorb the risk.
- Reevaluate every trusted assumption after a surprising failure, and prove the suspect code with the actual data, context, and boundary conditions.
- After fixing the root cause, strengthen tests, input validation, diagnostics, and debugging hooks; search for the same conditions elsewhere; and share corrected assumptions with the team.
