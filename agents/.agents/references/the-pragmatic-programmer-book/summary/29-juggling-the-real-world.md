## 29. Juggling the Real World

Responsive applications treat an event as the availability of external or internal information and adjust their behavior as events arrive, which improves interactivity, resource use, and decoupling. A finite state machine (FSM) defines a current state and maps significant events to new states; representing transitions as data makes behavior explicit, while transition actions, default cases, and externally stored state extend the same model to parsing and long-running workflows. The Observer pattern lets an observable notify registered callbacks directly, which is simple but couples observers to the source and can create synchronous bottlenecks. Publish/subscribe routes events from publishers to subscribers through named channels, enabling asynchronous communication and replaceable components at the cost of making message flow harder to trace. Reactive programming propagates changes through data, while streams treat events as asynchronous collections that code can filter, transform, combine, and process in parallel through one interface for synchronous and asynchronous work.

### The Pragmatic Approach

- Identify each meaningful event as newly available information, whether it comes from a user, a timer, an external system, or an internal computation.
- Use a finite state machine when the correct response depends on both the current state and the incoming event.
- Express state transitions as data, define default or error transitions, and store action names or callables with transitions that produce effects; encapsulate reusable machine logic and state when useful.
- Persist state outside the process when a workflow spans multiple requests, sessions, or long delays.
- Implement the Observer pattern directly for simple local notifications when callback registration and iteration are all you need; account for coupling to the observable and synchronous callback bottlenecks.
- Use an established publish/subscribe library or service when publishers and subscribers need independent lifecycles or asynchronous communication, and account for reduced visibility into which subscribers handle each message.
- Model event sequences and combinations as streams, then filter, transform, merge, or pair them with the same operations used for ordinary collections.
- Process independent event streams concurrently and handle both results and errors as they arrive.
