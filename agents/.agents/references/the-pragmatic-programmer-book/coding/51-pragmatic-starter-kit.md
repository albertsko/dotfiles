## 51. Pragmatic Starter Kit

Reliable software delivery rests on version control, ruthless continuous testing, and full automation. Version control should contain everything needed to build and deploy the system, while commits, pushes, and tags trigger reproducible builds, tests, and releases on disposable machines. Automated tests should start with the first code, cover units, integrations, user needs, and real-world performance, and run in an environment that closely matches production. Test effectiveness matters more than line coverage, so deliberately introduce failures, explore program states and properties, and turn every escaped defect into a permanent regression test. Script every recurring procedure to remove interpretation, machine-specific differences, and unreliable manual intervention.

### The Pragmatic Approach

- Keep all build and deployment inputs under version control, including source code, build scripts, environment configuration, and deployment configuration.
- Trigger builds and tests from commits or pushes, and trigger staging or production releases from explicit version-control tags.
- Build in clean, disposable environments so no developer workstation or long-lived build machine becomes an undocumented dependency.
- Write unit tests as soon as code exists, and require every module to pass its tests before integrating it with the rest of the system.
- Run every available automated test as part of the build, and treat code as incomplete until the full suite passes.
- Test subsystem contracts with integration tests, confirm that the product meets user needs and realistic access patterns, and measure performance under expected users, connections, and transaction rates.
- Make test environments resemble production closely because environmental gaps create room for defects.
- Prove that tests detect failures by deliberately reintroducing a bug or disrupting a service in a controlled environment, then confirm that the expected test fails.
- Use code coverage only as a rough signal. Design tests around meaningful states, boundary conditions, contracts, and invariants, and use generated inputs to explore cases engineers may not anticipate.
- Add an automated regression test whenever a defect escapes, reproduce the defect with the test, and keep the test in every future run.
- Script environment setup, builds, tests, releases, deployments, and other recurring work. Store the automation in version control and remove instructions that depend on manual clicks or individual interpretation.
