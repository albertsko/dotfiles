# TUI rules

This file holds language-neutral rules for designing, building, and reviewing a full-screen TUI, as an interface to shared application operations, including TUI-first tools.

## Terms

The terms in SKILL.md and arch.md apply, for example TTY, Agent, Script, Domain core, Application service, Client, and Protocol. New terms:

- **TUI**: a full-screen terminal UI that takes over the terminal window and redraws it, for example htop or lazygit. Prompts and progress lines are not a TUI.
- **TUI-first tool**: a tool whose primary human interface is a TUI, for example htop. It may also expose selected operations to scripts or agents.
- **Application action**: a query or mutation through the application service, such as a search for new data, a kill, or an upgrade PR. TUI-2 decides which actions need a CLI path.
- **Screen change**: a TUI feature that only rearranges data the TUI has already loaded, including rows scrolled off screen, for example a sort or filter of the loaded list, scroll, focus, or layout. It needs no CLI path.
- **Elm Architecture**: a structure that splits a TUI into five parts: model, message, update, view, and command.
- **Model**: the replayable data that holds view state. Runtime dependencies, such as context and application clients, live alongside it with explicit ownership.
- **TUI message** (short: message): a value that describes one event, for example a key press, a resize, a timer tick, an application service event, or a command result. Write "TUI message" where a reader could take it for a protocol message.
- **Update**: the function that takes the model and one message, and returns the new model and any commands. **Init** is the start step that returns the first model and commands.
- **View function** (short: view): the function that turns the model into the screen content. **Screen** means what the terminal shows.
- **Command**: an effect returned to the runtime. It may be inspectable data or an opaque framework closure such as a Bubble Tea Cmd. Tests must match that representation (TUI-46). A command-line invocation is a **CLI command**.
- **Component**: one part of the screen, such as a pane, with its own part of the model, its own update, and its own view.
- **Raw mode**: a terminal mode that sends each key press to the program at once, with no echo and no line editing.
- **Alternate screen**: a second terminal buffer for full-screen programs. The shell content comes back when the program leaves it.
- **Accessible mode**: a setting that switches the TUI to output that screen readers can follow (TUI-42).

## How to use this file

- The core rules in SKILL.md, cli.md, and arch.md win on CLI behavior and program structure. Each section's pointer lines ("Core rules", "CLI-facing rules", "Structure rules") list the rules from those files that also apply to the TUI. A pointer line does not change the "Applies at" line of an arch.md rule.
- Framework names (Ratatui, Bubble Tea) appear only in examples. The rules apply to any framework and to a hand-written loop.
- The numbers in this file are examples, not defaults.

## Shared operations and CLI parity

Decide parity from the intended workflows. A product can require every application action to be available through the CLI, or be TUI-first with selected automation capabilities. Record that choice; the presence of a TUI does not force a wire protocol, daemon, or a CLI-first release.

Distinguish application actions from presentation-only screen changes using Terms.

CLI-facing rules: CLI-72.
Structure rules: ARCH-4, ARCH-6, ARCH-12, ARCH-13, ARCH-15, ARCH-19, ARCH-50, ARCH-54, ARCH-76.

- **TUI-1** Share domain rules and application operations across the CLI and TUI. Keep presentation and interaction in their adapters. Choose implementation/release order from the product's workflows; CLI-first is a useful default when complete automation parity is a requirement. `[S2]`
- **TUI-2** For each application action promised to scripts or agents, provide a noninteractive CLI path or the selected public protocol. If the product promises complete CLI parity, map all application actions. Accept the same stable target selections. Screen-only focus, layout, and scrolling need no equivalent command. `[S2]`

Notes:

- A CLI and TUI can be two in-process interfaces to the same application service (ARCH-4). Typed function calls suffice when they share one build; independent peers may need a wire protocol (ARCH-2).

## Terminal lifecycle

Core rules: CORE-8, CORE-10, CORE-12.
CLI-facing rules: CLI-8, CLI-17, CLI-23, CLI-47, CLI-64, CLI-80, CLI-101, CLI-102, CLI-103, CLI-113.

