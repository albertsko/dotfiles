## 39. Algorithm Speed

Algorithm speed describes how an algorithm's time, processor use, or memory grows as its input grows. Big-O notation expresses an upper bound on that growth, such as `O(1)`, `O(log n)`, `O(n)`, `O(n log n)`, `O(n²)`, `O(n³)`, `O(2ⁿ)`, or `O(n!)`, while omitting constant factors and lower-order terms, so it predicts scaling rather than actual resource consumption. Choose an algorithm by estimating its growth and measuring it with realistic inputs because constants, setup costs, input shape, memory pressure, and the production environment can outweigh a theoretical advantage at relevant input sizes.

### The Pragmatic Approach

- Identify the input variables that drive resource use, then estimate the time and memory order of every loop or recursive path. Record realistic upper bounds when inputs depend on external data.
- Recognize common growth patterns: simple statements and direct array access are usually `O(1)`, a loop over `n` items is usually `O(n)`, loops over `m` and `n` are `O(m × n)`, repeatedly halving the search space is `O(log n)`, and partitioning, solving, and combining halves is often `O(n log n)`.
- Treat enumeration of permutations or combinations as a warning sign for factorial or exponential growth. Reduce the search space with a problem-specific heuristic when an exact search cannot finish at realistic sizes.
- Keep only the dominant growth term when comparing scalability. Reduce `O(n² / 2 + 3n)` to `O(n²)`, but do not assume two algorithms in the same class have equal runtime.
- Project the effect of larger inputs before implementation or release. Expect a tenfold input increase to make `O(n)` work roughly ten times larger and `O(n²)` work roughly one hundred times larger.
- Replace unacceptable growth with a better strategy when realistic bounds demand it. For example, look for a divide-and-conquer alternative to reduce `O(n²)` work toward `O(n log n)`.
- Benchmark several increasing input sizes and plot three or four measurements to reveal whether growth is constant, logarithmic, linear, or curving upward. Measure memory as well as elapsed time.
- Test representative and adverse input shapes, such as random and already ordered data, because an algorithm's average behavior can hide a poor worst case.
- Use a profiler to count how often important operations execute when elapsed-time measurements are noisy, then compare those counts with input size.
- Compare complete implementations at the input sizes that matter. Include setup, inner-loop, key-comparison, and memory-pressure costs because a simple higher-order algorithm can outperform a complex lower-order algorithm on small inputs.
- Choose the simplest algorithm that meets the realistic resource bounds, accounting for implementation and debugging effort as well as runtime. Prefer proven library algorithms when they already solve the problem well.
- Confirm that the measured code is a real bottleneck before optimizing it.
- Validate estimates in the production environment with realistic data because cache behavior, paging, and system thrashing can change performance beyond laboratory input sizes.
