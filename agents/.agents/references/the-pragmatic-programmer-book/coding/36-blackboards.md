## 36. Blackboards

A blackboard coordinates independent, concurrent workers through a shared, persistent collection of facts: workers post, match, combine, and react to data without knowing one another or depending on arrival order. The architecture suits asynchronous, evolving workflows in which new facts can trigger rules and produce further facts, but its indirect execution demands centrally defined message formats, end-to-end tracing tools, and careful deployment and management.

### The Pragmatic Approach

- Use a blackboard when independent workers must collaborate on facts that arrive asynchronously or in an unpredictable order. For example, let a loan application accept identity details, credit results, and title records whenever each becomes available.
- Store durable facts or events in a shared system that supports pattern matching, then make each worker react only to the patterns it understands.
- Keep workers decoupled: make them depend on the blackboard's contract, not on other workers' identities, locations, schedules, or implementations.
- Encapsulate changing policies as rules triggered by facts. Let rule outputs post new facts so later rules can continue the workflow without a hard-coded sequence.
- Express data dependencies as prerequisites instead of imposing a global order. Start a vehicle title search only after proof of ownership or insurance appears.
- Define message formats and application programming interfaces in a central repository. Generate code and documentation from the definitions when possible to keep producers and consumers compatible.
- Assign a unique trace identifier when each business operation begins, and propagate it through every derived fact and worker log so engineers can reconstruct the execution path.
- Build tools that expose stored facts, message flow, rule triggers, and trace-linked logs; indirect coordination is difficult to debug without visibility into causality.
- Isolate workers so teams can deploy or replace them independently, and budget for the extra deployment and management overhead created by additional moving parts.
- Prefer a simpler direct workflow when processing order is fixed and participants are known; use a blackboard when asynchronous cooperation and changing rules justify its operational and debugging costs.
