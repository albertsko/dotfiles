## 5. Good-Enough Software

Good-enough software is deliberately built to satisfy users and future maintainers and give developers confidence without chasing impossible perfection; it still meets requirements and basic performance, privacy, and security standards. Because schedules, costs, technology, and future needs create trade-offs, make scope and quality explicit requirements that users help decide, deliver useful software early enough to learn from feedback, and stop before extra features or polish bury a sound program.

Acceptable trade-offs depend on context. Safety-critical systems and widely distributed low-level libraries require more stringent quality, while new products may benefit from earlier delivery because needs can change and feedback can improve the eventual solution. A disciplined good-enough threshold can increase productivity and user satisfaction, and shorter incubation may produce better software.

### The Pragmatic Approach

- Make the required scope and quality explicit requirements, and agree on them with users before committing to delivery.
- Meet essential functional, performance, privacy, and security standards.
- Apply more stringent quality standards when failure or widespread use raises the consequences of defects.
- Balance improvements against schedules, delivery commitments, cash-flow constraints, and the value of earlier user feedback.
- Reject impossible schedules and basic engineering shortcuts; negotiate scope, quality, or delivery instead.
- Deliver useful software early when users value it, and use feedback and changing needs to guide the eventual solution.
- Evaluate how coupling and modularity affect the time required to reach the agreed quality, including the trade-offs between a monolith and loosely coupled modules or services.
- Stop refining when the software meets the agreed needs, and avoid unnecessary features and polish.
- Prevent feature bloat: each feature creates opportunities for defects and security vulnerabilities and can make useful features harder to find and manage.
