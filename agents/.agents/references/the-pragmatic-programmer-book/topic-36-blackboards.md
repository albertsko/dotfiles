## Topic 36: Blackboards

Blackboard architecture provides a central, shared repository where independent, decoupled processes post facts and inspect existing data asynchronously. Processes work independently without knowing about other active agents in the system. The order of data arrival is irrelevant because newly posted facts dynamically trigger rules and downstream actions. Modern distributed messaging systems like Kafka and NATS can act as blackboards by offering event persistence and pattern-based message retrieval.

### The Pragmatic Approach

- Use blackboards to coordinate complex, asynchronous workflows across decoupled components.
- Combine a blackboard with a rules engine to decouple business logic from data collection and processing order.
- Leverage modern event-log messaging platforms to handle concurrent data sharing between independent actors.
- Assign a unique trace identifier at the start of a business transaction and pass the identifier through all participating actors to track indirect interactions in logs.
- Maintain a central repository of message formats and interface definitions to generate code, documentation, and maintain schema consistency.

### Common Mistakes

- Writing complex, hardwired workflow engines in procedural code rather than letting dynamic rules react to data arrival.
- Ignoring operational overhead when deploying systems composed of numerous small, decoupled components.
- Failing to implement distributed tracing, which makes indirect component interactions and message flows difficult to debug.
- Over-coupling components by forcing actors to communicate directly instead of posting shared facts to the board.
