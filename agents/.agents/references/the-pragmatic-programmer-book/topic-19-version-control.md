## Topic 19: Version Control

Version control systems track every change in source code, documentation, and configuration over time. A version control system acts as a project-wide undo mechanism and serves as a central hub for team collaboration, automated builds, testing, and deployment. Placing all project assets under version control ensures that developers can recover previous states, track modification history, and work concurrently without overwriting changes.

### The Pragmatic Approach

- **Put everything under version control**: Track source code, build scripts, documentation, system configurations, dotfiles, and setup scripts.
- **Use branching for isolation**: Create branches to isolate new features and experiments, then merge changes back into the target branch when ready.
- **Treat version control as a project hub**: Connect central repositories to automated build, test, and deployment pipelines, as well as issue tracking tools.
- **Ensure reproducible environments**: Maintain environment setups and configuration scripts in version control to enable rapid recovery after hardware failure.
- **Adapt team workflows**: Continually review and adjust branching and merge strategies based on project experience.

### Common Mistakes

- **Using shared directories as version control**: Sharing raw files on network drives or cloud storage causes file corruption and overwrites changes due to missing synchronization.
- **Hosting repository databases directly on cloud drives**: Running a repository database over a network or synced cloud folder risks corrupting system files during concurrent access.
- **Restricting version control to source code**: Omitting documentation, build scripts, configuration files, and tools leaves projects vulnerable to loss and complicates environment setup.
- **Treating version control only as an undo tool**: Neglecting team collaboration features, automated testing integrations, issue tracking, and deployment automation limits the value of the repository.
