## 39. Algorithm Speed

Algorithm speed describes how an algorithm's use of time, processor capacity, memory, or another resource changes as its input grows. Big-O notation expresses an upper bound on that growth while omitting constant factors and lower-order terms: common orders include constant `O(1)`, logarithmic `O(log n)`, linear `O(n)`, linearithmic `O(n log n)`, quadratic `O(n²)`, cubic `O(n³)`, exponential `O(2ⁿ)`, and factorial `O(n!)`. Big-O describes scaling, not actual resource usage, so algorithms in the same order can differ greatly in speed, and an algorithm with a better growth rate can still lose on small inputs because of setup costs or expensive operations. Common code structures reveal likely growth: a single loop is usually linear, nested loops multiply their limits, repeatedly halving the search space is logarithmic, dividing and combining input is often linearithmic, and examining permutations can produce factorial growth. Estimates must account for worst cases and real conditions such as input ordering, data volume, comparison cost, memory pressure, and system thrashing, then be tested with representative production data. Choose the simplest suitable algorithm, measure before optimizing, and improve only confirmed bottlenecks.

### The Pragmatic Approach

- Estimate the growth order of every loop, nested loop, and recursive call.
- Ask how large each input can become, especially when external data controls its size.
- Replace quadratic work with a divide-and-conquer approach when large inputs make the quadratic cost unacceptable.
- Use domain-specific heuristics when combinatorial growth makes exhaustive work impractical.
- Measure runtime and memory across several input sizes, then plot the results to identify the growth curve.
- Test representative, ordered, random, small, large, and worst-case inputs where relevant, then validate performance in the production environment with real data.
- Use a profiler to count executed operations and plot them against input size when elapsed-time measurements are unreliable.
- Include constant costs, setup work, expensive comparisons, memory limits, and system behavior in algorithm choices.
- Prefer proven library sort routines unless measurements justify writing your own.
- Prefer a straightforward algorithm for small, bounded inputs when a more sophisticated algorithm adds no practical benefit.
- Confirm that code is a bottleneck before spending time optimizing it.
