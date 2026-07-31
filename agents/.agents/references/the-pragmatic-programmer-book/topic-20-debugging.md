## Topic 20: Debugging

Debugging is a systematic problem-solving process focused on diagnosing and resolving root causes rather than assigning blame or patching superficial symptoms. Modern software development requires developers to gather empirical data, isolate issues with reproducible tests, and challenge false assumptions about how code executes.

### The Pragmatic Approach

- **Adopt a Problem-Solving Mindset**: Treat debugging as a neutral puzzle, step back to analyze symptoms calmly, and focus on fixing the bug instead of assigning blame.
- **Ensure Clean Builds**: Set compiler warning levels to maximum and eliminate all warnings before debugging to let tools catch basic errors automatically.
- **Reproduce Bugs with Failing Tests**: Isolate the exact conditions causing a failure and write an automated test that reproduces the bug before modifying any application code.
- **Read Error Messages and Stack Traces**: Examine full error details, trace exception messages, and use binary chop techniques to narrow down problematic stack frames, datasets, or version commits.
- **Use Rubber Duck Debugging**: Explain the failing code step-by-step to a colleague or object to verbalize assumptions and reveal hidden logic flaws.
- **Verify External Dependencies First**: Assume application code causes the failure before blaming operating systems, compilers, or third-party libraries.
- **Prove Assumptions**: Test boundary conditions directly and verify assumed behavior with hard data instead of trusting existing code blindly.

### Common Mistakes

- **Fixing Symptoms Instead of Root Causes**: Applying superficial patches to observed behavior without investigating underlying failure mechanisms.
- **Blaming External Systems**: Assuming third-party libraries, compilers, or operating systems are broken before eliminating errors in custom application code.
- **Debugging Without Reproducibility**: Attempting to fix intermittent or complex errors without creating a simple, repeatable command or test case.
- **Ignoring Error Messages and Warnings**: Glossing over compiler warnings or stack traces instead of reading exact error descriptions carefully.
- **Relying on Unverified Assumptions**: Trusting that existing algorithms or components work correctly in new contexts without proving their execution empirically.
