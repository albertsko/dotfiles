# TUI rules

This file holds language-neutral rules for designing, building, and reviewing a full-screen TUI, as a client program of a CLI's domain core or as a TUI-first tool.

## Terms

The terms in SKILL.md and arch.md apply, for example TTY, Agent, Script, Domain core, Client program, and Protocol. New terms:

- **TUI**: a full-screen terminal UI that takes over the terminal window and redraws it, for example htop or lazygit. Prompts and progress lines are not a TUI.
- **TUI-first tool**: a tool whose TUI is the main way people use it, for example htop. A tool with named agent or script users is not TUI-first. Any other tool with a TUI is a **CLI with a TUI**.
- **Durable action**: a TUI feature that gets new data from the domain core or changes data, for example a search that asks the core for matches, a kill, or an upgrade PR. It needs a CLI path (TUI-2).
- **Screen change**: a TUI feature that only rearranges data the TUI has already loaded, including rows scrolled off screen, for example a sort or filter of the loaded list, scroll, focus, or layout. It needs no CLI path.
- **Elm Architecture**: a structure that splits a TUI into five parts: model, message, update, view, and command.
- **Model**: the plain data that holds all TUI state.
- **TUI message** (short: message): a value that describes one event, for example a key press, a resize, a timer tick, a domain core event, or a command result. Write "TUI message" where a reader could take it for a protocol message.
- **Update**: the function that takes the model and one message, and returns the new model and any commands. **Init** is the start step that returns the first model and commands.
- **View function** (short: view): the function that turns the model into the screen content. **Screen** means what the terminal shows.
- **Command**: a value that describes one side effect. The runtime (the event loop of the framework or of your code) runs it. In this file, "command" means this value, and a command of the CLI is a "CLI command".
- **Component**: one part of the screen, such as a pane, with its own part of the model, its own update, and its own view.
- **Raw mode**: a terminal mode that sends each key press to the program at once, with no echo and no line editing.
- **Alternate screen**: a second terminal buffer for full-screen programs. The shell content comes back when the program leaves it.
- **Accessible mode**: a setting that switches the TUI to output that screen readers can follow (TUI-42).

## How to use this file

- The core rules in SKILL.md, cli.md, and arch.md win on CLI behavior and program structure. Each section's pointer lines ("Core rules", "CLI-facing rules", "Structure rules") list the rules from those files that also apply to the TUI. A pointer line does not change the "Applies at" line of an arch.md rule.
- Framework names (Ratatui, Bubble Tea) appear only in examples. The rules apply to any framework and to a hand-written loop.
- The numbers in this file are examples, not defaults.

## CLI first, TUI later

TUI-1 applies to every tool: the CLI and the domain core come first, and the TUI is a client program of the domain core.

- For a CLI with a TUI, TUI-2 checks that the TUI adds no durable action without a CLI path.
- For a TUI-first tool, TUI-1 means that the CLI path for each durable action exists before or with the TUI (TUI-2). TUI-1 then passes.
- A draft that defers the CLI to a later release fails TUI-1.

Classify each TUI feature for TUI-2 using Durable action and Screen change in Terms.

CLI-facing rules: CLI-72.
Structure rules: ARCH-4, ARCH-6, ARCH-12, ARCH-13, ARCH-15, ARCH-19, ARCH-50, ARCH-54, ARCH-76.

- **TUI-1** Design the CLI and the domain core first, and add the TUI as one client program of that core. A TUI built first grows features and state that the CLI cannot reach. `[S2]`
- **TUI-2** Give every durable action a CLI path (CLI-72), built before or with the TUI. When the action works on a selection, the CLI accepts the same items, for example by ID. `[S2]`

Notes:

- A TUI that drives the domain core is a client program, also when it ships in the same binary as the CLI, as in mxr and spotuify. The CLI plus such a TUI makes two client programs (ARCH-4).

## Terminal lifecycle

Core rules: CORE-8, CORE-10, CORE-12.
CLI-facing rules: CLI-8, CLI-17, CLI-23, CLI-47, CLI-64, CLI-80, CLI-101, CLI-102, CLI-103, CLI-113.

- **TUI-3** Open the TUI only when stdin and stdout are both TTYs and `--no-input` is not set (CORE-8, CORE-10, CLI-23). Otherwise follow CLI-8 or CLI-17, so a pipe, a script, or an agent never gets a full-screen UI. `[S2]`
- **TUI-4** Turn on each terminal mode separately, only when the TUI uses it, and turn every one off on exit. Examples: raw mode, alternate screen, mouse capture, bracketed paste, hidden cursor. `[S7,S8]`
- **TUI-5** Consider drawing the TUI on the alternate screen, and print final results after you leave it. Final results then stay visible in the shell. `[S7]`
- **TUI-6** Restore the terminal on every exit path: normal quit, error, crash, and a crash inside background work. A missed restore leaves the shell with no echo and no cursor. `[S7,S9]`
- **TUI-7** In a crash, restore the terminal first and ignore restore errors, then print the report in the shell. Consider also writing the report to a log file (CLI-47). `[S7,S9]`
- **TUI-8** Treat Ctrl-C as quit (CLI-101), and bind a quit key (CLI-64). In raw mode, the terminal no longer turns Ctrl-C into SIGINT, so the TUI must handle it. `[S7,S8]`
- **TUI-9** Consider one terminal object with paired enter and restore steps. Restore undoes the modes in reverse order, is safe to call twice, runs from cleanup hooks, and stops the input reader first. `[S7]`
- **TUI-10** When the TUI suspends (Ctrl-Z) or runs an editor or another interactive program, consider this order: restore the terminal, suspend or run the child and wait, re-enter the modes, then clear and repaint. The child needs the terminal in its original state. `[S7]`

