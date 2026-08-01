## 8. The Essence of Good Design

Good design makes software easier to change (ETC) because code must adapt to changing needs. Decoupling, cohesion, single responsibility, and clear names support ETC by isolating concerns, limiting each requirement change to focused code, and making code easier to read and modify. Treat ETC as a value that guides design choices, using common sense and educated guesses about future change; when the future is unclear, keep code replaceable so it cannot become a roadblock. Deliberately review and record uncertain choices, then compare predictions with later changes to develop better design instincts.

### The Pragmatic Approach

- Ask whether each saved change, test, or bug fix made the overall system easier or harder to change.
- Choose the design path that best accommodates likely future changes.
- Keep uncertain code replaceable by decoupling concerns and maintaining cohesion.
- Record design options and predictions in an engineering journal, tag the relevant code, and review the notes when the code changes.
- Evaluate design principles, languages, and programming paradigms by how well they support ETC, then reduce their drawbacks and strengthen their benefits.
- Configure the editor to display a periodic `ETC?` reminder and use it to assess the code just written.
