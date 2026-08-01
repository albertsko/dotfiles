## 36. Blackboards

A blackboard is a shared coordination space where independent processes, agents, or services post facts, retrieve matching information, and contribute new results without knowing about one another. Contributors can use different expertise, schedules, locations, and data formats, while the accumulated information gradually supports a conclusion. This model suits complex asynchronous workflows because facts can arrive in any order, trigger applicable rules, and produce further facts, and persistent messaging systems can provide similar event storage and pattern-based retrieval. The resulting decoupling reduces many concurrency problems but makes behavior indirect, so the system needs consistent message or application programming interface definitions, end-to-end tracing, and careful management of its many deployable parts.

### The Pragmatic Approach

- Use a blackboard to coordinate workflows whose contributors and inputs operate independently or arrive asynchronously.
- Post facts in a shared, persistent space and let interested agents retrieve them through matching rules.
- Encapsulate policies in a rules engine so each new fact triggers the applicable processing and can generate additional facts.
- Keep message formats and application programming interfaces in a central repository that can generate code and documentation.
- Assign a unique trace identifier to each business function, propagate it through every participant, and reconstruct activity from logs.
- Manage each agent as a separate component so you can update individual parts without replacing the whole system.
