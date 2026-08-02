## 12. Tracer Bullets

Tracer bullet development builds a thin, production-quality path through every major system component early, using a small but real feature to expose requirement, architecture, integration, data, and performance risks under actual conditions. Unlike a disposable prototype, tracer code includes normal error handling, structure, documentation, and self-checks, remains part of the final system, and grows incrementally. The working end-to-end slice provides fast feedback, a continuous integration platform, visible progress, and a low-cost way to correct course as requirements and conditions change.

### The Pragmatic Approach

- Validate the project foundation first: create the project, add a minimal working entry point, and confirm that it builds and runs with the real toolchain and dependencies.
- Identify the requirements that define the system and the areas with the most uncertainty or risk. Implement those areas before routine functionality.
- Choose the smallest real use case that crosses every important layer. For example, pass a request from the user interface through business logic and serialization to a database, then return a simple result.
- Implement only enough behavior in each component to complete the end-to-end path. Prefer a basic but working query, such as listing all rows, over sophisticated logic isolated from the rest of the system.
- Write tracer code to production standards because it will remain in the system. Include clear structure, error handling, documentation, and automated self-checks.
- Keep the complete path runnable while extending it. Unit-test each addition, integrate it immediately, and verify its interactions through the existing end-to-end slice.
- Show each working slice to users early and ask whether its behavior matches their needs. Treat misunderstandings, unavailable data, and likely performance problems as signals to adjust the implementation.
- Correct misses while the codebase is still small. Change the thin implementation, rerun the full path under real conditions, and repeat until the system reaches the intended target.
- Add functionality one use case at a time across all affected components instead of completing modules in isolation. Measure progress by working use cases, not estimated completion percentages.
- Use a disposable prototype when exploring one isolated interface or algorithm. Use tracer code when validating how the whole application connects and evolves, and preserve the resulting production skeleton.
