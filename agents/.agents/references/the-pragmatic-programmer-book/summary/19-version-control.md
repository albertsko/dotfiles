## 19. Version Control

A version control system (VCS) records changes to source code, documentation, and other project material so teams can restore any previous state and reproduce identified releases. Its history attributes changes and exposes differences that support debugging, auditing, performance analysis, and quality work. Unlike shared network or cloud-storage directories, which invite overwritten work and can corrupt repositories during simultaneous access, a VCS coordinates concurrent editing and merges changes safely. Branches isolate work for parallel development and allow teams to merge it later, while flexible workflows can evolve with experience. Applied to every project artifact and machine-configuration file, a properly hosted repository also becomes a secure project hub for automation, branch merging, issue tracking, communication, builds, tests, deployments, and rollback.

### The Pragmatic Approach

- Put every project artifact under version control, including prototypes, documentation, scripts, build procedures, release procedures, and non-code work.
- Store repositories on a version control server or hosting provider, not in a shared or synchronized filesystem directory.
- Commit meaningful changes and identify releases so you can inspect history, reproduce results, and recover earlier states.
- Learn and rehearse restoration and rollback commands before an emergency.
- Use branches to isolate concurrent work, then merge changes through a workflow suited to the team.
- Review and adjust the branching workflow as the team gains experience and encounters new constraints.
- Choose hosting with strong security, access control, an intuitive interface, command-line automation, merge support, issue management, reporting, and team communication.
- Automate builds and tests, and deploy successful changes when the team can recover reliably through version control.
- Express personal preferences, development tools, installed software, and system configuration as version-controlled text stored away from the machine, then test rebuilding an environment from it.
