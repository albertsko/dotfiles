## 15. Estimating

Estimation turns an incomplete question into an explicit, testable model of a system or delivery plan, exposing the assumptions and constraints that determine feasibility. Practicing estimation builds an intuition for magnitudes that helps you reject impractical designs and focus optimization on the subsystems that matter. A useful estimate matches its precision to the available evidence, identifies the parameters that dominate the result, and expresses uncertainty through ranges or conditional scenarios instead of false exactness. Building the model can also reveal a cheaper variant of the requested solution that preserves what matters. For complex software work, replace unsupported up-front certainty with short implementation slices, then revise the schedule from measured progress. Compare estimates with actual outcomes to improve both the model and your engineering judgment.

### The Pragmatic Approach

- Clarify the decision the estimate must support, the required accuracy, and the scope before calculating anything. State assumptions with the result, such as: “Assuming the current request rate and solid-state drive storage, the response time will be about one second.”
- Ask engineers who have solved a comparable problem for measured results and relevant differences before building a model from scratch.
- Build the simplest model that captures the system’s dominant behavior. Stop refining when extra detail costs more effort than the accuracy it adds.
- Use the model to reassess the original request. Propose a faster or cheaper variant when it preserves the capabilities that matter.
- Decompose the model into components and describe how their values combine through addition, multiplication, division, dependencies, or traffic patterns.
- Give every parameter a defensible value or range. Measure critical parameters in the current system or a comparable one, especially parameters that multiply or divide the result, and scrutinize subestimates because they often introduce the largest errors.
- Run optimistic, most likely, and pessimistic scenarios instead of padding a single number. Vary critical parameters to find which assumptions drive the result, report the estimate in terms of those assumptions, and do not treat a formula or dependency chart as proof of accuracy.
- Investigate surprising results. Recheck the arithmetic, then revise the scope, assumptions, or model when the calculation conflicts with observed behavior.
- Match units to justified precision. Quote 1–15 days in days, 3–6 weeks in weeks, and 8–20 weeks in months; think hard before estimating work beyond 20 weeks. Say “about six months” when the evidence cannot support “125 working days.”
- Estimate complex schedules through thin, complete slices unless the work closely matches a previous application built by the same team with the same technology. Confirm requirements, address the highest risks first, implement and integrate, validate with users, and update the expected iterations, scope, and remaining schedule after every slice.
- Explain that the team, its measured productivity, and the working environment determine the schedule. Formalize schedule refinement as part of every iteration so confidence grows with project-specific evidence.
- Record overall estimates, subestimates, assumptions, and actual outcomes. Diagnose errors larger than expected so the next estimate uses a better model or better parameter values.
- Say “I’ll get back to you” when an immediate answer would be a guess, then perform the estimation work before committing.
