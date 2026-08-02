## 19. Version Control

A version control system (VCS) records changes to source code, documentation, and other project material so teams can restore any tracked previous state and reproduce identified releases. Its history attributes changes and exposes differences, change volumes, and frequently changed files that support debugging, auditing, performance analysis, and quality work. Sharing project files through network or cloud-storage directories invites overwritten work; storing a repository in a shared or synchronized directory risks corruption during simultaneous access. A VCS instead coordinates concurrent editing and merges changes safely. Branches isolate work for parallel development and allow teams to merge it later, while flexible workflows can evolve with experience. Applied to every project artifact and machine-configuration file, a central hosted repository also becomes a secure project hub for automation, branch merging, issue tracking, communication, builds, tests, deployments, and rollback.

### The Pragmatic Approach

- Put every project artifact and useful nonproject text under version control, including prototypes, documentation, scripts, build procedures, release procedures, and day-to-day work.
- Store repositories on a version control server or hosting provider, not in a shared or synchronized filesystem directory.
- Commit meaningful changes and identify releases so you can inspect history, reproduce releases, and recover earlier tracked states.
- Learn and rehearse restoration and rollback commands before an emergency.
- Use branches to isolate concurrent work, then merge changes through a workflow suited to the team.
- Review and adjust the branching workflow as the team gains experience and encounters new constraints.
- Prefer third-party hosting unless operating repository infrastructure is part of the organization’s business, and archive the central repository.
- Choose hosting with strong security, access control, an intuitive interface, command-line automation, merge support, issue tracking integrated with commits and merges, task reporting, and team communication.
- Explore unused branches, merge requests, continuous integration, build and deployment pipelines, wikis, and task boards before deciding whether they fit the team.
- Automate builds and tests, and deploy successful changes when the team can recover reliably through version control.
- Express user preferences, editor and shell setup, access keys, installed software, provisioning scripts, system configuration, and current projects as securely version-controlled text stored away from the machine, then test rebuilding an environment from it.