Notes:

- Example for TUI-3: in mxr and spotuify, a bare CLI command opens the TUI.
- Example for TUI-7: Ratatui restores the terminal in a panic hook, because an error in the restore can hide the crash reason.
- Example for TUI-6: at the time of the leg100 post, Bubble Tea recovered panics in its event loop, but not inside commands.
- The Ratatui recipe clears the terminal after the child exits, so that the TUI repaints correctly (TUI-10).
- Windows has no SIGTSTP, so Ctrl-Z suspend works on Unix only. Take the editor from `EDITOR` (CLI-113).

## State model

Structure rules: ARCH-12, ARCH-19, ARCH-51, ARCH-64, ARCH-65, ARCH-72, ARCH-75.

- **TUI-11** Structure every TUI as model, message, update, view, and command (the Elm Architecture). A throwaway tool may skip this (`n/a`). `[S2,S7,S8]`
- **TUI-12** Keep all TUI state in one model of plain data, except buffers under TUI-21. The model holds only view state, including read-only data copied from domain core events (ARCH-12, ARCH-19). `[S2,S7,S8]`
- **TUI-13** Turn every input and event into a TUI message (key, resize, timer tick, domain core event, command result), and send all messages through one path to update. `[S2,S7,S8]`
- **TUI-14** Change the model only inside update, and return the model unchanged for a message that update does not handle. Callbacks, command handlers, and background tasks that change the model cause race conditions. `[S2,S7,S8,S9]`
- **TUI-15** Make view a pure function of the model, with no I/O and no state changes. The one exception: view may adjust the scroll offset to keep the selection visible. `[S2,S7,S8]`
- **TUI-16** Return every side effect from update or init as a command, for example load data, call the domain core, start a timer, or run an editor. The runtime runs it and sends the result back as a message. `[S2,S7,S8]`
- **TUI-17** Pass the current time and random values into update inside messages. Update then gives the same result for the same inputs, so you can test and replay it. `[S2]`
- **TUI-18** Keep the state of each command (pending, done, failed) in the model, and show it on screen as text. A command that fails or ends with no visible result looks broken or hung. `[S2,S8,S10]`
- **TUI-19** When update or the model grows large, split them into components by pane or topic, with a parent update that delegates to child updates and wraps their commands. A small TUI needs only one update. `[S2,S7,S9]`
- **TUI-20** In a tree of components, consider letting the root handle global keys (quit, help), routing other input only to the focused component, and sending resize messages to every component. `[S7,S9]`
- **TUI-21** Consider keeping high-churn data, such as per-frame data or large buffers, in mutable buffers outside the model, behind a small interface. `[S2]`

Notes:

- Example commands: a Bubble Tea `Cmd` and an Elm `Cmd` (TUI-16).
- Example for TUI-19: an audit of spotuify flagged a TUI model with 79 fields.
- A component may own its view state. Domain state stays in the domain core (ARCH-12).

## Event loop and async work

CLI-facing rules: CLI-78.
Structure rules: ARCH-38, ARCH-39, ARCH-67, ARCH-69, ARCH-71, ARCH-72.

- **TUI-22** Run one loop: draw the view, block until the next message from any source, run update, start the returned commands, and repeat. The screen changes only when the loop draws. `[S2,S7]`
- **TUI-23** Read terminal input in one reader that feeds the loop, so key presses stay in order. Text input turns into garbage when key order breaks. `[S7,S9]`
- **TUI-24** Keep update and view fast, and do slow work (disk, network, heavy compute) inside commands. A blocked loop freezes the screen and delays every key press. `[S7,S8,S9]`
- **TUI-25** Treat concurrent commands as finishing in any order. When order matters, let the result message of step A start step B. `[S2,S7,S9]`
- **TUI-26** Consider limiting how fast sources create messages, with a slow logic tick and a separate render rate, both tunable (for example 4 ticks and 60 frames per second). Messages that back up delay key presses. `[S7,S9]`
- **TUI-27** Consider seeding the model again from the domain core's snapshot on reconnect and after the TUI falls behind, and keeping old content on screen until new content arrives. ARCH-72 covers the seed at start. `[S2]`

## Layout and rendering

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

