# Numeric correctness

Load when: integer ranges, numeric literals, floating-point calculations or numerical comparisons

<a id="g39"></a>

- **G39** When writing octal literals such as permissions. Then Use the explicit lowercase 0o prefix. Other bases have explicit prefixes too. Recognize legacy leading-zero octal when reviewing existing code. Because A leading zero alone is easily mistaken for decimal and uppercase O resembles zero.

  Sources: `BP39`.

<a id="g40"></a>

- **G40** When writing long numeric literals. Then Use underscore separators to improve readability. Choose meaningful grouping for the representation. Because Digit grouping makes magnitude or bit groups easier to inspect.

  Sources: `BP40`.

<a id="g41"></a>

- **G41** When choosing integer types or converting large values. Then Choose a sufficient range and check runtime overflow where values may exceed it. int and uint widths depend on the platform. Small types, large numbers, and conversions deserve particular attention. Do not add elaborate guards to ordinary counters whose chosen type safely covers the known domain. Because Runtime overflow and underflow are silent, unlike invalid constants.

  Sources: `BP41`.

<a id="g42"></a>

- **G42** When incrementing a bounded integer. Then Check against the matching maximum before incrementing when overflow must be detected. The example panics, but error policy depends on the API. Use matching math limits, including architecture-dependent MaxInt or MaxUint where relevant. Because The maximum plus one wraps rather than panics.

  Sources: `BP42`.

<a id="g43"></a>

- **G43** When adding bounded integers. Then Check both upper and lower bounds before signed addition when the input domain can overflow. A check of a > MaxInt-b is only safe under suitable positive-operand assumptions. Choose panic or an error according to the API contract. Because Positive addition can wrap to a negative result.

  Sources: `BP43`.

<a id="g44"></a>

- **G44** When multiplying bounded integers. Then Validate the result range, handling zero, one and minimum-integer edge cases before any division-based verification. The book's minimum-value guard is conservative, not a complete reusable validator. Use math/big when the domain exceeds fixed-width integers. Choose error or panic policy for the API. Because A wrapped result can silently corrupt arithmetic.

  Sources: `BP44`.

<a id="g45"></a>

- **G45** When comparing approximate floating-point results. Then Compare within an acceptable delta instead of assuming exact equality. Choose tolerance for the domain. The book gives InDelta as a test example. Because Representation and accumulated errors can differ, including across processors.

  Sources: `BP45`.

<a id="g46"></a>

- **G46** When a numeric domain can produce special floating values. Then Check math.IsInf and math.IsNaN explicitly. Special values are not ordinary finite numbers. Because NaN does not equal itself and undefined operations need deliberate handling.

  Sources: `BP46`.

<a id="g47"></a>

- **G47** When accumulating floating-point additions and subtractions. Then Group similar magnitudes before combining different magnitudes. Evaluate actual numerical behavior for the domain. Similar-magnitude grouping remains an accuracy heuristic. Results still approximate real arithmetic. Because Operation order affects rounding error.

  Sources: `BP47`.

<a id="g48"></a>

- **G48** When reordering mixed floating-point operations for accuracy. Then Consider algebraic regrouping, including multiplication/division before addition/subtraction, only after checking numerical error and cost for the actual expression. The source example has an inconsistent exact-result sentence, so it supplies no universal accuracy guarantee. Because The book's example shows different rounding after algebraic regrouping.

  Sources: `BP48`.
