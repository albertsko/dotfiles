## 51. Pragmatic Starter Kit

Reliable software delivery rests on three interdependent foundations: version control, ruthless continuous testing, and full automation. Version control should contain every input needed to build and deploy the system and should drive reproducible builds, tests, and tagged releases on clean, disposable machines. Automated testing should begin with the first code, cover units, subsystem contracts, user needs, realistic access patterns, performance, scalability, and project-specific risks, and run in production-like environments; test effectiveness comes from detecting meaningful failures and program states, not maximizing executed lines. Automate every recurring procedure so any capable machine performs it consistently without interpretation, machine-specific differences, or manual intervention.

### The Pragmatic Approach

- Keep every build and deployment input under version control, including source code, tests, build scripts, environment configuration, and deployment configuration.
- Use commits or pushes to trigger builds and the complete test suite, and use explicit version-control tags to trigger staging or production releases.
- Build in clean, disposable environments so no developer workstation or long-lived build machine becomes an undocumented dependency.
- Write unit tests as soon as code exists, accept that robust test code may exceed production code, and require every module to pass its tests before integration.
- Run every available automated test as part of the build, and treat code as incomplete until the full suite passes.
- Test subsystem contracts and interactions with integration tests, and give boundaries special attention because integration is often the system's largest source of defects.
- As soon as an executable interface or prototype exists, test whether the product meets functional requirements and user needs under realistic access patterns. Define machine-checkable acceptable results so completion can be demonstrated.
- Test performance and scalability under real-world conditions, including expected users, connections, and transaction rates. Use specialized simulation hardware or software when realistic load requires it.
- Add specialized forms of testing when the project's risks require coverage beyond the core unit, integration, validation, and performance suite.
- Make test environments resemble production closely because environmental gaps create room for defects.
- Prove that tests detect failures by deliberately reintroducing known bugs or injecting controlled faults, such as disrupting a service, and confirming that the expected alarms sound.
- Use code coverage only as a rough signal. Design tests around meaningful states, boundary conditions, contracts, and invariants, and use property-based generated inputs to explore cases engineers may not anticipate.
- Add an automated regression test whenever a defect escapes, first reproduce the defect with the test, and retain the test in every future run.
- Separate application logic from the user interface so it can be tested automatically; when tests require driving the interface, reduce the coupling that prevents independent testing.
- Script environment setup, project paperwork, builds, tests, releases, deployments, and every other recurring task. Eliminate manual clicks and one-off production steps.
- Store automation in version control so the team can reproduce procedures, review changes to them, and trace when their behavior changed.
