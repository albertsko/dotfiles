# Go 1.22 source reference

Status: published-stable-release. Source: [official release notes](https://go.dev/doc/go1.22).

These are versioned source summaries. The linked rules cover recurring actions. A reference disposition preserves an API or implementation detail for tasks that need it. Read later releases before applying historical defaults.

<a id="rv239"></a>

## RV239: Changes to the language

With Go 1.22 language semantics, variables declared by for loops are fresh each iteration, including three-clause loops. Variables assigned rather than declared remain shared. Integer range is supported. Function range is only an experiment enabled with GOEXPERIMENT=rangefunc here. Module/file language gates distinguish new semantics from merely using a newer compiler.

Applicability: Fresh loop variables and integer range use Go 1.22 effective module/file language semantics. Function range remains a build-time rangefunc experiment in this release, with a separate opt-in gate.

Disposition: [G70](../rules/iteration-and-control-flow.md#g70), [G125](../rules/concurrency-and-lifecycles.md#g125), [G144](../rules/shared-state-and-synchronization.md#g144), [G179](../rules/testing.md#g179), [G241](../rules/versions-and-tooling.md#g241), [G250](../rules/iteration-and-control-flow.md#g250). The linked rules apply this source to Changes to the language. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.22#language).

<a id="rv240"></a>

## RV240: Tools / Go command

go work vendor creates a workspace vendor tree used by default when present. A root shared with a module cannot simultaneously hold distinct workspace/module vendor contents. GOPATH go get is removed while legacy build/test remain. mod init stops importing other vendoring-tool configs. Coverage reports 0% for executable packages without tests, but still no-test-files for packages with no executable code. External linking requires cgo enabled.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: [G245](../rules/versions-and-tooling.md#g245). The linked rules apply this source to Tools / Go command. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.22#go-command).

<a id="rv241"></a>

## RV241: Tools / Trace

The trace UI gains readable pages, thread views and full syscall durations for traces recorded by 1.22+. Improvements for older traces are only planned.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Tools / Trace on Go 1.22. This source records The trace UI gains readable pages, thread views and full syscall durations for traces recorded by 1.22+. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.22#trace).

<a id="rv242"></a>

## RV242: Tools / Vet / References to loop variables

vet stops obsolete loop-capture warnings for files requiring Go 1.22+ through module or file constraints. Older-language files still need capture checks.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: [G70](../rules/iteration-and-control-flow.md#g70), [G125](../rules/concurrency-and-lifecycles.md#g125), [G179](../rules/testing.md#g179). The linked rules apply this source to Tools / Vet / References to loop variables. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.22#vet-loopclosure).

<a id="rv243"></a>

## RV243: Tools / Vet / New warnings for missing values after append

vet flags append calls that append no values, usually accidental no-ops.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Tools / Vet / New warnings for missing values after append on Go 1.22. This source records vet flags append calls that append no values, usually accidental no-ops. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.22#vet-appends).

<a id="rv244"></a>

## RV244: Tools / Vet / New warnings for deferring time.Since

vet flags time.Since evaluated while registering defer. Use a deferred closure when elapsed time must be measured at return.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Tools / Vet / New warnings for deferring time.Since on Go 1.22. This source records vet flags time.Since evaluated while registering defer. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.22#vet-defers).

<a id="rv245"></a>

## RV245: Tools / Vet / New warnings for mismatched key-value pairs in log/slog calls

vet checks slog key/value arguments for non-string/non-Attr keys and missing values.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: [G272](../rules/code-and-api-design.md#g272). The linked rules apply this source to Tools / Vet / New warnings for mismatched key-value pairs in log/slog calls. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.22#vet-slog).

<a id="rv246"></a>

## RV246: Runtime

Heap-adjacent GC metadata improves measured CPU and memory costs but changes size classes and can reduce object alignment to eight bytes. Assembly must not assume stronger alignment. noallocheaders temporarily restores the old layout. Windows amd64 c-archive/c-shared hosts can catch otherwise unhandled exceptions with SetUnhandledExceptionFilter.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: [G271](../rules/performance-and-diagnostics.md#g271). The linked rules apply this source to Runtime. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.22#runtime).

<a id="rv247"></a>

## RV247: Compiler

PGO devirtualizes more calls, with measured gains of 2-14% on representative programs. Devirtualization interleaves with inlining. GOEXPERIMENT=newinliner previews call-site heuristics favoring important paths, not a stable default.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Compiler on Go 1.22. This source records PGO devirtualizes more calls, with measured gains of 2-14% on representative programs. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.22#compiler).

<a id="rv248"></a>

## RV248: Linker

Linker -s suppresses symbols and implies -w (no DWARF), overridden by -w=0. ELF -B gobuildid derives a GNU build ID. Windows internal linking retains C SEH sections, improving tooling and potentially enabling previously ignored exception handlers.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Linker on Go 1.22. This source records Linker -s suppresses symbols and implies -w (no DWARF), overridden by -w=0. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.22#linker).

<a id="rv249"></a>

## RV249: Bootstrap

Source bootstrap requires the final Go 1.20 point release or newer. A final-1.22 requirement for 1.24 is an announced plan here.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Bootstrap on Go 1.22. This source records Source bootstrap requires the final Go 1.20 point release or newer. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.22#bootstrap).

<a id="rv250"></a>

## RV250: Standard library / New math/rand/v2 package

math/rand/v2 has no legacy Read, unconditionally random global seeding, a Uint64-only Source, faster algorithms, IntN/Int32/Int32N/Int64/Int64N spellings, unsigned variants and generic N for integer-like types. ChaCha8 and PCG replace the old default source design. ChaCha8 also backs unseeded v1 globals and runtime randomness in 1.22. Reproducibility needs explicit local state; cryptographic uses should still choose crypto/rand. A migration tool is planned, not shipped here.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G254](../rules/security-and-compatibility.md#g254), [G273](../rules/security-and-compatibility.md#g273). The linked rules apply this source to Standard library / New math/rand/v2 package. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.22#math_rand_v2).

<a id="rv251"></a>

## RV251: Standard library / New go/version package

go/version validates and compares Go version strings.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / New go/version package on Go 1.22. This source records go/version validates and compares Go version strings. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.22#go-version).

<a id="rv252"></a>

## RV252: Standard library / Enhanced routing patterns

ServeMux patterns support methods, segment wildcards, final remainder wildcards and {$} exact trailing-slash matches. GET includes HEAD. More-specific patterns win, while incomparable overlaps conflict independent of registration order. PathValue reads captures. Braces and escaped paths change meaning; httpmuxgo121=1 restores old routing.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G262](../rules/resource-and-http-lifecycles.md#g262). The linked rules apply this source to Standard library / Enhanced routing patterns. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.22#enhanced_routing_patterns).

<a id="rv253"></a>

## RV253: Standard library / Minor changes to the library / archive/tar

tar.Writer.AddFS archives files from an fs.FS.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / archive/tar on Go 1.22. This source records tar.Writer.AddFS archives files from an fs.FS. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.22#minor_library_changes).

<a id="rv254"></a>

## RV254: Standard library / Minor changes to the library / archive/zip

zip.Writer.AddFS archives files from an fs.FS.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / archive/zip on Go 1.22. This source records zip.Writer.AddFS archives files from an fs.FS. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.22#minor_library_changes).

<a id="rv255"></a>

## RV255: Standard library / Minor changes to the library / bufio

Scanner stops immediately for ErrFinalToken with nil token. Return an empty non-nil slice to emit a final empty token.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / bufio on Go 1.22. This source records Scanner stops immediately for ErrFinalToken with nil token. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.22#minor_library_changes).

<a id="rv256"></a>

## RV256: Standard library / Minor changes to the library / cmp

cmp.Or returns the first nonzero value.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / cmp on Go 1.22. This source records cmp.Or returns the first nonzero value. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.22#minor_library_changes).

<a id="rv257"></a>

## RV257: Standard library / Minor changes to the library / crypto/tls

TLS ExportKeyingMaterial requires TLS 1.3 or Extended Master Secret, with temporary tlsunsafeekm=1 bypass. Servers default to TLS 1.2 (tls10server=1 restores the prior default). Pre-TLS 1.3 defaults drop non-ECDHE suites (tlsrsakex=1 restores them). Explicit protocol configuration and removed-default controls are distinct. The note's EMS introduction-version claim conflicts with 1.21's announcement and is tracked as a source inconsistency.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G275](../rules/security-and-compatibility.md#g275). The linked rules apply this source to Standard library / Minor changes to the library / crypto/tls. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.22#minor_library_changes).

<a id="rv258"></a>

## RV258: Standard library / Minor changes to the library / crypto/x509

CertPool.AddCertWithConstraint adds root-specific chain constraints. Android loads added keychain roots. x509.OID/Certificate.Policies support components beyond 31 bits while PolicyIdentifiers omits unrepresentable OIDs. Creation still uses PolicyIdentifiers by default; x509usepolicies=1 switches to Policies. A possible later default is only announced.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/x509 on Go 1.22. This source records CertPool.AddCertWithConstraint adds root-specific chain constraints. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.22#minor_library_changes).

<a id="rv259"></a>

## RV259: Standard library / Minor changes to the library / database/sql

sql.Null[T] represents nullable scanned values generically.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G158](../rules/database-access.md#g158). The linked rules apply this source to Standard library / Minor changes to the library / database/sql. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.22#minor_library_changes).

<a id="rv260"></a>

## RV260: Standard library / Minor changes to the library / debug/elf

ELF adds R_MIPS_PC32 and more R_LARCH_* relocations.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / debug/elf on Go 1.22. This source records ELF adds R_MIPS_PC32 and more R_LARCH_* relocations. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.22#minor_library_changes).

<a id="rv261"></a>

## RV261: Standard library / Minor changes to the library / encoding

base32/base64/hex gain append-oriented encoding/decoding with buffer management. base32/base64 WithPadding panic for negative values other than NoPadding.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / encoding on Go 1.22. This source records base32/base64/hex gain append-oriented encoding/decoding with buffer management. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.22#minor_library_changes).

<a id="rv262"></a>

## RV262: Standard library / Minor changes to the library / encoding/json

JSON encodes backspace/formfeed with short escapes instead of equivalent Unicode escapes. Text snapshots may change while values remain equivalent.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G276](../rules/security-and-compatibility.md#g276). The linked rules apply this source to Standard library / Minor changes to the library / encoding/json. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.22#minor_library_changes).

<a id="rv263"></a>

## RV263: Standard library / Minor changes to the library / go/ast

AST syntactic identifier resolution APIs (Ident.Obj, Object, Scope, File.Scope/Unresolved, Importer, Package, NewPackage) are deprecated because reliable resolution needs go/types. ast.Unparen strips enclosing parentheses.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G277](../rules/versions-and-tooling.md#g277). The linked rules apply this source to Standard library / Minor changes to the library / go/ast. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.22#minor_library_changes).

<a id="rv264"></a>

## RV264: Standard library / Minor changes to the library / go/types

types.Alias preserves alias identity, with Unalias for the underlying denotation. gotypesalias=1 opts in; default remains 0 here, so tools must prepare their switches. Info.FileVersions and PkgNameOf expose file versions/import names. SizesFor("gc",...) matches compiler sizes; default checking uses gc/amd64. Function scopes now start at func rather than the body brace.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G277](../rules/versions-and-tooling.md#g277). The linked rules apply this source to Standard library / Minor changes to the library / go/types. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.22#minor_library_changes).

<a id="rv265"></a>

## RV265: Standard library / Minor changes to the library / html/template

html/template safely supports actions in JavaScript template literals. ErrJSTemplate is no longer returned for this case and jstmpllitinterp has no effect.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / html/template on Go 1.22. This source records html/template safely supports actions in JavaScript template literals. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.22#minor_library_changes).

<a id="rv266"></a>

## RV266: Standard library / Minor changes to the library / io

SectionReader.Outer returns its underlying ReaderAt, base offset and extent.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / io on Go 1.22. This source records SectionReader.Outer returns its underlying ReaderAt, base offset and extent. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.22#minor_library_changes).

<a id="rv267"></a>

## RV267: Standard library / Minor changes to the library / log/slog

slog.SetLogLoggerLevel controls levels in the log/slog bridge, including top-level slog minimums before redirection and log.Logger records routed through slog.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / log/slog on Go 1.22. This source records slog.SetLogLoggerLevel controls levels in the log/slog bridge, including top-level slog minimums before redirection and log.Logger records routed through slog. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.22#minor_library_changes).

<a id="rv268"></a>

## RV268: Standard library / Minor changes to the library / math/big

big.Rat.FloatPrec reports finite decimal representability and required fractional digits.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / math/big on Go 1.22. This source records big.Rat.FloatPrec reports finite decimal representability and required fractional digits. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.22#minor_library_changes).

<a id="rv269"></a>

## RV269: Standard library / Minor changes to the library / net

TCPConn.WriteTo lets io.Copy use Linux splice to Unix sockets. Windows's Go DNS resolver consults the hosts file before querying DNS.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / net on Go 1.22. This source records TCPConn.WriteTo lets io.Copy use Linux splice to Unix sockets. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.22#minor_library_changes).

<a id="rv270"></a>

## RV270: Standard library / Minor changes to the library / net/http

ServeFileFS/FileServerFS/NewFileTransportFS serve fs.FS content. HTTP rejects empty Content-Length unless httplaxcontentlength=1. Request.PathValue/SetPathValue expose routing captures.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G262](../rules/resource-and-http-lifecycles.md#g262). The linked rules apply this source to Standard library / Minor changes to the library / net/http. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.22#minor_library_changes).

<a id="rv271"></a>

## RV271: Standard library / Minor changes to the library / net/http/cgi

CGI PATH_INFO is always empty or slash-prefixed, correcting invalid combinations of handler root and URL.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / net/http/cgi on Go 1.22. This source records CGI PATH_INFO is always empty or slash-prefixed, correcting invalid combinations of handler root and URL. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.22#minor_library_changes).

<a id="rv272"></a>

## RV272: Standard library / Minor changes to the library / net/netip

netip.AddrPort.Compare orders endpoints.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / net/netip on Go 1.22. This source records netip.AddrPort.Compare orders endpoints. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.22#minor_library_changes).

<a id="rv273"></a>

## RV273: Standard library / Minor changes to the library / os

Windows Stat follows all named-target reparse points, O_SYNC requests direct-to-disk writes, and directory reads batch syscalls. File.WriteTo enables Linux sendfile to Unix sockets through io.Copy.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / os on Go 1.22. This source records Windows Stat follows all named-target reparse points, O_SYNC requests direct-to-disk writes, and directory reads batch syscalls. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.22#minor_library_changes).

<a id="rv274"></a>

## RV274: Standard library / Minor changes to the library / os/exec

Windows LookPath ignores empty PATH components and returns ErrNotFound when no executable extension resolves. Command/Start skip lookup for absolute paths with executable extensions. Start no longer mutates Path's extension, allowing concurrent String.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G265](../rules/resource-and-http-lifecycles.md#g265). The linked rules apply this source to Standard library / Minor changes to the library / os/exec. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.22#minor_library_changes).

<a id="rv275"></a>

## RV275: Standard library / Minor changes to the library / reflect

reflect.IsZero matches language equality for negative zero and blank struct fields. PtrTo is deprecated for PointerTo. TypeFor[T] directly retrieves T's reflect.Type.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / reflect on Go 1.22. This source records reflect.IsZero matches language equality for negative zero and blank struct fields. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.22#minor_library_changes).

<a id="rv276"></a>

## RV276: Standard library / Minor changes to the library / runtime/metrics

Scheduler pause histograms distinguish stopping vs total duration and GC vs other reasons. /gc/pauses is deprecated for total/gc. Total mutex wait now includes runtime-internal locks, changing metric interpretation.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / runtime/metrics on Go 1.22. This source records Scheduler pause histograms distinguish stopping vs total duration and GC vs other reasons. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.22#minor_library_changes).

<a id="rv277"></a>

## RV277: Standard library / Minor changes to the library / runtime/pprof

Mutex profiles count aggregate goroutine delay, not just elapsed contention (100 waiters for 10 ms yield 1s). Runtime-lock contention is included at _LostContendedRuntimeLock. Darwin CPU profiles include mappings for disassembly.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: [G219](../rules/performance-and-diagnostics.md#g219). The linked rules apply this source to Standard library / Minor changes to the library / runtime/pprof. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.22#minor_library_changes).

<a id="rv278"></a>

## RV278: Standard library / Minor changes to the library / runtime/trace

The new tracer uses OS clocks on most non-Windows platforms, remains correct despite clock issues, partitions data for streaming, records full syscalls and thread identity, reduces start/stop latency and works across GC mark phases. x/exp/trace is experimental and initially reads 1.22 traces only. noexectracer2 temporarily restores the old tracer.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / runtime/trace on Go 1.22. This source records The new tracer uses OS clocks on most non-Windows platforms, remains correct despite clock issues, partitions data for streaming, records full syscalls and thread identity, reduces start/stop latency and works across GC mark phases. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.22#minor_library_changes).

<a id="rv279"></a>

## RV279: Standard library / Minor changes to the library / slices

slices.Concat joins slices. Delete/DeleteFunc/Compact/CompactFunc/Replace zero the obsolete tail after shrinking, reducing retained references and affecting aliases. Insert validates its index even for an empty insertion.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G59](../rules/collections-and-ownership.md#g59), [G249](../rules/collections-and-ownership.md#g249). The linked rules apply this source to Standard library / Minor changes to the library / slices. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.22#minor_library_changes).

<a id="rv280"></a>

## RV280: Standard library / Minor changes to the library / syscall

syscall loses blanket package deprecation because required APIs still depend on it, but remains mostly frozen and x/sys is preferred for new functionality. Linux SysProcAttr.PidFD captures child PID descriptors. Windows Open honors O_SYNC.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / syscall on Go 1.22. This source records syscall loses blanket package deprecation because required APIs still depend on it, but remains mostly frozen and x/sys is preferred for new functionality. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.22#minor_library_changes).

<a id="rv281"></a>

## RV281: Standard library / Minor changes to the library / testing/slogtest

slogtest.Run uses subtests for finer handler-test control.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G272](../rules/code-and-api-design.md#g272). The linked rules apply this source to Standard library / Minor changes to the library / testing/slogtest. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.22#minor_library_changes).

<a id="rv282"></a>

## RV282: Ports / Darwin

darwin/amd64 defaults to PIE; -buildmode=exe opts out. Go 1.22 is the last macOS 10.15 release, with 1.23 requiring macOS 11+.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / Darwin on Go 1.22. This source records darwin/amd64 defaults to PIE; -buildmode=exe opts out. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.22#darwin).

<a id="rv283"></a>

## RV283: Ports / ARM

GOARM accepts ,softfloat or ,hardfloat suffixes. Defaults remain softfloat for 5 and hardfloat for 6/7.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / ARM on Go 1.22. This source records GOARM accepts ,softfloat or ,hardfloat suffixes. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.22#arm).

<a id="rv284"></a>

## RV284: Ports / Loong64

loong64 gains register argument/result passing. linux/loong64 adds ASan, MSan, modern relocations and plugin mode.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / Loong64 on Go 1.22. This source records loong64 gains register argument/result passing. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.22#loong64).

<a id="rv285"></a>

## RV285: Ports / OpenBSD

openbsd/ppc64 is an experimental big-endian PowerPC port.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / OpenBSD on Go 1.22. This source records openbsd/ppc64 is an experimental big-endian PowerPC port. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.22#openbsd).
