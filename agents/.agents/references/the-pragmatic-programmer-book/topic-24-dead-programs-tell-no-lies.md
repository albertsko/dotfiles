## Topic 24: Dead Programs Tell No Lies

Detecting errors early prevents impossible states from corrupting systems. When code encounters an unexpected error or condition, terminate the process quickly to limit potential damage. A dead program causes much less damage than a crippled program running with corrupted state.

### The Pragmatic Approach

- Check assumptions defensively and crash as soon as an impossible condition occurs.
- Allow exceptions to propagate naturally instead of catching and re-raising them manually.
- Use supervisor structures or cleanup routines to manage process failures cleanly.
- Include a default clause in every case or switch statement to catch unexpected values immediately.

### Common Mistakes

- Catching every exception only to log a message and re-raise the same exception.
- Assuming an unexpected error can never happen in normal production conditions.
- Continuing program execution after state corruption or unhandled errors occur.
- Coupling caller code tightly to every specific exception type a dependency can throw.
