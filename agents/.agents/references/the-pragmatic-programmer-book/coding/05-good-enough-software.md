## 5. Good-Enough Software

Good-enough software deliberately balances scope, delivery time, and quality against user needs; it is not permission to ship sloppy code, and every system must satisfy agreed requirements and basic performance, privacy, and security standards. Define acceptable quality with users, deliver useful software early enough to learn from real feedback, and stop refining when further work adds less value than shipping, because unnecessary features and polish increase complexity, defects, security vulnerabilities, and maintenance cost.

### The Pragmatic Approach

- Define quality as a requirement by agreeing with users on acceptable scope, behavior, performance, privacy, security, and delivery time.
- Ask users to choose trade-offs explicitly; for example, offer a useful version with known rough edges now or a broader, more polished version later.
- Preserve essential engineering standards when schedules tighten. Reduce scope or renegotiate the deadline instead of weakening required behavior, performance, privacy, or security.
- Deliver a small, usable version early and use feedback to decide which improvements users actually need.
- Structure the system as loosely coupled modules so each part can reach the required quality without forcing unrelated parts to wait.
- Reject features whose user value does not justify their added complexity, defect risk, security exposure, and maintenance cost.
- Stop refining when the software meets the agreed quality requirements and further work would delay more valuable delivery.
