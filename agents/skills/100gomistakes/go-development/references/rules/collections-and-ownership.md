# Collections and ownership

Load when: slice/map allocation, copying, aliasing, retention, comparison or pointer collections

<a id="g49"></a>

- **G49** When indexing or appending slices. Then Reason separately about length, capacity, and the shared backing array, and retain append's returned slice. Growth factors are runtime details, not a correctness contract. Only the slice returned by append gets the updated length. Copying or reassigning a header does not update other headers. Because Indexes are limited by length. Append may reuse storage or allocate and copy, changing alias relationships.

  Sources: `BP49`.

<a id="g50"></a>

- **G50** When the output slice size is known. Then Preallocate length and assign by index, or preallocate capacity and append. Index assignment can be faster. Capacity plus append can be clearer for complex index mappings. Because Avoids repeated allocation and copying during growth.

  Sources: `BP50`.

<a id="g51"></a>

- **G51** When filtering yields an uncertain output size. Then Choose preallocation based on expected retained proportion and CPU versus memory cost. Benchmark performance-sensitive choices. There is no strict rule. Because Full preallocation may waste memory, while repeated growth costs work.

  Sources: `BP51`.

<a id="g52"></a>

- **G52** When building an initially empty result of unknown final length. Then Prefer the zero-value nil slice and append as needed. Use make for known size, and literals for initial elements. Book allocation claims need implementation review. Nil slices also support len and range. A non-nil empty result may still be necessary to honor a boundary contract. Because Nil slices are usable without defensive non-nil initialization.

  Sources: `BP52`.

<a id="g53"></a>

- **G53** When passing slices to serializers, reflect, or libraries. Then Preserve the boundary contract for nil and non-nil empty values. encoding/json v1 emits null versus [] and reflect.DeepEqual distinguishes them. Go 1.27 JSON v2 is a separate API with different defaults, so test its chosen options rather than transferring v1 assumptions. Because JSON emits null versus [] and DeepEqual distinguishes them.

  Sources: `BP53`, `RV518`.

<a id="g54"></a>

- **G54** When checking whether slices or maps contain elements. Then Test len(collection), not collection != nil. Nil checks answer a different question. Because Both nil and non-nil empty collections have no elements.

  Sources: `BP54`.

<a id="g55"></a>

- **G55** When designing collection-returning APIs. Then Avoid giving nil and empty collections different meanings unless the contract requires it. Serialization contracts can require the difference. Because Callers otherwise face subtle unnecessary distinctions.

  Sources: `BP55`.

<a id="g56"></a>

- **G56** When copying a slice. Then Allocate enough destination length and call copy(destination, source). Appending source elements to a nil slice is an alternative. Prefer copy for readability. Element copying does not recursively clone referenced objects. Because copy transfers only min(len(dst), len(src)) elements, regardless of capacity.

  Sources: `BP56`.

<a id="g57"></a>

- **G57** When passing a subslice to code that may append. Then Limit capacity with a full slice expression or pass a copy. Capacity limiting still shares in-range elements. Copy when full independence is needed. A full slice expression also does not release the original backing allocation. Because Appending within spare capacity can overwrite elements outside the subslice's length.

  Sources: `BP57`.

  Example: [Slice aliasing and capacity](../../examples/ownership_test.go).

<a id="g58"></a>

- **G58** When keeping a small portion of a large slice long term. Then Copy retained elements to a new small slice. A full slice expression restricts append but does not release the old allocation. Because A subslice keeps the full backing allocation reachable.

  Sources: `BP58`.

<a id="g59"></a>

- **G59** When removing elements containing pointers from a retained backing array. Then Copy retained elements or clear unused pointer-bearing slots before reslicing. Choose by future capacity, number of elements touched, measured cost and alias ownership. clear requires Go 1.21. From Go 1.22, slices.Delete/DeleteFunc/Compact/CompactFunc/Replace zero their obsolete tail. Retain the returned slice and account for aliases observing that clearing. Because Unreachable-by-length elements still retain referenced objects through the live backing array.

  Sources: `BP59`, `RV179`, `RV279`.

<a id="g60"></a>

- **G60** When the expected map population is known. Then Provide the expected size to make. The size is a hint. Internal bucket details can change. A size hint is neither an initial length nor a maximum map size. Because Avoids repeated map growth and redistribution.

  Sources: `BP60`.

<a id="g61"></a>

- **G61** When a long-lived map remains large after a temporary spike. Then Consider rebuilding a smaller map and releasing the old one. Copying temporarily requires additional memory until collection. Fixed-size caches may not need this. The temporary peak can approach the storage for two maps until collection. Rebuild only when retention matters. Because Deleting entries does not necessarily release the map's backing storage.

  Sources: `BP61`.

<a id="g62"></a>

- **G62** When map values make retained storage expensive. Then Measure whether pointer values reduce retained storage enough to justify extra allocations and indirection. Deleting an entry can release its separate referent while map storage remains. The book's bucket counts and 128-byte indirection threshold are historical implementation details. Go 1.24 changed built-in maps to Swiss tables, so measure on the target runtime. Because Pointer-sized slots can be much smaller than large inline values.

  Sources: `BP62`, `RV338`.

<a id="g63"></a>

- **G63** When comparing values with == or !=. Then Verify comparability recursively and inspect dynamic interface values. Slices and maps support nil comparison but not ordinary equality. Pointers and channels compare identity. Go 1.20 comparable constraint satisfaction can admit interfaces whose dynamic values still panic on comparison. Struct/array comparison proceeds in order and short-circuits. Because Slices and maps cannot be compared this way, and interfaces holding noncomparable types can panic.

  Sources: `BP63`, `RV115`.

<a id="g64"></a>

- **G64** When comparing composite values. Then Choose comparison semantics deliberately and read DeepEqual's type-specific behavior. For tests, go-cmp or testify can help. Performance-sensitive paths may need a custom comparison. Choose explicit equality semantics for floating fields, including a domain-appropriate tolerance where needed. Because DeepEqual supports composites but distinguishes nil and empty and incurs reflection overhead.

  Sources: `BP64`.

<a id="g65"></a>

- **G65** When implementing a performance-sensitive comparator. Then Check standard library comparisons before writing a custom field-by-field comparator. The book names bytes.Compare. Ensure floating fields use domain-appropriate semantics. Test-oriented comparison libraries and production comparators have different cost requirements. Because Existing optimized operations avoid reinvention, while explicit comparisons avoid reflection costs.

  Sources: `BP65`.

<a id="g249"></a>

- **G249** When implementing collection comparisons, copies, searches or sorting. Then Check stable slices, maps and cmp on Go 1.21+ before writing equivalent loops. Keep equality semantics, nil behavior, shallow-copy ownership and alias effects explicit. Earlier x/exp packages are separately versioned and do not carry the standard-library compatibility promise. Because Standard helpers reduce duplication when their contracts match the needed behavior.

  Sources: `RV2`, `RV3`, `RV4`, `RV189`, `RV190`, `RV191`, `RV279`.
