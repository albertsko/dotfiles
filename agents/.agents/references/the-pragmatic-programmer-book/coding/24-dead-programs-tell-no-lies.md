## 24. Dead Programs Tell No Lies

Errors and violated invariants reveal that a program's assumptions no longer match reality, so detect them at the earliest boundary and stop execution before uncertain state corrupts data or causes unsafe behavior. Let unexpected exceptions propagate instead of wrapping every call in catch-log-rethrow boilerplate, which obscures application logic and couples callers to a changing list of failure types. When immediate process exit would abandon resources or transactions, perform only the cleanup and reporting required for a controlled failure, then terminate or hand recovery to a supervisor that can restart the failed component.

### The Pragmatic Approach

- Validate data where incorrect values first become observable. Reject a nil value, missing map key, unexpected collection type, empty payload, or corrupted response before downstream code can use it.
- Add a default clause to every case or switch statement. Treat an unexpected selector as an invariant violation, report the actual value, and stop the affected operation.
- Check the results of fallible operations even when failure seems unlikely. Verify file closure, diagnostic writes, network and filesystem operations, the code running in production, and the loaded versions of dependencies.
- Read and preserve the original error information. Do not catch an exception only to log a generic message and rethrow it; allow unhandled failure types to propagate automatically.
- Catch an error only when the current boundary can recover, release resources, roll back a transaction, or add actionable context without hiding the original cause.
- Stop as soon as an impossible condition invalidates program state. Do not continue writing records, issuing commands, or performing other mutations with suspect data.
- Place recovery outside the failed component when the runtime supports supervision. Let the supervisor clean up, restart the component, or escalate the failure through a hierarchy of supervisors.
