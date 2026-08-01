## 35. Actors and Processes

Actors implement concurrency as independent virtual processors with private local state and mailboxes, while actor-like processes are general-purpose virtual processors constrained to follow the same model. An idle actor wakes when a message arrives, processes one message to completion, may create actors or send messages, establishes its state for the next message, and sleeps again when its mailbox empties. No controller orchestrates the system: only recipients can inspect their messages, no actor can access another actor's state, communication is one-way, and responses arrive as later messages sent to an included mailbox address. This isolation lets actors run concurrently and asynchronously without shared-state synchronization or architecture-specific code, whether a runtime schedules them on one processor or distributes them across cores and networked machines. Supervision can restart failed actors, and hot-code loading can update a running system, making actor implementations useful for reliable concurrent applications.

### The Pragmatic Approach

- Model each concurrent responsibility as an actor with private state and a mailbox.
- Define messages around events and requests, and include the sender's mailbox address when a response is needed.
- Process one message at a time to completion, then return the actor's state for the next message.
- Coordinate work through one-way messages instead of sharing mutable data or protecting it with mutual exclusion.
- Pass each actor only the actor references it needs, and let message handlers drive the complete workflow.
- Expect message timing and output order to vary without changing the system's correctness.
- Keep actor code independent of whether the runtime uses one processor, multiple cores, or networked machines.
- Add supervision to restart failed actors, and use hot-code loading when the actor platform supports it.
