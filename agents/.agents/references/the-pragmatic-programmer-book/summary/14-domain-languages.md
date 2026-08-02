## 14. Domain Languages

Programming languages shape the solutions developers see, but the problem domain can shape software more directly when code adopts its vocabulary, syntax, and semantics. An internal domain language, such as RSpec or Phoenix routing, remains valid host-language code and gains the host language's features, but it must obey the host language's syntax and semantics. An external domain language, such as Cucumber or an Ansible specification, is parsed into code or data and offers freer syntax, but it adds parser, tooling, and maintenance costs. A domain language earns its place only when its savings outweigh its implementation cost, and runnable software often reveals business users' real needs better than specifications they may not fully understand.

### The Pragmatic Approach

- Write code with the problem domain's vocabulary so the solution expresses domain concepts directly.
- Choose an internal domain language when host-language features provide useful power and its syntax is an acceptable constraint.
- Start an internal domain language with ordinary functions before adding metaprogramming or macros.
- Use host-language control structures to generate repeated domain declarations, such as families of tests.
- Prefer established external formats such as YAML, JSON, or CSV when they can express the required data.
- If no established external format fits, prefer an internal language; create a custom external language only when application users will write it and its benefits justify the parser and tooling effort.
- When custom syntax is necessary, reuse an existing parser or parser framework when possible and design the parser so new commands are easy to add.
- Translate external specifications into well-defined code or data that the application can execute.
- Consider whether a domain language can express requirements, generate repetitive code, or provide a reusable framework across projects.
- Do not treat business-user sign-off on detailed specifications as proof that the requirements are understood; give users runnable software to explore so their concrete needs can emerge.
