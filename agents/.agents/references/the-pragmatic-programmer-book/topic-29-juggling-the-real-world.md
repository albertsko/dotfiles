## Topic 29: Juggling the Real World

Modern applications must react dynamically to events in a messy, unpredictable real world. An event represents the availability of information, whether from user actions, external data feeds, or internal process completions. To build responsive, loosely coupled applications without chaotic conditional logic, pragmatic programmers apply four core event-handling strategies:

- **Finite State Machines (FSMs)**: Express state transitions and actions purely as data tables driven by incoming event streams.
- **The Observer Pattern**: Notify registered client callbacks directly when an observable event occurs.
- **Publish/Subscribe (PubSub)**: Decouple publishers and subscribers asynchronously through named intermediate channels.
- **Reactive Programming and Streams**: Treat asynchronous event sequences as collections, applying operations like mapping, filtering, and zipping over time.

### The Pragmatic Approach

- **Model complex workflows with state machines**: Represent states, inputs, and actions in transition tables to keep stateful logic concise and maintainable.
- **Decouple systems using Publish/Subscribe channels**: Route events through asynchronous message channels so components can publish or subscribe without direct knowledge of each other.
- **Transform event streams like collections**: Use reactive programming libraries to filter, combine, and manipulate asynchronous event streams with unified APIs.
- **Select the appropriate event strategy**: Choose simple state machines for local workflow state, PubSub for system-wide decoupling, and reactive streams for complex event manipulation.

### Common Mistakes

- **Tight coupling with raw observers**: Registering observers directly with observables introduces tight component dependencies and synchronous execution bottlenecks.
- **Avoiding state machines**: Hand-crafting nested conditional statements for stateful logic instead of using simple data-driven state machines leads to brittle code.
- **Opaque message flows in PubSub systems**: Overusing Publish/Subscribe without clear tracing makes understanding system data flows and debugging event sources difficult.
- **Managing time manually**: Writing custom timer and callback plumbing to combine asynchronous events rather than leveraging reactive stream abstractions.
