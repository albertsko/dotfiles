## 17. Shell Games

Use the command shell as a programmable workbench for manipulating files, launching development tools, inspecting system state, filtering output, and orchestrating workflows. Unlike a fixed graphical user interface (GUI), the shell lets you compose focused tools with pipes and capture useful command sequences as repeatable macro tools. Customize the shell and terminal to reduce friction and expose useful context throughout daily development.

### The Pragmatic Approach

- Learn the shell commands for frequent engineering tasks such as navigating directories, finding files, searching text, checking system status, and launching editors, debuggers, browsers, and build tools.
- Compose small tools with pipes to solve tasks that no single tool handles. For example, extract the unique packages imported by Java files:

  ```bash
  grep '^import ' *.java |
    sed -e 's/.*import  *//' -e 's/;.*$//' |
    sort -u > list
  ```

- Automate repeated command sequences instead of preserving multi-step click instructions. Turn routine build, deployment, preprocessing, or environment-maintenance workflows into scripts, aliases, or shell functions.
- Use the shell to connect tools when an integrated development environment (IDE) lacks the required integration point. For example, invoke a code preprocessor before the normal build command.
- Choose the GUI for operations where pointing and clicking is simpler, and choose the shell when the work requires composition, customization, automation, or repeatability.
- Customize both the shell and terminal configuration. Choose a usable color theme and configure a concise prompt with useful context such as the current directory, version-control status, and time. Avoid adding information that does not affect your next action.
- Add context-specific command completion for the tools you use most, then create short aliases or functions for commands you repeatedly type or forget. Add interactive safeguards to destructive commands when appropriate, such as `alias rm='rm -iv'`.
- Identify the available shells when moving to a new environment, and bring your preferred shell and preserved configuration when practical. Evaluate alternatives when the current shell cannot express a needed workflow.
