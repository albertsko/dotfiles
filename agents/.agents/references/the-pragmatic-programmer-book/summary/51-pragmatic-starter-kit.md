## 51. Pragmatic Starter Kit

Reliable software projects rest on three interdependent practices: version control, ruthless continuous testing, and full automation. Version control should contain everything required to build, test, configure, deploy, and release the software, allowing commits, pushes, or tags to drive reproducible work on any capable machine instead of a special developer or build machine. Testing should begin as soon as code exists, run automatically in an environment that closely matches production, and combine unit, integration, validation, performance, and property-based tests to check components, subsystem contracts, user needs, realistic loads, scalability, and unexpected program states. Teams should deliberately verify that tests detect failures, add a regression test for every escaped bug, and automate every recurring procedure so machines perform it consistently, repeatably, and without manual variation.

### The Pragmatic Approach

- Store every build input, deployment configuration, and automation script in version control.
- Trigger builds, tests, and deployments from commits or pushes, and identify releases with version-control tags.
- Create build environments on demand and make every capable machine able to reproduce the process.
- Write unit tests as soon as code exists, and treat code as complete only after every test passes.
- Run the full test suite automatically in an environment that matches production as closely as possible.
- Test individual modules, subsystem interactions and contracts, functional requirements and user needs, realistic performance, scalability, and unexpected states.
- Generate test data from the software's contracts and invariants to explore states developers may not anticipate.
- Introduce controlled defects and disruptions to confirm that tests and resilience safeguards sound the alarm.
- Assess meaningful program-state coverage instead of relying on executed-line percentages alone.
- Add an automated regression test whenever a bug escapes so people never need to find the same defect twice.
- Script every recurring setup, build, test, deployment, and release procedure, and keep those scripts under version control.
- Remove manual steps that make environments and results inconsistent or prevent fully automatic delivery.
