## 14. Domain Languages

Programming languages shape solutions, so model software with the vocabulary, syntax, and semantics of its problem domain. An internal domain language uses valid host-language code and inherits its features and constraints, while an external domain language defines independent syntax that a parser converts into code or data. Choose either form only when its clearer expression and reuse save more effort than the language costs to create.

### The Pragmatic Approach

- Name types, functions, modules, and commands with precise domain terms so the code states its intent, such as `score.add_pins(3)` instead of a generic data update.
- Start an internal domain language with ordinary functions and objects. Add macros or metaprogramming only when simpler constructs cannot express the domain clearly.
- Exploit host-language features such as loops, functions, and composition to generate repetitive domain declarations, tests, or configurations.
- Accept the host language's syntax and semantics as constraints on an internal domain language. Use macros only when their added flexibility justifies their complexity.
- Prefer an established external format when its syntax fits the problem. Consider a custom external language only when application users will write it and independent syntax provides enough value to justify a parser.
- Separate external-language parsing from execution by translating input into code or data that the application can run.
- Organize parsing and command dispatch so adding a domain operation requires a localized handler instead of changes throughout the parser.
- Validate domain expressions with running software and real user feedback. Do not treat approval of readable specifications as proof that the behavior meets users' needs.
- Count parser libraries, tools, and implementation effort when estimating the cost of a domain language. Stop adding language machinery when it costs more than the work it removes.
