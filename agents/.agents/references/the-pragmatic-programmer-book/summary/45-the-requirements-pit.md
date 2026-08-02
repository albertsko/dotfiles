## 45. The Requirements Pit

Requirements are not preexisting facts waiting to be gathered; assumptions, misconceptions, politics, and unresolved needs often obscure them, so programmers must help clients discover what they want. A client's initial request is an invitation to explore: questions, consequences, direct observation, prototypes, and short feedback cycles reveal edge cases, refine intent, confirm both what the software does and how users need to operate it, and limit the cost of wrong turns. Requirements should express stable business needs and semantic invariants, while changing policy belongs in metadata and architecture, design, and user interface choices remain separate. Working software provides the strongest evidence of understanding, while concise user stories support planning and clarification, visible prioritization controls scope, and a shared glossary keeps domain language consistent.

### The Pragmatic Approach

- Treat every initial request as a starting point for exploration, not a final specification.
- Ask about assumptions, edge cases, exceptions, and likely future changes.
- Explain the consequences of each option with facts, then let the client make the decision.
- Build flexible mockups and prototypes, let clients use them, and revise them in response to feedback.
- Treat the entire project as ongoing requirements discovery, using short iterations that end with direct feedback from relevant clients and users.
- Work alongside actual users to learn their real workflows, expectations, and vocabulary, and to build trust without disrupting their work.
- Design tools around users' established ways of working; validate how users perform their work as well as what functions the software provides.
- Use the simplest non-vague statement that accurately captures the business need and semantic invariants, not architecture, design, user interface details, or current work practices.
- Implement general mechanisms and represent changeable business policy as metadata.
- Write concise user stories from the user's perspective as planning mileposts that prompt clarification before and during implementation, not exhaustive specifications presented for client sign-off.
- Make every proposed feature's cost visible and reprioritize existing work when scope grows.
- Maintain one widely accessible glossary and require everyone to use its terms consistently.