- **TUI-3** Start a TUI only with a usable interaction terminal and --no-input unset. For automatic startup, require terminal input and display streams and human output mode. An explicit interactive mode may open a controlling terminal while data uses pipes; keep UI bytes off contracted result/error streams. If interaction is unavailable, return a usage error naming a noninteractive command, or use a documented noninteractive default. TTY presence does not prove a human is present. `[S2]`
- **TUI-4** Change only the terminal modes the TUI uses, and restore the incoming state for those changes on exit. Save prior state or use supported push/pop mechanisms where available. For modes without state queries or stacks, define ownership and a restoration policy with the caller. Examples: raw mode, alternate screen, mouse capture, bracketed paste, hidden cursor. `[S7,S8]`
- **TUI-5** Consider drawing the TUI on the alternate screen, and print final results after you leave it. Final results then stay visible in the shell. `[S7]`
- **TUI-6** Restore terminal modes on normal quit, handled error, cancellation, and recovered background failure, within the cleanup budget (CLI-80). During shutdown, preserve an independently serviced emergency-key path until terminal-generated interrupts are verified working. Restoring the necessary input signal flags may precede waiting for output cleanup. An OS signal handler alone cannot receive raw Ctrl-C keys (TUI-8). Uncatchable termination and forced emergency exits are outside the restoration guarantee. Minimize modes and document terminal recovery for those cases (CLI-102). `[S7,S9]`
- **TUI-7** In a crash, restore the terminal first and ignore restore errors, then print the report in the shell. Consider also writing the report to a log file (CLI-47). `[S7,S9]`
- **TUI-8** Bind a discoverable, reliable quit action and define Ctrl-C behavior. Default to quitting a simple dashboard. A modal or editing interface may cancel the current operation while preserving its session. Handle Ctrl-C as a key in raw mode, where it no longer produces SIGINT. External signals retain the cleanup policy in CLI-101 to CLI-103. `[S7,S8]`
- **TUI-9** Suspend ordinary UI input and terminal writers, including the renderer, before restoring display modes or handing off the terminal. Settle in-flight terminal I/O within the cleanup budget, preserving the shutdown emergency path under TUI-6. Restore modes under TUI-4 using the framework's terminal release mechanism where available. Restoring modes alone does not stop background output. `[S7,S8]`
- **TUI-10** When suspending or running an interactive child, release terminal I/O under TUI-9 and restore modes. Stop all application terminal readers, including any emergency-key reader, before handing over control. Wait for the child or suspension to end. On resume, reacquire terminal ownership, re-enter modes, refresh dimensions, and resume input/rendering with a full repaint. Use the framework's supported suspend/exec/resume path where available. `[S7,S8]`

Notes:

- A terminal wrapper can pair entry and cleanup, unwind modes in reverse order, and make repeated restoration safe (TUI-9).
- Example for TUI-3: in mxr and spotuify, a bare CLI command opens the TUI.
- Example for TUI-7: Ratatui restores the terminal in a panic hook, because an error in the restore can hide the crash reason.
- Example for TUI-6: at the time of the leg100 post, Bubble Tea recovered panics in its event loop, but not inside commands.
- The Ratatui recipe clears the terminal after the child exits, so that the TUI repaints correctly (TUI-10).
- Windows has no SIGTSTP, so Ctrl-Z suspend works on Unix only. Take the editor from `EDITOR` (CLI-113).

## State model

TUI-11 selects the pattern. Model/update/view-specific requirements apply to a selected message-driven design; other frameworks meet equivalent ownership and testability outcomes without adopting the vocabulary mechanically.

Structure rules: ARCH-12, ARCH-19, ARCH-51, ARCH-64, ARCH-65, ARCH-72, ARCH-75.

