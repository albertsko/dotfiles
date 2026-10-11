# Code and API design

Load when: scope, initialization, interfaces, generics, embedding, options, packages, documentation or logging

<a id="g3"></a>

- **G3** When assigning an outer variable inside a nested block. Then Use assignment to the existing variable, or assign a distinctly named temporary back to it. Intentional shadowing, including err, can be acceptable. Inspect scope and use shadow analysis. Because Short declarations can silently create a different variable and leave the outer value unchanged.

  Sources: `BP3`.

<a id="g4"></a>

- **G4** When branches handle errors or exceptional inputs. Then Return early, omit else after returning branches, and keep normal execution aligned left. Apply to simplify actual flow. Preserve observable behavior when restructuring control flow. Because Less nesting reduces the mental model required to follow the function.

  Sources: `BP4`.

<a id="g5"></a>

- **G5** When using several init functions. Then Express initialization dependencies explicitly. Keep within-package initialization independent of source-file order, which renaming can change. Use blank imports deliberately for intended registration side effects. From Go 1.21, independent packages initialize in import-path order when their dependencies are ready. Because Renaming source files may change initialization order.

  Sources: `BP5`, `RV179`, `RV208`.

<a id="g6"></a>

- **G6** When initialization can fail or depends on external systems. Then Use an explicit initialization function that accepts dependencies and returns values and errors. Nonfailing static configuration is a reasonable init use. Return initialized values as well as errors so state ownership remains explicit. Retry and fallback remain caller decisions. Because Callers retain retry and fallback choices, tests avoid automatic external setup, and state can be encapsulated.

  Sources: `BP6`.

<a id="g7"></a>

- **G7** When storing initialized state. Then Encapsulate state instead of assigning mutable package globals. Static initialization need not create globals. Because Global mutation couples functions and prevents isolated tests.

  Sources: `BP7`.

<a id="g8"></a>

- **G8** When exposing struct data. Then Use direct fields unless accessor methods add useful behavior or representation hiding. Validation, computed values, debugging, locking or other synchronization, and credible forward compatibility can justify accessors even before the field representation changes. Because Mechanical getters and setters add unnecessary code.

  Sources: `BP8`.

<a id="g9"></a>

- **G9** When naming accessor methods. Then Name getters after the property and setters SetProperty. Example Balance and SetBalance. Because These names follow Go conventions.

  Sources: `BP9`.

<a id="g10"></a>

- **G10** When several implementations share meaningful behavior. Then Extract a small behavioral interface to factor common logic. Choose a demonstrated abstraction such as io.Reader or sort.Interface. Examples such as io.Reader, io.Writer and sort.Interface illustrate useful behavior boundaries, not an exhaustive set of interface uses. Because Algorithms become reusable across compatible concrete types.

  Sources: `BP10`.

<a id="g11"></a>

- **G11** When tests or other callers need replaceable dependencies. Then Depend on an interface covering the required behavior and inject its implementation. Integration tests remain useful alongside unit tests. An injected test double does not verify the actual external implementation. Retain integration tests when needed. Because Production implementations and test doubles can be substituted.

  Sources: `BP11`.

<a id="g12"></a>

- **G12** When a component must only use part of another type's behavior. Then Accept a restricted interface, such as a configuration getter. The concrete object can still expose other behavior elsewhere. A narrow consumer interface restricts the local API, not mutation through other aliases. The same concrete object may expose more capabilities elsewhere. Because The component cannot accidentally invoke mutation through that interface.

  Sources: `BP12`.

<a id="g13"></a>

- **G13** When considering a new interface. Then Create interfaces for present, demonstrable needs and remove interfaces with no clear benefit. A proven reusable abstraction can be designed upfront. Usually small interface dispatch overhead is not the main reason to reject a purposeless interface. One existing implementation does not invalidate an established abstraction. Because Unneeded indirection makes code harder to follow.

  Sources: `BP13`.

<a id="g14"></a>

- **G14** When a consumer needs to abstract a producer. Then Define a minimal interface in the consumer package and keep it unexported when local. Producer-side abstractions are valid when their reuse is already proven. Keep those minimal too. An established producer-side contract, including encoding interfaces, can be appropriate when usefulness across consumers is already demonstrated. Because Each consumer chooses its own methods without forcing unused methods on others.

  Sources: `BP14`.

<a id="g15"></a>

- **G15** When designing function signatures. Then Usually return concrete types and accept useful interfaces. error and established abstractions such as io.Reader are legitimate interface returns. Because Clients retain flexibility and dependency cycles are less likely.

  Sources: `BP15`.

<a id="g16"></a>

- **G16** When inputs or outputs belong to known types. Then Use explicit types rather than any, even if this requires separate methods. Use any for truly arbitrary values, such as serialization, formatting, or query parameters. Because Signatures communicate behavior and preserve compile-time safeguards.

  Sources: `BP16`.

