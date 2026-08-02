## 35. Actors and Processes

Actors model concurrent work as independent virtual processors that own private local state, receive one-way messages through mailboxes, and process one message at a time to completion, sleeping when their mailboxes are empty. The system's only state lives in messages and actors; only the recipient can read a message, and no actor can inspect another actor's local state. While handling a message, an actor can update the state used for its next message, create actors, and send messages to known actors. No component controls or orchestrates the end-to-end workflow: actors react asynchronously to messages, and a runtime can execute the same actor code on one processor, multiple cores, or networked machines. A general-purpose process can provide the same model when constrained by convention to follow these rules.

### The Pragmatic Approach

- Use actors when concurrent components can own their state and coordinate exclusively through messages.
- Assign each mutable resource to one actor. For example, let an inventory actor be the only component that reads or changes stock, and make callers request reservations by message.
- Define explicit message types and include all data and actor references the recipient needs, such as `{ type: "reserve", itemId, quantity, replyTo }`.
- Include the sender's mailbox address when it needs a result. Have the recipient eventually send another one-way message to that address instead of returning a synchronous reply.
- Process one message at a time and finish its state transition before accepting the next message. Install the resulting state for subsequent messages.
- Create actors dynamically when a workflow needs new independent state or behavior, and give each actor references only to actors it must contact.
- Design workflows as message exchanges among autonomous actors instead of using one coordinator to dictate every step. Let each actor choose what to send from its current state and the message it receives.
- Represent expected failures with explicit messages. An inventory actor can send `{ type: "unavailable", itemId, replyTo }` so the requesting actor can handle the shortage.
- Give independently managed resources separate actors, and define behavior for every partial-availability outcome when a request needs several resources.
- Expect observable message interleavings to vary. Keep correctness independent of the order in which unrelated messages are processed.
- Use runtime supervision for actors that can fail, including restarting actors or actor groups when the system can do so safely.
- Prototype actor-based ownership when existing code uses mutual exclusion to protect shared data.
- Choose an actor implementation for the host language instead of writing shared-state concurrency and scheduling code. When continuous upgrades matter, evaluate whether the runtime supports hot-code loading.
