## 45. The Requirements Pit

Requirements are not fixed facts waiting to be collected; they emerge as engineers and clients expose assumptions, edge cases, consequences, and conflicting needs through feedback. An engineer helps users discover what they need, separates stable business intent from changeable policy and current practice, and validates both what the software does and how it fits real work. Treat the entire implementation as an ongoing requirements process, using working software and frequent user feedback to correct misunderstandings before they become expensive.

### The Pragmatic Approach

- Treat every initial request as a hypothesis to explore, not a complete specification. Ask what terms mean, which cases qualify, what exceptions exist, and what may change.
- Probe boundary conditions and unintended incentives. For example, before implementing free shipping above $50, clarify whether the threshold includes tax, shipping charges, electronic products, international orders, and premium delivery.
- Explain consequences with concrete scenarios, then let the client make the business decision. Avoid silently choosing policy while coding.
- Build flexible mockups or prototypes when words cannot resolve ambiguity. Ask users to try them, observe the mismatch, and revise immediately.
- Deliver in short iterations that end with direct user feedback. Limit the cost of a wrong assumption by testing small increments early.
- Work beside real users in their environment. Observe their actual workflow, terminology, constraints, and shortcuts instead of relying only on management descriptions.
- State requirements as needs and semantic invariants, not architecture, implementation, or interface choices. Replace “supervisors and personnel may view records” with “authorized users may view records” when the listed roles are current policy rather than an enduring rule.
- Represent changeable policy as data or configuration. Build a general authorization mechanism and store permitted roles as metadata so policy changes do not require scattered code edits.
- Validate usability as well as feature coverage. Preserve users’ established skills and natural feedback loops instead of forcing technically complete functions through an awkward interaction model.
- Treat written requirements as planning mileposts for the team, not authoritative deliverables for client sign-off. Use working software as the strongest validation of shared understanding.
- Record requirements as short, user-centered stories for planning and prioritization. Keep each story concise enough to trigger clarifying conversations before and during implementation.
- Make scope changes visible. Add each requested feature to the plan, show its cost, and ask which existing work should move out of the iteration to make room.
- Maintain one accessible project glossary. Define each domain term precisely and use the same vocabulary in conversations, stories, code, tests, and support material.
