## 19. Version Control

A version control system (VCS) preserves every change to code, documentation, configuration, and operational assets so engineers can inspect authorship and differences, recover previous states, reproduce releases, and collaborate safely. A proper repository replaces unsafe shared directories, manages concurrent edits and merges, isolates work through branches, and can act as the project hub for reviews, issues, builds, tests, communication, and deployments. Effective version control also makes developer environments recoverable and gives teams evidence for debugging, auditing, and improving their workflow.

### The Pragmatic Approach

- Put every asset needed to develop, build, release, operate, or restore the software under version control, including source code, documentation, build procedures, configuration, utility scripts, editor settings, and application manifests.
- Use version control for every project, including prototypes, short-lived experiments, solo work, and non-code material.
- Store repositories on a version-control host or server; never share working files or repository internals through a network directory or synchronized cloud drive, where concurrent writes can lose work or corrupt the repository.
- Use history, differences, and line attribution to answer who changed code, what changed between versions, and which files change most often during debugging, auditing, and quality analysis.
- Identify each release in the repository, then verify that the identified revision can regenerate the release after later development changes.
- Isolate independent work in branches. For example, develop feature A and feature B on separate branches, then merge each completed change without disrupting the other.
- Select a branching and review workflow that addresses the team's actual coordination problems, and revise the workflow as the team gains experience.
- Keep an archived central repository even when the version control system supports peer-to-peer work, and use it as the project hub. Prefer third-party hosting unless operating repository infrastructure is part of the organization's business, and require strong access control, an intuitive interface, command-line automation, merge reviews, issue integration, reporting, change notifications, and collaborative documentation.
- Automate builds and tests when changes reach designated branches; deploy only after those checks succeed, and retain a tested rollback path to a known working revision.
- Practice recovery commands before an incident by restoring an earlier state, undoing a faulty change, and rolling back a release under controlled conditions.
- Express workstation setup as versioned text, such as dotfiles, editor configuration, installed-application lists, and provisioning scripts, then test the setup by rebuilding a spare machine.
- Explore unused repository features such as branches, merge requests, issue boards, continuous integration, deployment pipelines, wikis, and notifications; adopt only the features that improve the team's delivery and coordination.
