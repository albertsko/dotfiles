## Topic 9: DRY, The Evils of Duplication

Software maintenance is a continuous activity throughout the entire development process because requirements, understanding, and environments constantly evolve. Every piece of duplicated knowledge increases maintenance effort and risks system inconsistency when updates occur. The Don't Repeat Yourself (DRY) principle states that every piece of knowledge must have a single, unambiguous, authoritative representation within a system. DRY applies to overall system knowledge and intent rather than just source code text.

### The Pragmatic Approach

- **Centralize Knowledge Representation**: Express each algorithm, business rule, and data contract in one authoritative location.
- **Use Accessor Methods and Calculated Fields**: Derive dependent data values dynamically using accessor methods to satisfy Meyer's Uniform Access Principle instead of storing redundant state.
- **Isolate Performance Caches**: Localize state caching within module boundaries so external consumers interact with a unified interface without managing cached synchronization.
- **Automate Interface Definitions**: Generate code, tests, and documentation from single-source API specifications such as OpenAPI or schema introspection to eliminate structural duplication across system boundaries.
- **Foster Team Communication and Reuse**: Establish shared utility repositories, conduct regular code reviews, and hold daily standup meetings so developers discover existing functionality rather than reimplementing code.

### Common Mistakes

- **Equating DRY Only with Code Copying**: Treating DRY as merely avoiding copy-pasted code lines while ignoring duplicate knowledge across documentation, schemas, and architecture.
- **Confusing Coincidental Code Match with Knowledge Duplication**: Merging structurally identical functions that validate distinct domain concepts with independent reasons to change.
- **Duplicating Code Intent in Documentation**: Writing function comments that restate what the code achieves, causing comments and implementation to diverge over time.
- **Exposing Raw Derived Fields**: Storing redundant state directly in public data structures without using accessors or calculating properties on demand.
- **Working in Isolation**: Developing duplicate utilities independently due to poor team communication and hard-to-find shared libraries.
