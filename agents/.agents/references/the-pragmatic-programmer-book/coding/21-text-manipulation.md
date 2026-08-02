## 21. Text Manipulation

General-purpose text manipulation languages and tools such as shells, `awk`, `sed`, Python, and Ruby handle custom transformations beyond specialized tools and let engineers prototype ideas, transform data, integrate programs and networks, and automate project workflows far faster than heavier implementation approaches. They can coordinate builds, extract tested code into documentation, convert and publish content, update websites, and generate indexes. Keep manipulable content in plain text when practical, invest time in mastering one of these tools, and protect against its ability to corrupt many files at once with validation and recoverable changes.

### The Pragmatic Approach

- Learn one general-purpose text manipulation language well enough to write small utilities quickly; choose shell tools for concise pipelines or Python or Ruby when the task benefits from clearer structure.
- Prototype uncertain ideas with a short script before committing to a larger implementation, so an experiment costs minutes or hours instead of days.
- Automate repeated text workflows, including builds, format conversion, code extraction, syntax highlighting, index generation, and publishing steps.
- Use text manipulation scripts as glue to interact with programs, communicate over networks, drive web workflows, and perform calculations alongside text processing.
- Keep authoritative content in plain text when practical so scripts can inspect, transform, combine, and publish it with standard tools.
- Generate derived text from its authoritative source instead of copying it. For example, extract a named section from a tested source file whenever documentation is built so the example stays synchronized with the program.
- Make bulk transformations deterministic and narrowly scoped. For example, convert each `.yaml` configuration file into a corresponding `.json` file, or report camelCase identifiers before changing them to snake_case.
- Test transformations on representative inputs, validate generated results, review the changes, and keep backups before modifying source files in place.
