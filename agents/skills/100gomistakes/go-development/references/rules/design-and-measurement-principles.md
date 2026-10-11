# Design and measurement

Load when: architecture, readability, speculative abstractions, optimization tradeoffs or contextual advice

<a id="g1"></a>

- **G1** When designing for possible future requirements. Then Solve concrete current problems before adding abstractions. Reassess as demonstrated needs emerge, including credible future compatibility requirements. Because Speculative flexibility adds complexity without demonstrated value.

  Sources: `BP1`.

<a id="g2"></a>

- **G2** When maintaining code over years. Then Optimize code for future readers through clear names, representations, and structure. Readability is contextual, not a single syntax rule. Readability includes names, representation and structure, not formatting alone. Because Reading greatly outnumbers writing and maintenance spans time.

  Sources: `BP2`.

<a id="g197"></a>

- **G197** When optimizing a codebase. Then Prioritize correctness and clarity, then optimize measured paths with a concrete benefit. Performance work is justified by actual user, capacity, or cost needs. Prefer readability to speculative speed. Benchmark representative changes because compiler, hardware and data behavior can defeat intuition. Because Complexity has a maintenance cost and guessed optimization may solve no real problem.

  Sources: `BP197`.

<a id="g238"></a>

- **G238** When applying advice from the book. Then Retain the specific context and alternatives instead of treating every recommendation as a dogmatic rule. The book assumes existing Go knowledge and concentrates on core language/standard library. Because The author explicitly frames solutions as contextual.

  Sources: `BP238`.
