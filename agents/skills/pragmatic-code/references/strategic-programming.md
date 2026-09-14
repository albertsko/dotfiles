# Strategic Programming

Use these principles to judge software structure and behavior under change.

**Root value: Easier To Change (ETC).** Requirements, environments, and understanding change. Favor structures that localize those changes without weakening correctness.

- Judge a design by the responsibilities, interfaces, and dependencies a plausible change would affect.
- When future change is unclear, favor small, cohesive, replaceable components over speculative flexibility.
- When principles conflict, compare the reasons behind them and choose the structure that is easier to change.

## Design Principles

### One source of knowledge

**Don't Repeat Yourself (DRY)** means one authoritative representation per piece of knowledge. Copies that must change together can contradict each other.

- If one rule change requires edits in several places or formats, centralize that knowledge.
- Share the same intent, not merely identical text. Similar calculations for independent policies may need to change independently.
- Derive values from source data. If caching is necessary, hide synchronization behind the same access interface.
- Use uniform access where callers should remain independent of whether a value is stored or computed.
- Generate related clients, mocks, documentation, and data containers from a neutral specification or introspected schema instead of maintaining parallel definitions.

### Independent responsibilities

**Orthogonality** means unrelated components can change independently. Coupling makes a local edit spread across the system.

- Give each module one well-defined responsibility and a narrow, stable interface.
- Count the modules one functional change would affect. Aim to localize a responsibility rather than scattering it.
- Layer dependencies through defined abstractions. Reveal only what callers need and keep other modules' internals private.
- Pass context explicitly. Global state, singletons, and even read-only global dependencies couple their users invisibly.
- Isolate libraries behind narrow interfaces when their changes would otherwise spread through unrelated code.
- Use stable identities you control. Treat email addresses and phone numbers as mutable attributes rather than durable keys.

### Reversible choices

Database, vendor, framework, and deployment choices can become expensive to replace once their assumptions spread.

- Treat critical choices as provisional. Identify a plausible alternative and the approximate cost of switching.
- Put volatile third-party application programming interfaces (APIs) and persistence behind boundaries you own. Keep database calls within a cohesive service boundary.
- Preserve component boundaries even when components deploy together. Deployment shape can change too.
- Match abstraction cost to the dependency it protects. Replaceability does not require speculative layers around every stable operation.

### Keep rules beside their state

- Tell an object the result you need instead of reading its state, deciding elsewhere, and writing the state back.
- Keep validation and rules beside the state they govern.
- Avoid traversal through another component's internal object graph. Replace `order.customer.address.zip` with an operation owned by the responsible abstraction.
- Allow chaining across stable public interfaces and explicit data structures when it does not expose hidden implementation dependencies.
- Wrap shared mutable data, databases, filesystems, and shared services behind APIs you own. A wrapper protects representation changes; the state remains shared.

### Design transformations

Explicit input-to-output transformations keep data flow visible and reduce coordination through hidden mutable state.

- Define inputs and outputs, then name intermediate data forms. Decompose the flow into small transformations with clear responsibilities.
- Pass state through explicit data formats instead of traversing hidden object structure or communicating through mutable globals.
- Represent success and failure so an error stops dependent stages. Use types to expose incompatible stages where the language supports them.

### Choose composition deliberately

Inheritance couples subclasses and their clients to ancestor interfaces and state. Deep hierarchies become brittle, and one tree cannot express overlapping roles well.

- Name the goal before subclassing. Use an interface or protocol for compatibility, delegation for a service, and traits or mixins for shared code.
- Expose only the delegated operations callers need.
- Separate domain rules from persistence and infrastructure responsibilities.
- Compose variants from focused capabilities, such as validation sets, instead of growing one class with behavior flags.

### Configure genuine variability

- Externalize values that change after deployment or vary by environment or customer, such as credentials, endpoints, tunable parameters, and rates.
- Expose configuration through a thin interface so callers do not depend on its storage representation or a global configuration structure.
- Add settings for real variability. If a setting only postpones a product decision, choose a behavior and use feedback before adding permanent complexity.

## Concurrency

### Separate dependencies from accidental order

- Map genuine ordering constraints separately from steps that merely appeared sequentially in the first implementation.
- Overlap independent work with input/output or service waits, and parallelize independent processor-heavy work when its cost warrants coordination.
- Synchronize where downstream work requires completed inputs.
- For workflows spanning requests or long delays, keep durable state outside the process when progress must survive process loss.

### Choose event communication by lifecycle

Events let consumers react to new information and reduce direct producer-to-consumer dependencies.

- For simple local notification, use Observer when coupling to the source and synchronous delivery are acceptable.
- For independent lifecycles or asynchronous communication, consider publish/subscribe and account for harder-to-trace execution.
- Model event sequences as streams when filtering, transforming, or merging events makes the flow clearer.

### Own shared state and atomic operations

A shared mutable value may change between a check and an update. The same race exists in memory, files, databases, services, and process-wide settings.

- Prefer immutability and explicit ownership to eliminate unnecessary shared mutation.
- Make check-decide-update atomic when correctness depends on the checked state remaining valid. Use locking, transactions, or validated conditional updates.
- Encapsulate coordination inside the resource interface. Caller conventions leave correctness dependent on every caller remembering them.
- Guarantee lock release on every path, including exceptions.
- When an operation requires several resources to succeed together, expose a transaction boundary and release partial acquisitions on failure.
- Make partial-failure behavior explicit when the resources cannot provide an atomic transaction.

### Consider actors for independent responsibilities

An actor owns private state and processes messages from a mailbox. Processing one message at a time avoids direct shared-state coordination between actors.

- Consider actors for concurrent responsibilities, especially where mutexes currently protect private state.
- Coordinate through one-way messages, including a reply mailbox when a response is needed.
- Keep correctness independent of variable message timing and permitted ordering. Keep actor logic independent of processor and machine placement.
- Add supervision where failed actors need restart. Define restart behavior so a failure does not silently invalidate the surrounding workflow.

### Consider blackboards for unordered contributions

A blackboard is a shared persistent space for facts. Rules trigger work when prerequisites arrive, decoupling contributors and changing policies from workflow order.

- Use this pattern when independent contributors provide inputs in unpredictable order and prerequisite-driven processing fits the problem.
- Keep message and API definitions in one authoritative specification to manage the indirection.
- Propagate a trace identifier through participants so distributed processing can be followed.
- Keep contributors independently deployable when their lifecycles need independence.