- **TUI-11** Consider model, message, update, view, and command (the Elm Architecture) for a message-driven TUI. Other patterns are valid when ownership, effects, cancellation, and tests are explicit. The model/update-specific rules below apply when that pattern is selected. `[S2,S7,S8]`
- **TUI-12** Keep replayable view state in a plain-data model, including snapshots of application data. Keep runtime dependencies such as contexts, service clients, and terminal handles separate from replayable data, even if a framework wrapper stores both. TUI-21 covers explicitly owned large buffers. `[S2,S7,S8]`
- **TUI-13** Turn every input and event into a TUI message (key, resize, timer tick, application service event, command result), and send all messages through one path to update. `[S2,S7,S8]`
- **TUI-14** With a model/update loop, change model state inside update. Leave unhandled messages unchanged. Background tasks return messages instead of mutating the model. The narrow render-owned scroll adjustment in TUI-15 is the only rendering exception; exclude it from pure update replay expectations. `[S2,S7,S8,S9]`
- **TUI-15** Keep view free of I/O and application-state changes. Prefer deriving layout and scroll before rendering. A stateful widget may adjust its exclusively owned scroll offset during rendering; document that exception and test final layout separately from pure update replay. `[S2,S7,S8]`
- **TUI-16** With an effect-driven loop, return slow or external work from init/update as commands: loading data, calling the application service, timers, or editors. The runtime executes them and reports results as messages. Interactive children require terminal handoff under TUI-10. Framework closures and application effect descriptions need different tests (TUI-46). `[S2,S7,S8]`
- **TUI-17** Pass the current time and random values into update inside messages. Update then gives the same result for the same inputs, so you can test and replay it. `[S2]`
- **TUI-18** Track visible asynchronous operations as pending, completed, or failed, and show useful text feedback. Internal timer ticks, cursor work, and transport effects need no separate status. One logical user operation may contain several internal commands. `[S2,S8,S10]`
- **TUI-19** When update or the model grows large, split them into components by pane or topic, with a parent update that delegates to child updates and wraps their commands. A small TUI needs only one update. `[S2,S7,S9]`
- **TUI-20** In a tree of components, consider letting the root handle global keys (quit, help), routing other input only to the focused component, and sending resize messages to every component. `[S7,S9]`
- **TUI-21** Consider separately owned mutable buffers for high-churn data too large for ordinary model copies. State who writes and reads them, and synchronize or snapshot across concurrent access; this is an ownership tradeoff, not an exception allowing races. `[S2]`

Notes:

- Example commands: a Bubble Tea `Cmd` and an Elm `Cmd` (TUI-16).
- Example for TUI-19: an audit of spotuify flagged a TUI model with 79 fields.
- A component may own its view state. Domain state stays in the application service (ARCH-12).

## Event loop and async work

CLI-facing rules: CLI-78.
Structure rules: ARCH-38, ARCH-39, ARCH-67, ARCH-69, ARCH-71, ARCH-72.

- **TUI-22** For a message-driven TUI, use one state-update path: receive a message, update state, start returned effects, and render when needed. Timers and async sources feed that path. Rendering may be coalesced at its own bounded rate rather than redrawing for every message. `[S2,S7]`
- **TUI-23** Read terminal input in one reader that feeds the loop, so key presses stay in order. Text input turns into garbage when key order breaks. `[S7,S9]`
- **TUI-24** Keep update and view fast, and do slow work (disk, network, heavy compute) inside commands. A blocked loop freezes the screen and delays every key press. `[S7,S8,S9]`
- **TUI-25** Treat concurrent commands as finishing in any order. When order matters, let the result message of step A start step B. `[S2,S7,S9]`
- **TUI-26** Consider limiting how fast sources create messages, with a slow logic tick and a separate render rate, both tunable (for example 4 ticks and 60 frames per second). Messages that back up delay key presses. `[S7,S9]`
- **TUI-27** For asynchronous requests, reject obsolete results using request/input versions. Cancel unnecessary work where its operation contract permits cancellation. When a snapshot/event stream exists, consider reseeding on reconnect or missed events to satisfy ARCH-19. Ordinary in-process queries need no event bus or cache solely for the TUI. `[S2]`

## Layout and rendering

CLI-facing rules: CLI-28 when rendering untrusted text. Verify the renderer's handling of terminal controls while preserving trusted rendering instructions and declared raw payloads.

