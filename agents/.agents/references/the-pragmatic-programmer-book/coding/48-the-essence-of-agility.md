## 48. The Essence of Agility

Agility is a way of developing software, not a prescribed process or ready-made solution. Continuously uncover better ways to work by using individuals and interactions, working software, customer collaboration, and responses to change to guide contextual decisions, while treating processes and tools, documentation, contracts, and plans as supporting resources. Because unknowns defeat static plans, use a short feedback loop at every scale: understand the current state, take the smallest meaningful step toward the goal, evaluate the result, repair any damage, and repeat; keep the design easy to change so the team can act on feedback immediately.

### The Pragmatic Approach

- Establish the current behavior and the desired outcome before changing code.
- Implement the smallest meaningful step toward the outcome, then pause for feedback instead of committing to a complete plan upfront.
- Evaluate each step by observing the working software and gathering feedback from the people affected by it; repair anything the step breaks before continuing.
- Reassess whether the intended change is still necessary after each feedback cycle; stop or pursue a non-software solution when the evidence points there.
- Apply the feedback loop to small coding decisions as well as large features. For example, replace `owner = accountOwner(accountID)` with `email = emailOfAccountOwner(accountID)` when the caller needs only an email address, reducing unnecessary coupling to the account model.
- Use agility's values as criteria for deciding what to do in the current context, not as a fixed set of instructions.
- Prefer direct collaboration and executable results when a process, document, contract, or plan conflicts with evidence from the software or its users.
- Design changes so they are easy to adjust or undo; minimize coupling so revising the code remains painless.
- Review the development process regularly, run small experiments, and retain only practices that improve the team's results in its current context.
