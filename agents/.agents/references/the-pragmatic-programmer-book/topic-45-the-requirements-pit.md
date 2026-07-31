## Topic 45: The Requirements Pit

Requirements do not exist waiting to be gathered. Clients rarely know exactly what they want at the start of a project. Programmers help clients discover their true needs by asking questions, generating feedback, and exploring consequences together.

### The Pragmatic Approach

- **Treat requirements as an ongoing process**: Discover requirements iteratively through short development cycles and continuous feedback.
- **Explore consequences**: Ask clarifying questions about edge cases to help clients realize the practical implications of their requests.
- **Use prototypes and mockups**: Build quick visual mockups to test ideas and ask clients if the implementation matches their intentions.
- **Work directly with users**: Spend time in the user's operational environment to understand real workflows and build trust.
- **Separate policy from requirements**: Capture core business invariants as requirements, and implement changeable business policies as configurable metadata.
- **Keep documentation concise**: Write short user stories on index cards to spark conversation and track project priorities.
- **Maintain a project glossary**: Define and publish shared domain vocabulary to ensure users and developers use terms consistently.

### Common Mistakes

- **Assuming requirements are static**: Treating requirements as a fixed, up-front phase rather than an evolving feedback loop.
- **Accepting initial requests without question**: Implementing initial statements of need without exploring edge cases or hidden assumptions.
- **Writing monolithic specifications**: Creating massive requirements documents that clients rarely read and that rest on unverified assumptions.
- **Conflating requirements with design**: Specifying architecture, user interfaces, or implementation details inside requirements instead of focusing on business needs.
- **Hardcoding business policy**: Embedding specific policy rules directly into application code, which forces code changes whenever policy updates.
- **Ignoring scope creep**: Allowing features to expand without showing clients how new requests impact project timelines and priorities.