- **TUI-28** Read the terminal size at start and on every resize, and compute every area from it on each draw. The TUI is responsible for fitting the terminal. `[S7,S9]`
- **TUI-29** Measure the fixed parts (header, footer, borders), give the content the remaining space, and say which area takes leftover space. Hard-coded heights and widths break, for example when you add a border. `[S7,S9]`
- **TUI-30** Consider these layout checks: nested areas from one root, constraints that can all hold at once, clamped sizes for panes the user resizes, every draw inside the screen, and tests at small sizes. `[S7]`
- **TUI-31** Consider drawing every frame in full, back to front, into an off-screen buffer, and writing only the changed cells to the terminal. Let each popup clear its own area first, or old content shows through it. `[S7]`
- **TUI-32** Consider passing each screen section only its own view state from the model (TUI-12), and letting view place the terminal cursor in the active text field. `[S7]`

Notes:

- Example for TUI-30: the Ratatui recipe clamps panes between 5 and 95 percent.
- Example for TUI-15 and TUI-32: in Ratatui, stateful widgets adjust the scroll offset during the draw, and view can set the cursor.

## Input and keybindings

CLI-facing rules: CLI-4, CLI-64.
Structure rules: ARCH-13.

The quit key is in TUI-8, and mouse capture is in TUI-4.

- **TUI-33** Provide keyboard access to the product's supported actions and screen navigation, with discoverable active shortcuts. If the product intentionally depends on another input device, document that scope and accessibility limitation. `[S2]`
- **TUI-34** Consider one action registry that the keymap, help screen, action palette, and status hints all derive from, at the latest when two of them first disagree. Hand-kept lists drift, for example a key that archives while the palette names another action. `[S2]`
- **TUI-35** Consider one registry entry per application action, with stable ID, label, group, key, an availability check without side effects, and an operation independent of transient UI state. Availability hints do not replace application authorization at execution. `[S2]`
- **TUI-36** Consider keeping the keys for screen changes (list movement, scroll, pane focus) with the component that owns focus, outside the registry, with their own help text and tests. A registry alone does not prove parity. `[S2]`
- **TUI-37** Consider documenting keyboard support (what works now, what is a target, and the known gaps), and recording keyboard decisions in a decision record. `[S2]`
- **TUI-38** Consider ignoring key release events unless the UI needs them, preserving repeats for navigation and text editing, and suppressing repeats for one-shot actions. When enhanced event reporting is supported, test it alongside legacy input where repeated keys arrive as presses. `[S7]`

Notes:

- A shortcut invokes an application action through the shared API, or the selected wire protocol when a transport boundary exists (ARCH-13).

## Color and accessibility

Core rules: CORE-12.
CLI-facing rules: CLI-5, CLI-20, CLI-24, CLI-25, CLI-26, CLI-29, CLI-30, CLI-31, CLI-33, CLI-40, CLI-44, CLI-75.

The sources study line-based CLIs, not full-screen TUIs. The rules below apply their findings to TUIs.

- **TUI-39** Offer a way to read long content and tables outside the full screen, for example an export to a file, a pager, or the matching CLI command in a flat format (CLI-24, CLI-25). Screen-reader users consistently found navigating the terminal difficult. `[S10]`
- **TUI-40** Consider stating structure and state in text, not only by position, column alignment, glyph, or color. The terminal gives screen readers no structure markup, so users often read it line by line. `[S10,S11]`
- **TUI-41** Consider static text progress that names the action, at least in accessible mode. Use it in place of spinners, progress bars, ASCII-art decoration, and constant redraws, because screen readers read glyphs aloud. `[S10,S11]`
- **TUI-42** Consider an accessible mode, turned on by a flag, setting, or env var, with prompts that screen readers can read, static text progress, and the 16 ANSI colors. `[S11]`
- **TUI-43** Consider testing the TUI with a screen reader. The study found that a text-based, keyboard-driven CLI is not necessarily fully accessible. `[S10]`
- **TUI-44** Consider status and error text that makes sense when read aloud: explain unfamiliar acronyms and expression constraints in words, and label useful links. Preserve exact expressions, URLs, and other actionable details alongside the explanation or through a clearly identified accessible surface. `[S10]`
- **TUI-45** Consider the 16 ANSI colors for default styling, choosing colors that work on light and dark backgrounds. Users can then recolor the TUI in their terminal settings. `[S11]`

