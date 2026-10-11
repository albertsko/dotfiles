# Functions, methods and interfaces

Load when: receivers, named results, typed nil, stream APIs or deferred argument/receiver evaluation

<a id="g84"></a>

- **G84** When a method changes receiver state or contains noncopyable synchronization state. Then Use a pointer receiver. Appending to a slice receiver requires updating its header. Indirect fields can mutate even through a value receiver. Because Value receivers copy the receiver and can lose mutations or duplicate synchronization objects.

  Sources: `BP84`.

<a id="g85"></a>

- **G85** When choosing receivers for naturally small value types. Then Prefer value receivers for small natural value types, immutable structs/arrays, and slices whose header need not change. Copying a slice, map or pointer still shares referents. Choose receiver semantics deliberately. The source's claim that named map/function/channel types cannot have pointer receivers is not adopted. Because Value receivers express direct value semantics without unnecessary pointers.

  Sources: `BP85`.

<a id="g86"></a>

- **G86** When choosing receiver kinds and consistency across a type. Then Keep receiver kinds consistent unless interface requirements or actual semantics justify mixing, as with time.Time unmarshaling. Consider mutation, noncopyable state, size and indirect sharing. Pointer receivers can signal indirect mutation. Resolve uncertainty from these conditions rather than the book's conflicting value-default and pointer-when-unsure heuristics. Because Consistency makes mutation expectations clearer.

  Sources: `BP86`.

<a id="g87"></a>

- **G87** When several return values have unclear meanings, especially identical types. Then Name result parameters to document their meanings, or return a struct with meaningful fields. Naming an obvious error alone may add no value. Existing interfaces may preclude changing results to a struct. Because A signature can distinguish latitude from longitude without reading implementation.

  Sources: `BP87`.

<a id="g88"></a>

- **G88** When using named results in an implementation. Then Use them sparingly for clear readability or convenience benefits and keep naked returns confined to short functions. Be consistent about explicit versus naked returns within a function. Named results do not require naked returns. Named result zero initialization can occasionally simplify a short implementation. Naming an obvious error alone need not improve the signature. Because Long functions force readers to track hidden result state.

  Sources: `BP88`.

<a id="g89"></a>

- **G89** When returning a named result after a failing call or condition. Then Assign or return the actual error instead of an untouched named error variable. An explicit local assignment can prevent the mistake. Because Named results start at zero and can silently return nil despite failure.

  Sources: `BP89`.

<a id="g90"></a>

- **G90** When returning an interface, particularly error, from a pointer value. Then Return literal nil explicitly when the underlying pointer is nil. Applies to all pointer-implemented interfaces. Nil receiver methods are allowed but must avoid unsafe dereferences. Because A typed nil pointer inside an interface makes the interface non-nil.

  Sources: `BP90`.

  Example: [Typed-nil interface boundary](../../examples/ownership_test.go).

<a id="g91"></a>

- **G91** When a function processes stream content. Then Accept io.Reader instead of a filename or concrete file type. Filesystem-opening functions such as os.Open appropriately accept filenames. Move resource opening and closure ownership to the caller or resource boundary. Because The algorithm works with files, network bodies, and in-memory test inputs.

  Sources: `BP91`.

<a id="g92"></a>

- **G92** When deferred work must see a variable's final value. Then Use a closure reading the variable at execution, or deliberately pass a pointer. Passing a closure argument still evaluates that argument immediately. Pointer-based changes may require API changes. Because Ordinary defer arguments are evaluated immediately.

  Sources: `BP92`.

<a id="g93"></a>

- **G93** When deferring a method call before modifying its receiver. Then Account for immediate receiver evaluation and value versus pointer copying. Reassigning a pointer variable does not retarget the already captured pointer. Because A value receiver sees the captured copy, while a captured pointer sees later changes to its referent.

  Sources: `BP93`.

<a id="g239"></a>

- **G239** When a receiver is large. Then Consider a pointer receiver and benchmark the copy-versus-pointer tradeoff. No universal size cutoff is given, semantics take priority over speculative optimization. There is no universal size cutoff. The source prefers pointers when otherwise undecided, but receiver semantics and measurement govern the choice. Because Large copies can be costly.

  Sources: `BP239`.
