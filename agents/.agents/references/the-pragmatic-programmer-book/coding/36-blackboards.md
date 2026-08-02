## 36. Blackboards

A blackboard coordinates independent, concurrent workers through a shared, persistent collection of facts: workers post, retrieve, match, combine, and react to data without knowing one another or depending on arrival order. This decoupling avoids many direct concurrency problems and suits asynchronous, evolving workflows in which new or derived facts trigger rules, but indirect execution requires shared contracts, traceable causality, and extra deployment and management effort.

### The Pragmatic Approach

- Use a blackboard when independent workers must collaborate on facts that arrive asynchronously or in an unpredictable order. For example, let a loan application accept identity details, credit results, and title records whenever each becomes available.
- Store durable facts, events, or objects in a shared system, and allow each contribution to use the representation its content needs.
- Let each worker retrieve and react only to matching entries. Use typed tuples, partial-field templates, wildcards, or subtype matching when those mechanisms clarify which facts a worker handles.
- Keep workers decoupled: make them depend on the blackboard's contract, not on other workers' identities, locations, schedules, expertise, or implementations.
- Encapsulate changing policies as rules triggered by facts. Let rule outputs post new facts so later rules can continue the workflow without a hard-coded sequence.
- Express data dependencies as prerequisites instead of imposing a global order. Start a vehicle title search only after proof of ownership or insurance appears.
- Define message formats and application programming interfaces in a central repository. Generate code and documentation from the definitions when possible to keep producers and consumers compatible.
- Assign a unique trace identifier when each business operation begins, and propagate it through every derived fact and worker log so engineers can reconstruct the execution path.
- Build tools that expose stored facts, message flow, rule triggers, and trace-linked logs; indirect coordination is difficult to debug without visibility into causality.
- Isolate workers so teams can deploy or replace them independently, and budget for the extra deployment and management overhead created by additional moving parts.
- Prefer a simpler direct workflow when processing order is fixed and participants are known; use a blackboard when asynchronous cooperation and changing rules justify its operational and debugging costs.
