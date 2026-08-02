## 8. The Essence of Good Design

Good software design adapts to its users by making code easier to change through clear names, isolated concerns, cohesive responsibilities, and replaceable components. Treat Easier to Change (ETC) as a decision-making value: use present knowledge to choose the path that will best accommodate likely change, and when the future is unclear, preserve replaceability and learn from later changes.

### The Pragmatic Approach

- Ask after each edit, test, and bug fix: “Did the change make the overall system easier or harder to change?”
- Isolate concerns so a modification stays local; for example, keep payment-provider code behind a small interface instead of spreading vendor-specific calls across the application.
- Give each module one cohesive responsibility so a requirement change affects one place.
- Choose precise names that make code faster to understand and safer to modify.
- Make uncertain design choices replaceable: keep boundaries narrow, dependencies decoupled, and related behavior cohesive.
- Record uncertain design forks, available choices, and predictions about likely changes in an engineering journal, and tag the relevant source; revisit both when the code changes to calibrate future design judgment.
- Evaluate each design principle, language feature, and programming paradigm by whether it makes likely changes easier; counteract aspects that create rigidity and emphasize those that preserve replaceability.
