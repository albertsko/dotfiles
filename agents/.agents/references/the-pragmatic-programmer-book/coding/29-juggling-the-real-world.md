## 29. Juggling the Real World

Responsive software treats user actions, external updates, completed computations, timers, and data arrivals as events, then adjusts its behavior as those events occur. Use a finite state machine when responses depend on explicit state, the Observer pattern for simple in-process notifications, publish/subscribe for decoupled and potentially asynchronous messaging, and reactive streams when events must be filtered, transformed, combined, or processed as they arrive. Choosing the smallest suitable abstraction keeps event-driven code responsive without turning its control flow into a tightly coupled web of callbacks.

### The Pragmatic Approach

- Identify each event, its payload, and the component responsible for handling it before writing the response logic.
- Represent state-dependent behavior as a finite state machine: define the valid events and next state for every current state, and send unmatched events to an explicit error state. For example, let a message parser accept `header` only in `initial`, accept `data` or `trailer` in `reading`, and reject every other transition.
- Store finite state machine transitions as data when possible, and associate transitions with named functions or callbacks when they must perform work. Keep transition selection separate from actions such as starting, appending to, or finishing a parsed string.
- Persist the current state outside the running process for workflows that span requests or long delays, such as registration that waits for email validation and user consent.
- Use the Observer pattern for small, local one-to-many notifications. Keep callbacks short because the observable knows its observers and typically invokes them synchronously, which creates coupling and can block the event source.
- Use publish/subscribe when publishers and subscribers must evolve independently or communicate asynchronously. Publish events to named channels, subscribe through the shared channel interface, and document the publishers and subscribers because their relationship is no longer visible in either component.
- Treat streams as asynchronous collections when processing depends on event values, timing, or combinations. Apply collection operations such as filtering, mapping, merging, and zipping; for example, zip a timer stream with a data stream to release one data item per timer event.
- Let independent asynchronous work run concurrently, and process each result when it arrives instead of assuming request order matches response order.
- Choose the simplest mechanism that expresses the behavior clearly: finite state machines for state transitions, observers for direct local notifications, publish/subscribe for decoupled message delivery, and streams for event composition over time.