- **TUI-33** Consider keyboard parity: let a keyboard-only user discover, reach, perform, and recover from every user intention, including screen changes such as scrolling a pane, and make each control look active when its shortcut works. Otherwise some actions stay hidden or mouse-only. `[S2]`
- **TUI-34** Consider one action registry that the keymap, help screen, action palette, and status hints all derive from, at the latest when two of them first disagree. Hand-kept lists drift, for example a key that archives while the palette names another action. `[S2]`
- **TUI-35** Consider one registry entry per durable action, with a stable ID, label, group, key, a check with no side effects that says if the action is available now, and a function that runs it without UI state. `[S2]`
- **TUI-36** Consider keeping the keys for screen changes (list movement, scroll, pane focus) with the component that owns focus, outside the registry, with their own help text and tests. A registry alone does not prove parity. `[S2]`
- **TUI-37** Consider documenting keyboard support (what works now, what is a target, and the known gaps), and recording keyboard decisions in a decision record. `[S2]`
- **TUI-38** Consider handling only key press events, and ignoring release and repeat events unless the UI needs them. Some terminals also report release and repeat events. `[S7]`

Notes:

- A shortcut runs a durable action through the protocol (ARCH-13).

## Color and accessibility

Core rules: CORE-12.
CLI-facing rules: CLI-5, CLI-20, CLI-24, CLI-25, CLI-26, CLI-29, CLI-30, CLI-31, CLI-33, CLI-40, CLI-44, CLI-75.

The sources study line-based CLIs, not full-screen TUIs. The rules below apply their findings to TUIs.

- **TUI-39** Offer a way to read long content and tables outside the full screen, for example an export to a file, a pager, or the matching CLI command in a flat format (CLI-24, CLI-25). Screen-reader users consistently found navigating the terminal difficult. `[S10]`
- **TUI-40** Consider stating structure and state in text, not only by position, column alignment, glyph, or color. The terminal gives screen readers no structure markup, so users often read it line by line. `[S10,S11]`
- **TUI-41** Consider static text progress that names the action, at least in accessible mode. Use it in place of spinners, progress bars, ASCII-art decoration, and constant redraws, because screen readers read glyphs aloud. `[S10,S11]`
- **TUI-42** Consider an accessible mode, turned on by a flag, setting, or env var, with prompts that screen readers can read, static text progress, and the 16 ANSI colors. `[S11]`
- **TUI-43** Consider testing the TUI with a screen reader. The study found that a text-based, keyboard-driven CLI is not necessarily fully accessible. `[S10]`
- **TUI-44** Consider status and error text that makes sense when read aloud, with no regular expressions, domain-specific acronyms, or URLs. `[S10]`
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

- **TUI-46** Test update with plain values: pass a model and a message, then check the new model and the returned command value, with no terminal and no mocked I/O. `[S2,S7]`
- **TUI-47** Consider letting the runtime intercept commands, to log them or replace them with fakes in tests, and recording message sequences to replay a session. `[S2]`
- **TUI-48** Test the view by rendering into an in-memory terminal of fixed size and comparing it with a stored snapshot, and review each snapshot diff before you accept it. `[S7,S9]`
- **TUI-49** Consider end-to-end tests that send key presses to the running TUI and check the screen and the exit. `[S9]`
- **TUI-50** While the TUI owns the terminal, write logs to a file, never to stdout or stderr, and turn file logging on by env var or flag. `[S7,S8]`
- **TUI-51** Consider debug aids: a log file in a documented location with no color codes, logging that starts before the terminal modes, a log line per message and command around update, a toggle that shows the model, and a debugger in a second terminal. `[S2,S7,S8,S9]`

Notes:

- CORE-2 still applies to line-based runs and to output after restore. During the TUI session, log lines on the terminal break the screen (TUI-50).
- Watch the log with `tail -f` in a second terminal (TUI-50).
- Expect to regenerate snapshots after small content changes (TUI-48).
- Example for TUI-51: the first message Bubble Tea sends is the terminal size, so log it too.

## Not covered

The sources raise these topics but give no rules.

- Help bar and help overlay layout.
- Standard key maps (arrows, Vim keys, `?`, `/`), and key conflicts between modes and focus stacks.
- Mouse conventions: click, scroll, and text selection while mouse capture is on.
- Minimum terminal size, and what to show when the terminal is too small.
- Redraw policy beyond TUI-22: resize storms, redraw cost, and redraws on a timer.
- Signals in raw mode beyond Ctrl-C and Ctrl-Z, for example SIGTERM, SIGHUP, and SIGWINCH.
- Which streams the TUI uses: drawing on stdout or stderr, and reading keys from the terminal while data comes on a piped stdin. TUI-3 assumes stdin and stdout.
- Cancelling a running command whose result is no longer needed.
- A TUI that loses its connection to the domain core mid-session, beyond seeding the model again (TUI-27).
- How a blocking terminal read meets async domain core events.
- Unicode width, wide characters, and grapheme clusters.
- Screen readers with full-screen TUIs: announcing changes, braille cursor position beyond TUI-32, reduced motion, and detection.
- Contrast thresholds for terminal colors.
- Test strategy for async commands (fake clock, fake backend).
- Platform differences in raw mode, the alternate screen, mouse events, and key events.
