## Topic 35: Actors and Processes

Actors and processes implement concurrency without shared state or synchronized memory access. An actor is an independent virtual processor with a private state and a mailbox. When an actor receives a message in its mailbox, it wakes up, processes the message to completion, and updates its state or goes back to sleep. A process is a lightweight virtual processor constrained by convention to behave like an actor.

Actors operate under four primary constraints:

- Control is decentralized, with no central scheduler orchestrating execution.
- State exists exclusively inside individual actors or within messages.
- Messages are strictly one-way and asynchronous, requiring recipient mailbox addresses for replies.
- Actors handle one message at a time, processing each to completion before starting the next.

Because actors share nothing, they eliminate race conditions and mutex locks. Actor-based code runs identically on single-core machines, multi-core processors, or distributed networks.

### The Pragmatic Approach

- **Use actors for concurrency without shared state**: Design concurrent systems around independent actors that communicate solely through asynchronous messages.
- **Isolate component state**: Keep actor state strictly private. Prevent external components from directly inspecting or modifying local state.
- **Model workflows as message flows**: Structure logic as a series of one-way message exchanges between specialized actors rather than writing explicit sequential orchestrators.
- **Include return mailboxes in messages**: Send the caller's address inside the message payload whenever a response is required.
- **Leverage runtime supervision**: Implement supervision frameworks to monitor actor health and automatically restart failed processes.

### Common Mistakes

- **Sharing mutable state between actors**: Passing references to mutable objects inside messages breaks isolation and introduces race conditions.
- **Expecting synchronous replies**: Treating actor message calls like blocking method calls causes deadlocks and ruins concurrency.
- **Creating centralized controller actors**: Designing a single master actor to orchestrate all actions reintroduces single points of failure and bottlenecks.
- **Failing to handle missing resources**: Assuming messages always succeed without handling error responses leads to silent failures and unhandled messages.