<a id="g17"></a>

- **G17** When writing generic APIs. Then Constrain type parameters to needed operations. Use ~T to admit types with underlying type T, and comparable for map keys. Generic functions and types require Go 1.18 language support. Methods with their own type parameters require Go 1.27 language support. Interface methods still cannot declare type parameters, and generic methods do not implement interface methods. Go 1.20 permits interface-containing comparable arguments, but dynamic comparisons can still panic. Because Constraints retain compile-time safety while admitting intended types.

  Sources: `BP17`, `RV1`, `RV115`, `RV502`.

<a id="g18"></a>

- **G18** When typed collections or common algorithms would duplicate code. Then Use generics to factor reusable data structures or behavior without sacrificing type safety. Wait for concrete duplication or a real need. Examples include typed data structures, channel/slice/map operations and shared behavior with comparison functions. Because Avoids repeated implementations and runtime type checks.

  Sources: `BP18`.

<a id="g19"></a>

- **G19** When a function only calls a required interface method. Then Accept the interface directly instead of introducing a type parameter. Reconsider any generic design that makes code less clear. Because The type parameter adds abstraction without value.

  Sources: `BP19`.

<a id="g20"></a>

- **G20** When considering an embedded struct field. Then Embed only to intentionally promote useful behavior. Use named fields for private implementation details. Embedding is composition, not subclassing. The embedded object remains the receiver. Removing forwarding boilerplate is useful only when promotion belongs to the intended API. Shorter selectors alone do not justify embedding. Intentional promotion can implement interfaces without repetitive forwarding methods. Because Embedding exports promoted methods and can leak locking or other internals.

  Sources: `BP20`.

<a id="g21"></a>

- **G21** When an exported type embeds another evolving type. Then Review additions to the embedded type for unintended API exposure. A team can choose to avoid embedding in public structs to avoid this maintenance burden. Because New inner methods are promoted automatically.

  Sources: `BP21`.

<a id="g22"></a>

- **G22** When designing optional API configuration. Then Keep required constructor arguments explicit, and choose an extensible option mechanism with clear defaults. Configuration structs, builders and functional options are valid alternatives. Distinguish omitted and explicit zero options as BP240 specifies. Because Growing positional argument lists break existing callers and obscure which options are required.

  Sources: `BP22`.

<a id="g23"></a>

- **G23** When options should be convenient and extensible. Then Use variadic functional options that update private configuration, validate inputs, and return errors before construction. WithX is a convention, not a universal requirement. Preserve meaningful zero values. Apply and validate options before creating the resource. WithX naming is conventional, not mandatory. Because Callers can omit all options for defaults and add options without changing existing calls.

  Sources: `BP23`.

<a id="g24"></a>

- **G24** When choosing repository structure. Then Choose and consistently apply a layout suited to the project and organization. project-layout is optional and unofficial. Small projects and established organization layouts need no migration. Because Consistency reduces navigation costs across repositories.

  Sources: `BP24`.

<a id="g25"></a>

- **G25** When separating programs, private implementation, and assets. Then Use purposeful directories such as cmd for executables and internal for code other applications must not import. The book's broader pkg/test/assets layout is an example rather than a Go standard. The optional example also places contracts, documentation, examples, configuration, tests, scripts and build assets in purposeful directories. Do not add a generic src directory by habit. Because Directory meaning aids navigation and internal controls import visibility.

  Sources: `BP25`.

<a id="g26"></a>

- **G26** When splitting packages. Then Delay packaging until responsibilities are understood and balance cohesion against oversized or tiny fragmented packages. Small highly cohesive packages can be valid. Nested directories do not confer privileged access. Both context-based and layer-based package organization can work if used consistently. Because Premature and excessive splitting obscures logical connections.

  Sources: `BP26`.

<a id="g27"></a>

- **G27** When naming packages. Then Use short meaningful lowercase names describing what a package provides. Keep context-based or layer-based organization consistent. Because Names tell clients the package's purpose.

  Sources: `BP27`.

<a id="g28"></a>

- **G28** When deciding what to export. Then Default to unexported elements and expose only required API. Serialization may require exported fields. Because A small public surface reduces coupling.

  Sources: `BP28`.

<a id="g29"></a>

- **G29** When a package is named utils, common, shared, or base. Then Move functions to cohesive packages with meaningful names, or combine logically connected packages. Avoid replacing one utility package with arbitrary nano packages. A small naturally independent and cohesive package remains valid. Because Generic names hide responsibilities.

  Sources: `BP29`.

<a id="g30"></a>

- **G30** When a package name already supplies type context. Then Remove redundant name fragments and consider methods on a meaningful type. Use types when they clarify the API, not merely to reduce characters. Because Qualified names become concise and expressive.

  Sources: `BP30`.

