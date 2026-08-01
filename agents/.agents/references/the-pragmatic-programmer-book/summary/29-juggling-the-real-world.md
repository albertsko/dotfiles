## 29. Juggling the Real World

Responsive applications treat an event as the availability of external or internal information and adjust their behavior as events arrive, which improves interactivity, resource use, and decoupling. A finite state machine (FSM) defines a current state and maps significant events to new states; representing transitions as data makes behavior explicit, while transition actions, default cases, and externally stored state extend the same model to parsing and long-running workflows. The Observer pattern lets an observable notify registered callbacks directly, which is simple but couples observers to the source and can create synchronous bottlenecks. Publish/subscribe routes events from publishers to subscribers through named channels, enabling asynchronous communication and replaceable components at the cost of making message flow harder to trace. Reactive programming propagates changes through data, while streams treat events as asynchronous collections that code can filter, transform, combine, and process in parallel through one interface for synchronous and asynchronous work.

### The Pragmatic Approach

- Identify each meaningful event as newly available information, whether it comes from a user, a timer, an external system, or an internal computation.
- Use a finite state machine when the correct response depends on both the current state and the incoming event.
- Express state transitions as data, define default or error transitions, and attach actions only where transitions must produce effects.
- Persist state outside the process when a workflow spans multiple requests, sessions, or long delays.
- Use the Observer pattern for simple local notifications, and keep callbacks short to limit coupling and synchronous delays.
- Use publish/subscribe channels when publishers and subscribers need independent lifecycles or asynchronous communication, and add tracing so hidden message paths remain understandable.
- Model event sequences and combinations as streams, then filter, transform, merge, or pair them with the same operations used for ordinary collections.
- Process independent event streams concurrently and handle both results and errors as they arrive.
