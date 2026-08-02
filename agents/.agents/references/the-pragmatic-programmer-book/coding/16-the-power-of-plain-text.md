## 16. The Power of Plain Text

Store persistent knowledge in human-understandable, self-describing plain text, including structured formats such as JSON, YAML, and HTML, so people and programs can interpret it without the application that created it. Plain text resists obsolescence, permits partial data recovery, works with editors, version control, search, comparison, checksum, and command-line tools, simplifies test-data creation and output analysis, and provides a dependable interchange format across heterogeneous or minimal environments.

### The Pragmatic Approach

- Prefer plain text for configuration, test fixtures, test output, documentation, and data interchange when its benefits outweigh binary-format performance advantages.
- Make text human-understandable, not merely printable. Use descriptive names and recognizable values such as `customer_phone=555-0100`, not `Field19=467abe`.
- Use established structured text formats such as JSON or YAML when data needs explicit fields and extensibility.
- Design text formats so engineers can recover useful records with partial knowledge of the format. Preserve meaningful field names and recognizable value formats instead of encoding context only in application logic.
- Use existing text tools to inspect, search, filter, compare, transform, and verify data. For example, search configuration recursively, review a diff before deployment, and calculate a checksum to detect unexpected changes.
- Keep plain-text configuration under version control to preserve change history and make environment-specific changes reviewable.
- Build system and regression tests around editable plain-text fixtures and machine-searchable plain-text output so engineers can add cases and analyze failures without custom tooling.
- Treat binary representations as optional performance optimizations when needed, and retain a plain-text interface for inspection, recovery, and maintenance.
- Prefer plain-text protocols and formats at integration boundaries so systems with different implementations can communicate through a common, tool-friendly representation.
