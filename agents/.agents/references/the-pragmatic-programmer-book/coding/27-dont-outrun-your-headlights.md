## 27. Don’t Outrun Your Headlights

Software development has a limited planning horizon: the farther a design, estimate, or requirement reaches into the future, the more it depends on speculation. Work in small, deliberate steps and let independently observed feedback set the pace, then reduce the cost of incorrect predictions by keeping code cohesive, loosely coupled, and easy to replace.

### The Pragmatic Approach

- Split work into the smallest step that produces independent feedback, complete it, inspect the result, and adjust before continuing.
- Match each step to a fast feedback mechanism. Explore an application programming interface in a read-evaluate-print loop, run a unit test after a code change, and demonstrate a feature to users before expanding it.
- Treat any task that requires guessing distant completion dates, future requirements, future maintenance needs, or unavailable technology as too large. Narrow the task to the next decision that current evidence can support.
- Design only for changes you can reasonably see. Avoid speculative extension points and abstractions for hypothetical needs.
- Make uncertain code easy to discard or replace. Isolate it behind a small interface, keep each component focused, and minimize dependencies so an unexpected change does not spread through the system.
- Reassess the plan whenever feedback disproves an assumption. Change direction while the unfinished step and replacement cost remain small.
