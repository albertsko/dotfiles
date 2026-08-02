## 30. Transforming Programming

Design programs as explicit, possibly nested sequences of data transformations that turn defined inputs into defined outputs instead of starting with classes, frameworks, or mutable object state. Decomposing a requirement into small, composable stages clarifies and flattens the design, shortens functions, and reduces coupling because each stage depends only on the data it receives and produces; carrying success or failure in a consistent result type also makes error handling predictable across the sequence.

### The Pragmatic Approach

- Define the overall transformation before choosing implementation details: state the input, the required output, and the meaning of the conversion. For example, treat an anagram finder as a transformation from a set of letters into words grouped by length.
- Decompose the overall transformation from the top down until every stage performs one simple operation. Convert letters to subsets, discard subsets below the minimum length, calculate signatures, look up matching words, and group the matches.
- Name each stage after the data change it performs, such as `find_matching_lines`, `truncate_lines`, or `group_by_length`, so the composed sequence reads like the requirement.
- Compose stages so each stage's output matches the next stage's input. Use a pipeline operator when the language provides one; otherwise, use explicit intermediate assignments such as `content`, `matchingLines`, and `truncatedLines` to preserve visible data flow.
- Pass intermediate data explicitly instead of scattering it across mutable objects. Keep transformations reusable by making them depend on input values rather than unrelated object state or command-style interactions.
- Use collection operations that express the transformation directly: map values to new forms, filter unwanted values, flatten nested results, sort values, and group values by a meaningful key.
- Let static types check pipeline boundaries when available. Define stage signatures precisely so the compiler reports attempts to connect incompatible outputs and inputs.
- Wrap every stage result in one consistent success-or-error representation, such as `{:ok, value}` and `{:error, reason}`, instead of passing raw values in successful cases and handling failures ad hoc.
- Preserve the first failure throughout the pipeline. When stages handle the wrapper, make each later stage return an existing error unchanged without running its normal transformation logic; for true short-circuiting, compose stages through a helper such as `andThen`, which invokes the next function only for a successful value.
- Keep transformation functions focused on business logic when the composition mechanism can handle the wrapper. Make each stage accept an unwrapped value and return a new wrapped result, then let the composition mechanism manage short-circuiting.
