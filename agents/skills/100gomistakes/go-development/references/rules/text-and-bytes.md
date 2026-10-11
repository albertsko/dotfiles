# Text and bytes

Load when: Unicode/encoding, byte versus rune indexes, trimming, building strings or retained substrings

<a id="g75"></a>

- **G75** When processing text or binary data represented as a string. Then Distinguish bytes, Unicode code points, and encoding. Do not assume arbitrary input is UTF-8. The book's literal discussion is simplified. External encodings may need dedicated decoding. A Unicode code point is not necessarily a whole user-perceived character. Source-literal UTF-8 statements have escape-related limits. Because Strings hold arbitrary bytes and len counts bytes, while runes are code points.

  Sources: `BP75`.

<a id="g76"></a>

- **G76** When iterating UTF-8 runes. Then Use the range value as the rune and treat the index as a byte offset. Range avoids an unnecessary []rune allocation. Known single-byte text may be accessed directly as bytes without rune conversion. Because s[i] accesses a byte, not a complete multibyte rune.

  Sources: `BP76`.

<a id="g77"></a>

- **G77** When counting or indexing Unicode code points. Then Use utf8.RuneCountInString for rune counts and a rune slice for rune-indexed access. Rune slices allocate and decode. Direct byte access is valid for known single-byte text. For traversal rather than random rune indexing, direct range avoids a rune-slice allocation. Because Byte length and byte indexes do not describe variable-width code points.

  Sources: `BP77`.

<a id="g78"></a>

- **G78** When removing exact leading or trailing text. Then Use TrimPrefix or TrimSuffix for one exact affix, and TrimLeft/Right/Trim for a set of runes. TrimSuffix and TrimPrefix remove at most one matching affix. Because Cutset trimming repeatedly removes any member, not an exact substring.

  Sources: `BP78`.

<a id="g79"></a>

- **G79** When concatenating many strings, especially in a loop. Then Use strings.Builder for repeated concatenation, and Grow when the total byte count is known. For a few fixed strings, + or formatting may be clearer. Measure performance-sensitive cases rather than treating the book's five-string heuristic as a threshold. Because Repeated concatenation allocates and copies immutable strings.

  Sources: `BP79`.

<a id="g80"></a>

- **G80** When writing through a strings.Builder. Then Confine a strings.Builder to one goroutine or synchronize access. Use WriteString, Write, WriteByte or WriteRune for the actual input. WriteString's error is always nil, so deliberate omission is justified. Do not copy a non-zero Builder. Because Its internal append operations are not safe for concurrent mutation.

  Sources: `BP80`.

<a id="g81"></a>

- **G81** When a workflow starts and ends with byte slices. Then Use bytes package operations throughout instead of converting to strings and back. Check available operations before assuming strings are more convenient. Compiler optimizations may alter allocation details. Evaluate the whole workflow, including byte-oriented I/O at either boundary. Preserve string immutability when reasoning about conversion optimizations. Choose the byte/string representation for the complete workflow. This is not a universal ban on strings. Because Conversions can add allocation and copying.

  Sources: `BP81`.

<a id="g82"></a>

- **G82** When slicing a string by textual position. Then Use rune-aware handling for rune boundaries instead of arbitrary byte slicing. Byte slicing is appropriate for fixed ASCII fields such as UUIDs. Validate the length of a fixed-byte format before indexing it, as with a UUID field. Because String slice indexes count bytes and may split multibyte encodings.

  Sources: `BP82`.

<a id="g83"></a>

- **G83** When retaining a small substring of a large string. Then Use strings.Clone (Go 1.18+) when independent backing storage is needed. Passing by value copies the string header, not its bytes. Storage sharing is implementation-dependent. Preserve intentional copies and verify older string([]byte(fragment)) copy idioms against compiler optimization. Because Substring storage can retain the entire source allocation.

  Sources: `BP83`, `RV57`.
