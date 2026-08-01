## 44. Naming Things

Names shape how programmers understand code because written words command attention, so name applications, modules, functions, variables, and types for the roles they play and the intent they express rather than for vague habits or implementation mechanics. Pausing to identify an element’s purpose can expose confused design, while precise domain terms, intention-revealing operations, context-aware names, and dedicated types clarify behavior and expectations. Follow the naming culture of the language and team, use project vocabulary consistently, and reserve obscure or clever names for branding. As code and meaning change, replace misleading names promptly and keep renaming safe and routine.

### The Pragmatic Approach

- Name each element for its role and intent.
- Pause before naming an element and identify why it exists, what makes it distinct, what it does, and what it interacts with.
- Replace generic labels such as `user` or `amount` with precise domain terms such as `buyer`, `customer`, `discount`, or `percentage`.
- Name operations for their purpose, and introduce explicit types when primitive values leave units, ranges, or expectations unclear.
- Consider the surrounding context so names remain clear without redundant repetition.
- Follow the established conventions of the language and community, including customary short names, casing, and character sets.
- Define the project’s shared vocabulary, spread it through frequent communication, and record specialized terms in a glossary when useful.
- Reserve playful or obscure names for projects, products, and teams rather than code whose meaning must be clear.
- Rename an element as soon as its name becomes inaccurate, confusing, or misleading.
- Maintain regression tests and adaptable designs so renaming remains easy and safe.
