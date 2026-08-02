## 35. Actors and Processes

Actors model concurrent work as independent virtual processors that own private state, receive one-way messages through mailboxes, and process one message at a time to completion. An actor can update the state used for its next message, create actors, and send messages to known actors, but no actor can inspect another actor's state or messages; a process can provide the same model when constrained to these rules. This isolation removes shared-memory synchronization and central orchestration while allowing the same actor code to run asynchronously on one processor, multiple cores, or networked machines.

### The Pragmatic Approach

- Use actors when concurrent components can own their state and coordinate exclusively through messages.
- Assign each mutable resource to one actor. For example, let an inventory actor be the only component that reads or changes stock, and make callers request reservations by message.
- Define messages as explicit domain commands or events with all required context, such as `{ type: "reserve", itemId, quantity, replyTo }`.
- Include a recipient address in a message when the sender needs a result; model the result as another one-way message instead of a synchronous reply.
- Process one message at a time and finish its state transition before accepting the next message. Return or install the new state for subsequent messages.
- Pass actor references only to components that must communicate. For example, give an order actor the inventory actor's address instead of exposing the inventory data.
- Design workflows as message exchanges among autonomous actors instead of one coordinator that dictates every step. Let each actor decide what message to send from its current state and the message it receives.
- Handle resource exhaustion and other expected failures with explicit messages. An inventory actor can send `{ type: "unavailable", itemId, replyTo }` so the requesting actor can compensate or notify the user.
- Treat message order across actors as nondeterministic. Keep correctness independent of which unrelated message arrives first, and include identifiers when responses must be correlated with requests.
- Add supervision around actors that can fail: detect termination, restart isolated actors when safe, and restore or reconstruct the state they need.
- Prototype actor ownership when existing code relies on locks around shared data, then compare correctness, failure handling, and operational complexity before adopting the design.
