## 15. Estimating

Estimation turns an incomplete question into an explicit, testable model of a system or delivery plan, exposing the assumptions and constraints that determine feasibility. A useful estimate matches its precision to the available evidence, identifies the parameters that dominate the result, and expresses uncertainty through ranges or conditional scenarios instead of false exactness. For complex software work, replace unsupported up-front certainty with short implementation slices, then revise the schedule from measured progress. Compare estimates with actual outcomes to improve both the model and your engineering judgment.

### The Pragmatic Approach

- Clarify the decision the estimate must support, the required accuracy, and the scope before calculating anything. State assumptions with the result, such as: “Assuming the current request rate and solid-state drive storage, the response time will be about one second.”
- Ask engineers who have solved a comparable problem for measured results and relevant differences before building a model from scratch.
- Build the simplest model that captures the system’s dominant behavior. Stop refining when extra detail costs more effort than the accuracy it adds.
- Decompose the model into components and describe how their values combine through addition, multiplication, division, dependencies, or traffic patterns.
- Give every parameter a defensible value or range. Measure critical parameters in the current system or a comparable one, especially parameters that multiply or divide the result.
- Run optimistic, most likely, and pessimistic scenarios instead of padding a single number. Vary critical parameters to find which assumptions drive the result, and report the estimate in terms of those assumptions.
- Investigate surprising results. Recheck the arithmetic, then revise the scope, assumptions, or model when the calculation conflicts with observed behavior.
- Match units to justified precision. Say “about six months” when the evidence cannot support “125 working days.”
- Estimate complex schedules through thin, complete slices: confirm requirements, address the highest risks first, implement and integrate, validate with users, and update the remaining schedule after every slice.
- Record overall estimates, subestimates, assumptions, and actual outcomes. Diagnose errors larger than expected so the next estimate uses a better model or better parameter values.
- Say “I’ll get back to you” when an immediate answer would be a guess, then perform the estimation work before committing.
