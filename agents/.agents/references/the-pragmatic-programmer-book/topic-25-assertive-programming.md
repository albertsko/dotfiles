## Topic 25: Assertive Programming

Programmers often fall into self-deception by assuming that invalid code states or environmental failures will never happen. Assertive programming combats this self-deception by requiring developers to write explicit checks for conditions that should be impossible. Assertions verify system assumptions, detect bugs early, and prevent corrupted data from propagating through an application.

### The Pragmatic Approach

- **Check impossible conditions**: Add assertion checks whenever code relies on an assumption, such as non-null parameters, positive counts, or algorithm invariants.
- **Include clear diagnostic messages**: Provide descriptive error messages inside assertions to simplify debugging when a check fails.
- **Keep assertions enabled in production**: Retain assertions in production releases. Testing catches only a small fraction of potential failure permutations, and production systems face real-world environmental risks like full disks and network failures. Production assertions capture critical failure data under actual operating conditions.
- **Disable assertions selectively**: Keep assertions active by default across the system. Disable an assertion check only when performance profiling proves that a specific assertion creates an unacceptable bottleneck.
- **Handle cleanup safely**: Catch assertion failures or trap exits to release resources when necessary. Ensure cleanup routines do not rely on the corrupted state that triggered the assertion failure.

### Common Mistakes

- **Replacing error handling with assertions**: Using assertions to validate user input or process expected runtime errors. User input validation and environmental errors require regular control flow and error handling, not process-terminating assertions.
- **Evaluating side effects inside assertions**: Placing expressions that modify program state inside assertion conditions, such as advancing an iterator while checking for non-null values. Evaluating stateful expressions alters program behavior during debugging and creates Heisenbugs.
- **Turning off assertions in production**: Disabling assertions in production releases under the false assumption that prior testing eliminated all bugs. Deactivating assertions removes the safety net precisely when software encounters untested real-world conditions.
