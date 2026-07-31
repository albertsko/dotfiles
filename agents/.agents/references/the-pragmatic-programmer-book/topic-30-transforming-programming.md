## Topic 30: Transforming Programming

Programs transform input data into output data. Focusing heavily on class hierarchies, object state, or language frameworks often obscures this core purpose. Thinking of software as a sequence of data transformations clarifies system structure, reduces coupling, and simplifies error handling.

### The Pragmatic Approach

- **Model software as data pipelines**: Design programs by identifying input and output formats, then linking processing steps into a continuous pipeline.
- **Pass state through steps**: Avoid storing mutable state in long-lived variables or object properties. Pass data explicitly from function to function.
- **Decouple processing stages**: Keep transformation steps independent so each step only depends on the structure of its immediate input and output.
- **Handle errors cleanly**: Wrap data with status information so pipelines propagate errors safely without crashing or leaking state.

### Common Mistakes

- **Hoarding state**: Encapsulating data within complex object hierarchies or global structures instead of flowing data through processing steps.
- **Over-engineering classes**: Building elaborate class inheritance structures when simple data transformation functions suffice.
- **Ignoring data formats**: Writing code before defining the exact data shapes that move between pipeline stages.
- **Inconsistent error handling**: Allowing pipeline steps to raise unhandled exceptions or return incompatible data structures on failure.
