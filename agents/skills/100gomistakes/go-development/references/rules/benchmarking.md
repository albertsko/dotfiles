# Benchmarking

Load when: benchmark timing, optimization elimination, representative inputs or statistical comparison

<a id="g188"></a>

- **G188** When benchmark setup is outside the work being measured. Then With traditional b.N loops, ResetTimer after one-time setup and StopTimer/StartTimer around unrelated per-iteration work. On Go 1.24+, consider the prescribed for b.Loop() form, which excludes surrounding setup/cleanup and runs them once. Untimed setup still consumes wall-clock time, so select benchtime deliberately. Because Otherwise reported time and allocation costs include unrelated work.

  Sources: `BP188`, `RV343`.

<a id="g189"></a>

- **G189** When interpreting small benchmark differences. Then Repeat runs, inspect variation with benchstat, and use adequate benchtime on a quiet representative machine. Conclusions apply to the measured compiler, architecture, and workload. Production can differ. Power state, code/data alignment and cache layout can influence tiny differences. The book names perflock as an optional way to limit competing machine activity. Because Thermal, scheduling, cache, and other effects can reverse apparent results.

  Sources: `BP189`.

<a id="g190"></a>

- **G190** When a benchmark calls a pure function whose result is unused. Then Make results observable in traditional b.N benchmarks, for example keep a local result and publish it to a sink after the loop to limit sink overhead. Go 1.24+ B.Loop protects call inputs/results in its prescribed loop form. Go 1.24-1.25 inhibited inlining there, while Go 1.26 restores normal inlining and protects assigned variables too. Compare compiler versions explicitly rather than disabling valid optimization. Because Inlining and dead-code elimination can turn the measurement into an empty loop.

  Sources: `BP190`, `RV343`, `RV492`.

<a id="g191"></a>

- **G191** When repeated benchmark iterations reuse input data. Then Match warm versus fresh input and cache state to the intended use, recreating data when needed. Recreating data is not universally correct if production intentionally reuses it. Keep setup outside measured time. Because Repeated observation can warm caches and produce misleading results for fresh-input workloads.

  Sources: `BP191`.
