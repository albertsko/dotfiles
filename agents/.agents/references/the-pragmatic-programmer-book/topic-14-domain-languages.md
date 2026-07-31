## Topic 14: Domain Languages

Domain languages allow developers to program using the vocabulary, syntax, and semantics of the problem domain. Programming in the language of the application domain makes code easier to understand and aligns solutions directly with problem requirements.

Domain languages fall into two primary categories:

- **Internal Domain Languages:** Implemented inside a host programming language using functions, macros, or metaprogramming. Examples include RSpec and web framework routers. Internal languages inherit the execution power and tooling of the host language, but host language syntax limits their structure.
- **External Domain Languages:** Formatted in custom or off-the-shelf text syntaxes independent of the host application code. Examples include Ansible configuration files and Cucumber specifications. External languages provide total syntactic freedom, but require parsers and maintenance tools.

### The Pragmatic Approach

- Program close to the problem domain by writing code in domain-specific vocabulary.
- Use off-the-shelf external formats such as YAML, JSON, or CSV before building custom parsers.
- Prefer internal domain languages or simple function wrappers when creating developer-facing abstractions.
- Reserve custom external domain languages for scenarios where non-technical users directly write specifications.
- Validate that the time saved by a domain language exceeds the effort required to create and maintain that language.

### Common Mistakes

- Building complex external parsers when simple host-language functions satisfy the requirements.
- Spending more effort developing a domain language than the language saves over the project lifecycle.
- Assuming non-technical business stakeholders will read or maintain formal specification files instead of interacting with running software.
