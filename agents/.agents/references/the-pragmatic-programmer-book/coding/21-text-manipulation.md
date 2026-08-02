## 21. Text Manipulation

Text manipulation languages and tools such as shell utilities, `awk`, `sed`, Python, and Ruby let engineers prototype ideas, transform data, and automate project workflows far faster than heavier implementation approaches. Their value extends beyond search and replacement: they can coordinate builds, extract tested code into documentation, convert markup, generate indexes, update websites, and connect programs or networks. Because a faulty transformation can corrupt many files at once, effective use requires practice, validation, and recoverable changes.

### The Pragmatic Approach

- Learn one general-purpose text manipulation language well enough to write small utilities quickly; choose shell tools for concise pipelines or Python or Ruby when the task benefits from clearer structure.
- Prototype uncertain ideas with a short script before committing to a larger implementation, so an experiment costs minutes or hours instead of days.
- Automate repeated text workflows, including builds, format conversion, code extraction, syntax highlighting, index generation, and publishing steps.
- Keep authoritative content in plain text when practical so scripts can inspect, transform, combine, and publish it with standard tools.
- Generate derived text from its authoritative source instead of copying it. For example, extract a named section from a tested source file whenever documentation is built so the example stays synchronized with the program.
- Make bulk transformations deterministic and narrowly scoped. For example, convert each `.yaml` configuration file into a corresponding `.json` file or report camelCase identifiers before changing them to snake_case.
- Test transformations on representative inputs, validate every generated result, review the diff, and keep backups before modifying source files in place.
