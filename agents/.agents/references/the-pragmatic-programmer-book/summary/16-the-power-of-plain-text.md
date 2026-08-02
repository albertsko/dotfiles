## 16. The Power of Plain Text

Plain text stores knowledge as printable, human-understandable information whose meaning travels with the data, so people and programs can use it without depending on the application that created it; structured formats such as HTML, JSON, and YAML still qualify. Self-describing text resists obsolescence because it can often be recognized and partially parsed after the original software disappears, and its common form works across heterogeneous systems and minimal recovery environments. Editors, version control, search, comparison, checksum, shell, and scripting tools can manipulate it directly, which makes configuration changes traceable and test data and results easy to create, modify, and analyze.

### The Pragmatic Approach

- Store persistent knowledge as printable, human-understandable, self-describing text.
- Use meaningful names and recognizable formats instead of opaque fields and values.
- Choose structured plain-text formats when the data needs structure.
- Use common, line-oriented plain-text formats so small, focused tools can work together.
- Keep configuration, test data, and test output in plain text so standard tools can edit, search, compare, version, verify, and analyze them.
- Design text data so useful information can be recognized and extracted with only partial knowledge of its format.
- When choosing a storage format, test how it handles schema changes, versioning, extensibility, and migration of existing data.
- Preserve a plain-text interface when a binary representation serves as a performance optimization.
- Favor plain text for long-term access, interoperability, and recovery in limited environments.
