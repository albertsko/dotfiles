# Time and serialization

Load when: duration units, timers, JSON, monotonic time, time zones or omission/presence semantics

<a id="g146"></a>

- **G146** When supplying a duration. Then Use explicit time units such as time.Second or 100*time.Millisecond. time.Duration is a defined integer type, despite the source calling it an alias. Because Bare integers are nanoseconds and easily mistaken for milliseconds.

  Sources: `BP146`.

<a id="g147"></a>

- **G147** When a hot loop or frequently called handler needs timeout logic. Then Determine program compatibility settings from the active workspace or work module and explicit overrides, as well as the runtime version. Before Go 1.23, and on Go 1.23-1.26 with older program defaults or asynctimerchan=1, coordinate Stop, any required drain and Reset with the sole receiver to prevent stale values and races. With Go 1.23 synchronous timer semantics (program defaults for Go >=1.23 unless overridden), Stop/Reset prevent later stale receives and unreachable timers/tickers can be collected. Go 1.27 removes asynctimerchan and uses synchronous channels even for old modules. Use nonblocking receive, not len/cap, to inspect readiness. Reuse only when measurement justifies the complexity. Because Repeated timers can add allocation work, but retention and channel-reset correctness depend on the active timer semantics.

  Sources: `BP147`, `RV295`, `RV513`.

<a id="g148"></a>

- **G148** When a long-running timer consumer can terminate. Then Provide cancellation or another exit protocol and stop timers when their work should cease. Cancel recreated timeout contexts on every path. Under Go 1.23 synchronous timer semantics and all Go 1.27 runtimes, Stop is no longer needed solely to make an unreachable timer collectible. It remains useful for lifecycle control. Because The example's endless loop is not a production lifecycle.

  Sources: `BP148`, `RV295`, `RV513`.

<a id="g149"></a>

- **G149** When a serialized struct embeds a type with custom JSON methods. Then Use a named field or explicitly implement the parent marshaling behavior. Custom marshaling must stay synchronized with added fields. Because Promoted MarshalJSON/UnmarshalJSON methods can silently replace the parent object's representation.

  Sources: `BP149`.

<a id="g150"></a>

- **G150** When comparing times after JSON round trips. Then Use time.Time.Equal for instant comparison. Equal uses monotonic readings if both operands have them, otherwise wall time. JSON removes monotonic metadata. If raw struct equality is deliberately required, normalize both monotonic metadata and location. Truncate(0) alone does not normalize location. Because Serialization drops monotonic metadata and representations may differ.

  Sources: `BP150`.

<a id="g151"></a>

- **G151** When output must use a consistent time zone. Then Convert times to the chosen location or UTC before serialization. Handle LoadLocation errors. Because Local environment otherwise affects representation.

  Sources: `BP151`.

<a id="g152"></a>

- **G152** When measuring elapsed time. Then Use monotonic clock behavior rather than wall-clock-only arithmetic. The source explains time.Time can carry both components. Use monotonic-aware time operations. Serialization discards that metadata, so serialized timestamps cannot preserve the same elapsed-time evidence. Because Wall clocks can jump forward or backward after synchronization.

  Sources: `BP152`.

<a id="g153"></a>

- **G153** When decoding JSON into map[string]any. Then For encoding/json v1 decoding into map[string]any, expect float64 numbers by default and check dynamic types before assertions. Prefer typed decoding for known schemas. Select a decoder number mode when exact numeric handling requires it. Go 1.27 v2 has its own options and behavior, which require boundary tests. Because An integer-looking JSON number is not automatically a Go int.

  Sources: `BP153`, `RV518`.

<a id="g259"></a>

- **G259** When choosing omission rules for JSON fields. Then Distinguish omitted values from explicit zero and distinguish omitzero from omitempty. Go 1.24+ encoding/json supports omitzero using IsZero or the type zero value, including zero time.Time. Combined tags omit either condition. Go 1.26 new(expression) can construct optional pointers only with that language baseline. Because Serialization tags and presence representations determine the external contract.

  Sources: `RV366`, `RV445`.

<a id="g260"></a>

- **G260** When migrating JSON implementations or upgrading to Go 1.27. Then Keep encoding/json v1 and encoding/json/v2 contracts separate. In Go 1.27 both use the new engine, but v1 preserves its semantics except possible error wording. v2 defaults reject invalid UTF-8 and duplicate object names. Test nil/empty values, case matching, numbers, custom methods and exact wire requirements. For experimental v2 migrations, review inline-to-embed, removed format/unknown tags, removed options and changed token errors. Because Supported JSON v2 differs from both v1 and earlier experiments.

  Sources: `RV406`, `RV518`.