Notes:

- CLI-29, CLI-31, and CLI-75 stay the default. TUI-41 adds text progress at least in accessible mode, and does not forbid spinners elsewhere.
- CORE-12 decides when color is off. TUI-45 only says which colors to use when color is on.
- CLI-20 and CLI-40 are listed because the study found that screen-reader users need web docs and a known output structure.
- Example for TUI-41: a screen reader read a spinner aloud as "Little dots submit, little blah, blah".
- Example for TUI-42: `gh a11y` in the GitHub CLI.

## Testing and debugging

CLI-facing rules: CLI-131.
Structure rules: ARCH-40, ARCH-78.

- **TUI-46** For a model/update design, test transitions with plain inputs and assert state plus inspectable effect descriptions. Opaque command closures cannot be meaningfully compared as values: test their execution with injected controlled dependencies, or adapt from inspectable application effects. Keep those effect tests distinct from pure transition tests. `[S2,S7]`
- **TUI-47** Consider logging effect descriptions and recording message sequences for replay. For opaque framework commands, inject controlled dependencies or provide an application-level descriptor/runner boundary; interception alone does not make a closure inspectable. `[S2]`
- **TUI-48** Test rendering at fixed sizes with semantic assertions and, where useful, reviewed snapshots. Use a final View result or an emulated terminal's final cells. Stripping ANSI from a raw redraw transcript does not reconstruct a screen. `[S7,S9]`
- **TUI-49** Consider end-to-end tests sending input to a running TUI and checking its final screen, exit, and restored modes. Bound the whole process lifetime and always kill/reap a stuck child. `[S9]`
- **TUI-50** While the TUI owns a terminal, keep ordinary logs off that terminal. Use an explicitly enabled redacted file log or a separate diagnostic channel that cannot corrupt the screen or machine-output contract. `[S7,S8]`
- **TUI-51** Consider debug aids: a log file in a documented location with no color codes, logging that starts before the terminal modes, a log line per message and command around update, a toggle that shows the model, and a debugger in a second terminal. `[S2,S7,S8,S9]`

Notes:

- CORE-2 still applies to line-based runs and to output after restore. During the TUI session, log lines on the terminal break the screen (TUI-50).
- Watch the log with `tail -f` in a second terminal (TUI-50).
- Review intentional snapshot changes and keep behavior assertions independent of decorative rendering (TUI-48).
- Example for TUI-51: log Bubble Tea's initial size message whenever it arrives. Other startup messages or init results can arrive first; handle dimensions that are not known yet.

## Not covered

The sources raise these topics but give no rules.

- Help bar and help overlay layout.
- Standard key maps (arrows, Vim keys, `?`, `/`), and key conflicts between modes and focus stacks.
- Mouse conventions: click, scroll, and text selection while mouse capture is on.
- Minimum terminal size, and what to show when the terminal is too small.
- Redraw policy beyond TUI-22: resize storms, redraw cost, and redraws on a timer.
- Signals in raw mode beyond Ctrl-C and Ctrl-Z, for example SIGTERM, SIGHUP, and SIGWINCH.
- Platform-specific mechanisms for opening a separate interaction terminal and integrating it with a framework (the channel contract is in TUI-3).
- Framework-specific cancellation primitives and fake-clock techniques.
- A TUI that loses its connection to the application service mid-session, beyond seeding the model again (TUI-27).
- How a blocking terminal read meets async application service events.
- Unicode width, wide characters, and grapheme clusters.
- Screen readers with full-screen TUIs: announcing changes, braille cursor position beyond TUI-32, reduced motion, and detection.
- Contrast thresholds for terminal colors.
- Test strategy for async commands (fake clock, fake backend).
- Platform differences in raw mode, the alternate screen, mouse events, and key events.
