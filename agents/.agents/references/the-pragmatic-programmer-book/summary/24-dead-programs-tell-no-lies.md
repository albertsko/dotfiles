## 24. Dead Programs Tell No Lies

Treat every error, including unexpected input, missing or corrupt data, incorrect dependencies, input/output failures, and impossible control flow, as evidence that the program's state may already be invalid. Detect violations early, include a default branch in every case or switch statement, and read the actual error instead of dismissing it as impossible. Let exceptions propagate unless a handler adds value beyond logging and rethrowing, because enumerating exceptions hides application logic and couples callers to every exception a callee can raise. Once an impossible state occurs, stop execution as soon as safely possible, after releasing resources, logging, cleaning up transactions, or coordinating with other processes when necessary, because continued operation can corrupt data or cause greater damage. Resilient systems can isolate failures under supervisors that clean up or restart failed work and form hierarchies that manage supervisor failures.

### The Pragmatic Approach

- Validate data, runtime assumptions, deployed code, and dependency versions.
- Add a default branch to every case or switch statement, and treat reaching it unexpectedly as an error.
- Read and investigate every error message instead of assuming the error cannot happen.
- Let exceptions propagate unless a handler can recover, clean up, or add useful context.
- Terminate execution promptly when an impossible state makes further behavior untrustworthy.
- Release resources, log essential details, close transactions, and coordinate with other processes before terminating when the environment requires cleanup.
- Isolate fallible work under supervisors that clean up, restart it, and manage failures through a supervisor hierarchy.
