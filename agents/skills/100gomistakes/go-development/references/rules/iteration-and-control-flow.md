# Iteration and control flow

Load when: range semantics, iteration addresses, map order, loop exits, per-iteration cleanup or iterators

<a id="g66"></a>

- **G66** When mutating slice elements in a loop. Then Iterate indexes and update the original element. Pointer elements or pointer-valued fields share referents. Pointer slices may cost cache locality. Because The range value is a copy and assigning its fields does not replace the stored struct.

  Sources: `BP66`.

<a id="g67"></a>

- **G67** When iterating every collection element. Then Use range and omit unused values or use the blank identifier. Use a traditional for loop when controlling step or termination is useful. Because Avoids unnecessary index management and off-by-one mistakes.

  Sources: `BP67`.

<a id="g68"></a>

- **G68** When a range loop changes its input expression. Then Reason from the initially evaluated range expression, including original slice length or channel. Reassignment or append does not retarget the active range. If at most one iteration variable is present and x or len(x) is constant, the range expression x is not evaluated. See the [range specification](https://go.dev/ref/spec#For_range). Use a traditional loop for a changing condition, checking termination when appending. Later operations on a reassigned channel use its new value. Because The loop works from the evaluated expression, such as the original slice length or channel.

  Sources: `BP68`.

<a id="g69"></a>

- **G69** When ranging over an array while observing mutations. Then Use direct index access or range over the array pointer when later updates must be seen. A pointer also avoids copying a large array. Source prose has an apparent reversed-output typo in the index example. Because Ranging values over an array copies the array.

  Sources: `BP69`.

<a id="g70"></a>

- **G70** When retaining addresses of slice or map iteration values. Then Check the effective module/file language version. Go 1.22+ gives fresh per-iteration variables when the loop declares them with :=, including three-clause loops. Assignment with = still reuses existing variables. In older language modes or with explicitly shared variables, copy the value or pass it as an argument. Distinct value copies differ from pointers to original slice elements obtained by index. Slice range visits increasing indexes. Map iteration order is unspecified. Fresh variables do not determine goroutine scheduling order. Because Loop declaration semantics control variable identity, while pointers into a slice intentionally share its elements.

  Sources: `BP70`, `RV239`, `RV242`.

  Example: [Declared versus assigned range variables](../../examples/loops-go122/loop_test.go).

<a id="g71"></a>

- **G71** When depending on order from a map. Then Do not assume key, insertion, stable, or uniformly random iteration order. Choose an ordered representation when required. A serializer may impose its own ordering, which is not a map property. Unspecified ordering supplies no fairness or uniform-randomness guarantee. Because Map iteration is unspecified and can vary across loops.

  Sources: `BP71`.

<a id="g72"></a>

- **G72** When adding map entries while iterating. Then Separate the map being read from the map being written when deterministic inclusion matters. The book uses a copy as the destination. Single-goroutine mutation permission is not concurrency safety. Adding entries within the same goroutine is legal but does not control whether the new entries are visited. Because New entries may be visited or skipped unpredictably.

  Sources: `BP72`.

<a id="g73"></a>

- **G73** When breaking or continuing an outer loop containing switch or select. Then Use a meaningful label to target the intended loop. Labels for structured loop control are idiomatic. Because An unlabeled break exits the innermost for, switch, or select.

  Sources: `BP73`.

<a id="g74"></a>

- **G74** When each loop iteration acquires a resource needing cleanup. Then Extract iteration work into a function and defer cleanup there. A closure also works. If measured call overhead matters, clean up explicitly on every path. An extracted helper also makes iteration work independently testable. Because Defers run on function return, not on each iteration.

  Sources: `BP74`.

<a id="g231"></a>

- **G231** When choosing pointer collections. Then Use pointers when sharing is intended, pointers already exist, or large frequently mutated values justify avoiding copies. Do not choose pointers automatically, clarify who shares the pointee. Pointer elements can worsen locality and make ownership/sharing less obvious. Avoid pointers merely by habit. Because Pointer storage changes semantics and mutation cost.

  Sources: `BP231`.

<a id="g250"></a>

- **G250** When using integer or function range and iterator helpers. Then Require Go 1.22 language support for integer range and Go 1.23 for stable function range. Match the allowed yield signature, stop producing when yield returns false, and preserve cancellation/resource ownership. iter plus slices/maps iterator helpers are Go 1.23 APIs. Go 1.24 strings/bytes sequence helpers can avoid intermediate collections but retain their underlying data. Because Lazy traversal changes allocation and lifetime behavior, and function range was only experimental in Go 1.22.

  Sources: `RV239`, `RV286`, `RV297`, `RV351`, `RV384`.