<a id="g31"></a>

- **G31** When representing a set. Then Use map[K]struct{} when values carry no information. K must be an allowed map key. Because The empty value communicates that only key membership matters.

  Sources: `BP31`.

<a id="g32"></a>

- **G32** When a local name matches an imported package or builtin. Then Choose another meaningful variable name or alias the import. Avoid dot imports in most cases because they obscure provenance. Because Shadowing blocks the original name and confuses readers.

  Sources: `BP32`.

<a id="g33"></a>

- **G33** When exporting an API element. Then Document it with a complete sentence beginning with its name and explain intent and usage. Implementation mechanics belong in internal comments. Because Consumers should not need implementation reading to use the API.

  Sources: `BP33`.

<a id="g34"></a>

- **G34** When deprecating an API. Then Add a Deprecated: comment that identifies the preferred replacement. Retain useful ordinary documentation. Because Tools can surface deprecation to users.

  Sources: `BP34`.

<a id="g35"></a>

- **G35** When documenting constants or variables. Then Put purpose in public documentation and implementation-specific content explanations beside the declaration. Avoid exposing irrelevant representation details. Because Clients and maintainers need different information.

  Sources: `BP35`.

<a id="g36"></a>

- **G36** When documenting a package. Then Add an adjacent Package name comment with a concise first line and details after it. Use a relevant source file or doc.go. Detached comments are omitted. Because Generated documentation makes scope and constraints discoverable.

  Sources: `BP36`.

<a id="g37"></a>

- **G37** When maintaining a Go project. Then Choose useful analyzers and automate them in CI or hooks. Linters cannot detect every mistake. Tools listed in the book are examples. Book tool examples include vet/shadow, errcheck, gocyclo, goconst and golangci-lint. Select useful checks rather than mandating historical tools. Because Checks find avoidable bugs such as shadowing and unchecked errors.

  Sources: `BP37`.

<a id="g38"></a>

- **G38** When maintaining formatting consistency. Then Run gofmt and an import formatter such as goimports automatically. An aggregator can coordinate linters and formatters. Because Consistent formatting reduces review noise.

  Sources: `BP38`.

<a id="g198"></a>

- **G198** When designing interface granularity. Then Keep interfaces small and compose them when a larger combined behavior is required. Choose sufficient granularity for the real behavior, not minimalism for its own sake. Compose small interfaces when combined behavior is needed. Granularity should match actual meaning, not an arbitrary one-method rule. Because Fewer required methods increase reuse and composability.

  Sources: `BP198`.

<a id="g229"></a>

- **G229** When initializing static configuration. Then Consider init for non-failing static setup that does not compromise tests. Assess failure and global-state behavior, init is not universally forbidden. Registration or static configuration can fit init if it introduces no failure, mutable-global or test-isolation problem. Because Some registration and configuration side effects fit package initialization.

  Sources: `BP229`.

<a id="g230"></a>

- **G230** When using a builder with chaining. Then When chained setters cannot return validation errors, perform validation and default resolution explicitly in Build. Builder patterns are valid, but deferred validation and extra construction steps can complicate clients. Builders are valid alternatives but can make default construction and precise per-option errors less convenient. Because Chained setters returning the builder cannot also provide ordinary Go error handling.

  Sources: `BP230`.

<a id="g240"></a>

- **G240** When zero is a valid explicit option. Then Represent absence separately from zero, for example with a pointer in configuration. Pointer configuration adds caller friction. A pointer field is one way to distinguish omission from explicit zero, but it adds caller friction. Apply domain-specific invalid-value validation separately. Because A missing value and an explicitly supplied zero otherwise become indistinguishable.

  Sources: `BP240`.

<a id="g248"></a>

- **G248** When introducing generic aliases or newer expression syntax. Then Require Go 1.24 language support for stable generic aliases, including cross-package use. Require Go 1.26 for new(expression) and self-referential generic constraints. Go 1.23 aliases are only an intra-package experiment. Keep older baselines using supported forms rather than relying on the installed compiler alone. Because Syntax and type-system capabilities follow effective language versions.

  Sources: `RV286`, `RV332`, `RV445`.

<a id="g272"></a>

- **G272** When adding structured logging or custom log handlers. Then Consider Go 1.21+ log/slog, keeping attributes meaningful and sensitive values controlled. Use slogtest for custom handlers and vet for key/value mismatches. Go 1.26 MultiHandler broadcasts according to child Enabled and attribute/group semantics, so test composition. Avoid duplicate handling of one propagated error. Because Structured records help diagnosis only when their shape and handler behavior are correct.

  Sources: `RV187`, `RV188`, `RV245`, `RV281`, `RV481`.
