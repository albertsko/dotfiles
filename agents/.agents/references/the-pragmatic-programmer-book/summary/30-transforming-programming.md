## 30. Transforming Programming

Treat a program as a sequence of transformations that converts input data into output data, instead of centering the design on code structures and mutable objects. Start with the required input and output, identify the intermediate data forms, and decompose each stage until every transformation is a small function whose output fits the next function's input. Express the sequence with a pipeline operator when available or with clear successive assignments when it is not, making the data flow mirror the requirement while keeping functions short, reusable, and loosely coupled. Pass data between functions instead of scattering state across objects. Handle failures by passing wrapped success or error results and either propagating errors within each transformation or using a bind function that runs the next transformation only after success.

### The Pragmatic Approach

- Define the program's input and required output before choosing code structures.
- List the intermediate data forms that connect the input to the output.
- Decompose each stage into smaller transformations until every function is straightforward to implement.
- Pass each function's result directly to the next compatible function.
- Use a pipeline operator or successive assignments to make the transformation sequence visible.
- Pass state through the flow instead of hiding mutable state in communicating objects.
- Wrap results as success values or errors, and stop later transformations from running after a failure.
