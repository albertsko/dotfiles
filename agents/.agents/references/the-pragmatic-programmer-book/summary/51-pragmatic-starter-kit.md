## 51. Pragmatic Starter Kit

Reliable software projects rest on three interdependent practices: version control, ruthless continuous testing, and full automation. Version control should contain everything required to build, test, configure, deploy, and release the software, allowing commits, pushes, or tags to drive reproducible work on any capable machine instead of a special developer or build machine. Testing should begin as soon as code exists, run automatically in an environment that closely matches production, and combine unit, integration, validation and verification, performance, property-based, and any project-specific tests to check components, subsystem contracts, user needs, realistic loads, scalability, and unexpected program states. Teams should deliberately verify that tests detect failures, add a regression test for every escaped bug, and automate every recurring procedure so machines perform it consistently, repeatably, and without manual variation.

### The Pragmatic Approach

- Store every build input, deployment configuration, and automation script in version control.
- Trigger builds, tests, and deployments from commits or pushes, and identify releases with version-control tags.
- Create isolated build environments, such as containers, on demand and make every capable machine able to reproduce the process.
- Write unit tests as soon as code exists, and treat code as complete only after every test passes.
- Invest in enough test code to exercise the system thoroughly, even when the test code exceeds the production code; the extra effort reduces long-term defect costs.
- Run the full test suite automatically in an environment that matches production as closely as possible.
- Require every module to pass its unit tests before testing subsystem interactions and contracts, where integration defects commonly arise.
- As soon as an executable interface or prototype exists, validate functional requirements and actual user needs against real user access patterns rather than relying only on developer test data.
- Test performance under expected users, connections, and transaction rates, using specialized load-testing hardware or software when necessary.
- Generate test data from the software's contracts and invariants to explore states developers may not anticipate.
- Introduce defects in a separate branch and controlled service disruptions to confirm that tests and resilience safeguards sound the alarm.
- Use line coverage only as a rough guide, not as proof or a 100% target; prioritize meaningful program-state coverage while recognizing that exhaustive state coverage is generally infeasible.
- Add an automated regression test whenever a bug escapes so people never need to find the same defect twice.
- Define automatically testable acceptance results; if acceptable outcomes cannot be defined, the team cannot convincingly show that the software is done.
- Decouple application logic from the user interface when the interface prevents independent automated testing.
- Script every recurring procedure, including setup, project paperwork, build, test, deployment, and release, and keep those scripts under version control so procedure changes can be reviewed.
- Remove manual steps that make environments and results inconsistent or prevent fully automatic delivery.
- If production deployment alone remains manual, identify what makes its server or process exceptional and automate it.
