## Topic 15: Estimating

Estimation transforms unknown requirements into realistic feasibility assessments and system models. Developers estimate to discover underlying performance bottlenecks, gauge project timelines, and avoid surprises during implementation. Choosing units that match the precision of the estimate prevents stakeholders from inferring false accuracy. When asked for an estimate on the spot, give the answer "I will get back to you" to gain time to analyze the problem.

### The Pragmatic Approach

- **Scale units to imply accuracy**: Match quoted units to duration uncertainty. Use days for 1–15 days, weeks for 3–6 weeks, and months for 8–20 weeks. Reevaluate the project structure before estimating durations over 20 weeks.
- **Consult experienced peers**: Ask someone who has already solved a similar problem before constructing complex mathematical models.
- **Clarify the scope**: Define assumptions, operational constraints, and domain boundaries before calculating values.
- **Build and decompose models**: Create a simplified model of the system, decompose the model into key components, and isolate multiplying parameters over minor additive terms.
- **Calculate parameter ranges**: Run calculations using optimistic, nominal, and pessimistic values to uncover which parameters drive system performance.
- **Track accuracy**: Record estimates, compare predictions against actual results, and adjust future models after discovering the root causes of errors.
- **Iterate the schedule with the code**: Refine project completion dates after each development iteration based on team experience.

### Common Mistakes

- **Giving off-the-cuff estimates**: Answering immediately at the coffee machine leads to inaccurate commitments based on incomplete information.
- **Conveying false precision**: Quoting exact days for long durations tricks listeners into assuming high accuracy.
- **Confusing PERT charts with certainty**: Relying on Program Evaluation Review Technique (PERT) formulas without prior experience creates unfounded confidence in rigid project schedules.
- **Fixing schedules upfront**: Setting rigid completion dates before completing initial development iterations ignores team productivity and environmental reality.
- **Over-refining early models**: Spending excessive time tuning minor additive parameters yields negligible accuracy improvements while adding model complexity.
