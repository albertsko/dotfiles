## Topic 51: Pragmatic Starter Kit

Every successful software project relies on three core pillars: version control, regression testing, and full automation. These three practices form the Pragmatic Starter Kit, providing a repeatable and consistent foundation for software development across any team, methodology, or technology stack.

### The Pragmatic Approach

- **Drive with Version Control**: Store all code, configuration, build scripts, and deployment settings in version control. Use repository commits and tags to trigger automated cloud builds, test execution, and continuous delivery.
- **Test Ruthlessly and Continuously**: Write automated unit, integration, validation, and performance tests from the start. Ensure that all tests pass before declaring code complete.
- **Verify Test Effectiveness**: Validate the test suite by deliberately introducing bugs or running chaos experiments to confirm that tests sound alarms when failures occur.
- **Focus on State Coverage**: Test critical program states and boundary conditions rather than relying solely on line coverage metrics. Use property-based testing to evaluate generated edge cases.
- **Trap Bugs Permanently**: Write an automated regression test whenever a bug slips through, ensuring the team catches that defect automatically in future builds.
- **Automate Every Procedure**: Use version-controlled scripts to handle builds, testing, environment setup, and releases without manual human intervention.

### Common Mistakes

- **Relying on Manual Procedures**: Using multi-step manual setup or deployment checklists, which causes configuration drift and human errors across environments.
- **Maintaining Sacred Build Machines**: Relying on single, unscripted build machines instead of using containerized, ephemeral build environments in the cloud.
- **Testing Softly**: Writing gentle tests that avoid weak spots or deferring automated test writing until late in development.
- **Chasing Line Coverage Metrics**: Assuming 100 percent code coverage guarantees quality while ignoring system state combinations and logical edge cases.
- **Failing to Test the Tests**: Assuming test suites catch errors without verifying that tests fail when bugs are introduced.
- **Fixing Bugs Without Adding Regression Tests**: Resolving a bug without an accompanying automated test, allowing the same bug to recur in future releases.
