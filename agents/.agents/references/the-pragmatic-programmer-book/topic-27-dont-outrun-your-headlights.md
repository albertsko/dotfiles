## Topic 27: Don’t Outrun Your Headlights

Software development offers limited visibility into the future. Developers who move faster than their ability to gather feedback risk making decisions based on speculation rather than facts. Pragmatic programmers treat the rate of feedback as a speed limit, ensuring every decision relies on validated feedback.

### The Pragmatic Approach

- **Take small steps always**: Break work into small, deliberate steps. Verify the results of each step before taking the next one.
- **Rely on rapid feedback**: Use Read-Eval-Print Loops (REPL), unit tests, and user demonstrations to confirm or disprove assumptions quickly.
- **Design for replaceability**: Make code easy to replace rather than trying to anticipate long-term future needs. Replaceable code stays modular, decoupled, and easy to adjust when requirements change.
- **Plan only for what you can see**: Limit architecture and task planning to the immediate future that you can accurately evaluate.

### Common Mistakes

- **Engaging in fortune-telling**: Estimating deadlines months in advance or guessing future user needs and technology availability.
- **Over-engineering for future maintenance**: Writing complex abstractions for hypothetical future extensions beyond current visibility.
- **Taking steps that are too big**: Committing to large tasks without intermediate feedback loops to validate progress.
- **Ignoring unpredictable changes**: Assuming tomorrow will always look like today and failing to account for unexpected disruptions.
