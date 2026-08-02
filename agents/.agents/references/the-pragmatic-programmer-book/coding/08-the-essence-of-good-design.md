## 8. The Essence of Good Design

Good design makes code easier to change: it adapts to evolving needs through clear names, isolated concerns, cohesive responsibilities, and replaceable components. Treat Easier to Change (ETC) as a decision-making value, using present knowledge to choose flexible paths and learning from later changes when future requirements are uncertain.

### The Pragmatic Approach

- Ask after each edit, test, and bug fix: “Did the change make the overall system easier or harder to change?”
- Isolate concerns so a modification stays local; for example, keep payment-provider code behind a small interface instead of spreading vendor-specific calls across the application.
- Give each module one cohesive responsibility so a requirement change affects one place.
- Choose precise names that make code faster to understand and safer to modify.
- Make uncertain design choices replaceable: keep boundaries narrow, dependencies decoupled, and related behavior cohesive.
- Record uncertain design forks, available choices, and predictions about likely changes; revisit the notes when the code changes to calibrate future design judgment.
- Evaluate each design principle, language feature, or programming paradigm by whether it makes likely changes easier; reduce features that create rigidity and emphasize those that preserve replaceability.
