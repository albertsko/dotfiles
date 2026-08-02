## 5. Good-Enough Software

Good-enough software deliberately balances scope, delivery time, and quality for users, future maintainers, and developers. It does not excuse sloppy work: every system must meet user requirements and basic performance, privacy, and security standards, but time, technology, and human constraints make perfection unattainable. Make scope and quality explicit requirements, involve users in deciding when the software is good enough for their needs, and deliver usable software early enough to learn from feedback. This discipline can improve productivity and user satisfaction, and shorter incubation can produce better software, but stop before overrefinement spoils an already good program.

### The Pragmatic Approach

- Define quality as a requirement by agreeing with users on acceptable scope, behavior, performance, privacy, security, and delivery time.
- Ask users to choose trade-offs explicitly; for example, offer a useful version with known rough edges now or a broader, more polished version later.
- Apply more stringent requirements and allow fewer trade-offs for safety-critical systems and widely distributed low-level libraries.
- Refuse impossible schedules and preserve essential engineering standards when deadlines tighten. Reduce scope or renegotiate the deadline instead of cutting basic engineering corners.
- Deliver a small, usable version early, then use feedback to decide which improvements users need as their needs evolve.
- Evaluate how coupling affects the time required to bring the system to the agreed quality; use loosely coupled modules when independent completion improves delivery.
- Reject feature bloat whose value does not justify added complexity, more opportunities for defects and security vulnerabilities, or the added difficulty of finding and managing useful features.
- Stop refining when the software meets the agreed requirements and further work would delay more valuable delivery.
