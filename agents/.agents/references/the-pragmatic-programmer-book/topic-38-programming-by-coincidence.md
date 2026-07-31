## Topic 38: Programming by Coincidence

Programming by coincidence means relying on luck and accidental success rather than understanding why code works. Developers who code by coincidence build on false confidence, leading to fragile software that fails unpredictably. To create reliable software, developers must replace luck with deliberate programming.

### The Pragmatic Approach

Deliberate programming requires intentional decisions, explicit assumptions, and constant awareness:

- **Understand your code**: Ensure you can explain every detail of the implementation to another developer before committing it.
- **Work from a clear plan**: Base development on a defined design rather than trial and error.
- **Rely only on documented behavior**: Restrict calls to official module interfaces and documented boundaries.
- **Document and test assumptions**: Use explicit assertions to verify assumptions directly in the code.
- **Prioritize fundamental architecture**: Focus effort on core infrastructure and critical components before adding optional features.
- **Refactor outdated code**: Replace existing implementation details when requirements or contexts change.

### Common Mistakes

Accidental programming leads to critical flaws through several anti-patterns:

- **Relying on implementation accidents**: Calling undocumented routines or calling methods in incorrect sequences because they appear to work.
- **Accepting "close enough" solutions**: Applying temporary numeric adjustments or hacks to mask underlying design flaws instead of fixing root causes.
- **Perceiving phantom patterns**: Inferring false causal relationships from random occurrences or coincidental test results.
- **Ignoring context assumptions**: Assuming specific execution environments, localized settings, accessible file systems, or active network connections without verification.
- **Fearing code modifications**: Leaving unnecessary or redundant calls in place out of fear that cleanup will break working behavior.
