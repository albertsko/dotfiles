## Topic 39: Algorithm Speed

Pragmatic Programmers regularly estimate how algorithms scale regarding execution time, memory usage, and processor consumption as input sizes grow. Big-O notation provides a mathematical framework for expressing upper bounds on resource growth, focusing on dominant terms while ignoring low-order terms and constant multipliers. Algorithm complexity ranges from constant $O(1)$ and logarithmic $O(\log n)$ to linear $O(n)$, divide-and-conquer $O(n \log n)$, quadratic $O(n^2)$, and exponential $O(2^n)$ or factorial $O(n!)$. Loop structures signal expected growth rates: single loops run in linear time, nested loops run in quadratic time, binary splits run in logarithmic time, divide-and-conquer routines run in $O(n \log n)$ time, and combinatoric searches run in exponential or factorial time.

### The Pragmatic Approach

Pragmatic algorithm design balances theoretical growth analysis with empirical measurement and real-world constraints:

- **Estimate algorithmic complexity**: Evaluate loops, recursive calls, and data structures during design to anticipate resource demands before writing code.
- **Refactor high-order algorithms**: Replace quadratic $O(n^2)$ routines with divide-and-conquer $O(n \log n)$ algorithms when processing growing inputs.
- **Test theoretical estimates empirically**: Measure execution times across varying input sizes and plot performance curves to verify runtime behavior.
- **Profile execution bottlenecks**: Use code profilers to track statement execution counts against input sizes when accurate timing measurements are difficult to capture.
- **Balance complexity with setup overhead**: Select simpler algorithms with lower constant factors for small datasets, as setup overhead can outweigh theoretical speed advantages.

### Common Mistakes

Unexamined algorithm choices and flawed assumptions lead to performance degradation and wasted engineering effort:

- **Optimizing code prematurely**: Tuning algorithms before profiling confirms an actual execution bottleneck in the system.
- **Relying solely on asymptotic theory**: Ignoring constant factors, setup overheads, or small dataset dynamics where simple algorithms outperform complex ones.
- **Assuming linear scaling across environments**: Expecting small-scale test performance to scale without verifying memory limits, cache behavior, or system thrashing.
- **Neglecting non-time resource limits**: Focusing exclusively on execution time while failing to model memory consumption and spatial requirements.
- **Failing to test with production data**: Validating algorithms using only synthetic or random test data while ignoring ordered inputs or production scale datasets.
