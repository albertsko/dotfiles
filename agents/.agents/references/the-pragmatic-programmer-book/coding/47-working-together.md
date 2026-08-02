## 47. Working Together

Work with developers, users, testers, and sponsors while writing code so the team can resolve requirements, design choices, and defects through immediate discussion and executable feedback instead of relying on extensive documentation. Pair programming combines a typist focused on implementation details with a partner tracking design, scope, and quality, while mob programming applies the same live-coding collaboration to a small, diverse group for difficult problems. Because a system tends to reflect its team's communication paths, organize collaboration around the modular boundaries and user involvement you want the software to exhibit.

### The Pragmatic Approach

- Pair for a few hours at a time over at least two weeks before judging the practice, because the workflow takes time to become natural.
- Share responsibility for the solution: let one developer type while both developers reason about the problem, then switch typing duties as needed.
- Use the non-typing partner's attention to examine design, scope, naming, edge cases, and shortcuts while the typist handles syntax and implementation details.
- Form a mob of four or five people to brainstorm unfamiliar work or diagnose a difficult defect, and rotate the typist every five to ten minutes.
- Include the people who can resolve uncertainty, such as users, testers, sponsors, and domain experts, in live coding sessions instead of limiting collaboration to developers.
- Start with short sessions and simple exercises before applying a new collaboration style to critical production code.
- Critique the code rather than the person. Say, “Let's inspect this block and its assumptions,” instead of, “You're wrong.”
- Listen to competing viewpoints and optimize for code quality rather than personal credit.
- Run frequent retrospectives, identify one concrete improvement, and apply it in the next pairing or mobbing session.
- Shape team communication around the architecture you want; for example, give a team clear ownership of a module when you need that module to remain independently maintainable.
