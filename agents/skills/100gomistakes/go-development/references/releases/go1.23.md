# Go 1.23 source reference

Status: published-stable-release. Source: [official release notes](https://go.dev/doc/go1.23).

These are versioned source summaries. The linked rules cover recurring actions. A reference disposition preserves an API or implementation detail for tasks that need it. Read later releases before applying historical defaults.

<a id="rv286"></a>

## RV286: Changes to the language

Function range becomes stable for func(func() bool), func(func(V) bool), and func(func(K,V) bool) iterators. Yield calls supply loop values and their boolean controls continuation. Generic aliases remain an intra-package preview requiring a toolchain built with GOEXPERIMENT=aliastypeparams; cross-package use is unsupported here.

Applicability: Function range requires Go 1.23 language support. Generic aliases remain a separate toolchain-build experiment with intra-package scope only in this release.

Disposition: [G248](../rules/code-and-api-design.md#g248), [G250](../rules/iteration-and-control-flow.md#g250). The linked rules apply this source to Changes to the language. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.23#language).

<a id="rv287"></a>

## RV287: Tools / Telemetry

Toolchain telemetry stores local counters by default. go telemetry on opts into weekly anonymous uploads published for analysis; local mode does not upload. Distinguish collection from upload consent.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Tools / Telemetry on Go 1.23. This source records Toolchain telemetry stores local counters by default. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.23#telemetry).

<a id="rv288"></a>

## RV288: Tools / Go command

GOROOT_FINAL has no effect. Distributions should symlink the go binary instead of copying it away from GOROOT/bin. env -changed shows nondefault settings. mod tidy -diff prints changes and fails when edits are needed without applying them. list -m -json adds Sum/GoModSum. go.mod/go.work godebug directives declare compatibility settings.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Tools / Go command on Go 1.23. This source records GOROOT_FINAL has no effect. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.23#go-command).

<a id="rv289"></a>

## RV289: Tools / Vet

vet's stdversion check rejects standard-library symbols newer than a file's effective module/build-constraint version, such as TypeFor in go1.21 files.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: [G241](../rules/versions-and-tooling.md#g241). The linked rules apply this source to Tools / Vet. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.23#vet).

<a id="rv290"></a>

## RV290: Tools / Cgo

cgo -ldflags carries C linker flags without oversized process argument lists; go uses it automatically.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Tools / Cgo on Go 1.23. This source records cgo -ldflags carries C linker flags without oversized process argument lists; go uses it automatically. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.23#cgo).

<a id="rv291"></a>

## RV291: Tools / Trace

Trace viewing recovers usable data from partially damaged traces, especially recordings interrupted by crashes.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Tools / Trace on Go 1.23. This source records Trace viewing recovers usable data from partially damaged traces, especially recordings interrupted by crashes. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.23#trace).

<a id="rv292"></a>

## RV292: Runtime

Fatal error messages indent continuation lines, distinguishing multiline panic text from goroutine stack frames.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: release-reference. Consult when using Runtime on Go 1.23. This source records Fatal error messages indent continuation lines, distinguishing multiline panic text from goroutine stack frames. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.23#runtime).

<a id="rv293"></a>

## RV293: Compiler

PGO build overhead drops from potentially doubling large builds to expected single-digit percentages. Disjoint-lifetime locals share stack slots. 386/amd64 PGO aligns hot loop blocks for measured 1-1.5% gains at small binary cost, disabled with -d=alignhot=0.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: [G269](../rules/performance-and-diagnostics.md#g269). The linked rules apply this source to Compiler. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.23#compiler).

<a id="rv294"></a>

## RV294: Linker

New linkname and assembly references to unmarked standard-library internals fail linking, with existing known usages grandfathered. -checklinkname=0 is a debugging escape, not API stability. ELF -bindnow requests immediate dynamic binding, including PIE.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Linker on Go 1.23. This source records New linkname and assembly references to unmarked standard-library internals fail linking, with existing known usages grandfathered. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.23#linker).

<a id="rv295"></a>

## RV295: Standard library / Timer changes

For main modules declaring go1.23.0+, unreachable timers/tickers can be collected without Stop and timer channels become synchronous. Reset/Stop prevent later receipt of pre-call stale values. len/cap no longer indicate queued events; use nonblocking receive. Older main modules retain old behavior and asynctimerchan=1 restores it here. Stop remains useful to stop work, not necessary solely for collection under these semantics.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G147](../rules/time-and-serialization.md#g147), [G148](../rules/time-and-serialization.md#g148). The linked rules apply this source to Standard library / Timer changes. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.23#timer-changes).

<a id="rv296"></a>

## RV296: Standard library / New unique package

unique.Make canonicalizes comparable values into Handle[T]. Equal handles mean equal values and compare cheaply, allowing deduplication. Runtime comparability constraints still matter for interface-containing values.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / New unique package on Go 1.23. This source records unique.Make canonicalizes comparable values into Handle[T]. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.23#new-unique-package).

<a id="rv297"></a>

## RV297: Standard library / Iterators

iter defines iterator conventions. slices adds All/Values/Backward, Collect/AppendSeq, Sorted/SortedFunc/SortedStableFunc and Chunk. maps adds All/Keys/Values, Insert and Collect. These connect generic collections to function-range iteration without intermediate containers where possible.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G250](../rules/iteration-and-control-flow.md#g250). The linked rules apply this source to Standard library / Iterators. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.23#iterators).

<a id="rv298"></a>

## RV298: Standard library / New structs package

structs.HostLayout marks structs crossing host API boundaries to require host-compatible layout. Current ordinary layouts happen to match, but the language does not guarantee that for unmarked types.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / New structs package on Go 1.23. This source records structs.HostLayout marks structs crossing host API boundaries to require host-compatible layout. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.23#new-structs-package).

<a id="rv299"></a>

## RV299: Standard library / Minor changes to the library / archive/tar

tar.FileInfoNames lets FileInfoHeader obtain custom Uname/Gname instead of platform account lookup.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / archive/tar on Go 1.23. This source records tar.FileInfoNames lets FileInfoHeader obtain custom Uname/Gname instead of platform account lookup. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.23#archivetarpkgarchivetar).

<a id="rv300"></a>

## RV300: Standard library / Minor changes to the library / crypto/tls

TLS clients support draft ECH via EncryptedClientHelloConfigList. QUICConn adds resumption events and application ticket/cache data. Defaults drop 3DES (tls3des=1 restores) and add experimental X25519Kyber768Draft00 (tlskyber=0 disables, useful for broken large-record peers). X509KeyPair/LoadX509KeyPair populate Leaf, controlled by x509keypairleaf.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G275](../rules/security-and-compatibility.md#g275). The linked rules apply this source to Standard library / Minor changes to the library / crypto/tls. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.23#cryptotlspkgcryptotls).

<a id="rv301"></a>

## RV301: Standard library / Minor changes to the library / crypto/x509

Certificate requests support RSA-PSS. Request/CRL creation verifies signer output and fails invalid signatures. x509sha1 removal is announced for 1.24, not completed here. ParseOID and binary/text OID serialization support large identifiers.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/x509 on Go 1.23. This source records Certificate requests support RSA-PSS. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.23#cryptox509pkgcryptox509).

<a id="rv302"></a>

## RV302: Standard library / Minor changes to the library / database/sql

database/sql wraps driver.Valuer errors, preserving errors.Is/As access through Query/Exec/QueryRow failures.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / database/sql on Go 1.23. This source records database/sql wraps driver.Valuer errors, preserving errors.Is/As access through Query/Exec/QueryRow failures. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.23#databasesqlpkgdatabasesql).

<a id="rv303"></a>

## RV303: Standard library / Minor changes to the library / debug/elf

ELF adds PT_OPENBSD_NOBTCFI and STT_RELC/STT_SRELC/STT_GNU_IFUNC constants.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / debug/elf on Go 1.23. This source records ELF adds PT_OPENBSD_NOBTCFI and STT_RELC/STT_SRELC/STT_GNU_IFUNC constants. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.23#debugelfpkgdebugelf).

<a id="rv304"></a>

## RV304: Standard library / Minor changes to the library / encoding/binary

binary.Encode/Decode operate directly on byte slices, and Append serializes successive values into a slice.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / encoding/binary on Go 1.23. This source records binary.Encode/Decode operate directly on byte slices, and Append serializes successive values into a slice. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.23#encodingbinarypkgencodingbinary).

<a id="rv305"></a>

## RV305: Standard library / Minor changes to the library / go/ast

ast.Preorder iterates all syntax-tree nodes.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / go/ast on Go 1.23. This source records ast.Preorder iterates all syntax-tree nodes. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.23#goastpkggoast).

<a id="rv306"></a>

## RV306: Standard library / Minor changes to the library / go/types

types.Func.Signature avoids type assertions. Alias.Rhs/Origin/SetTypeParams/TypeParams/TypeArgs support alias tooling. Alias nodes become the default via gotypesalias=1, so existing type switches must adapt.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G277](../rules/versions-and-tooling.md#g277). The linked rules apply this source to Standard library / Minor changes to the library / go/types. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.23#gotypespkggotypes).

<a id="rv307"></a>

## RV307: Standard library / Minor changes to the library / math/rand/v2

rand/v2 adds Uint/Rand.Uint and ChaCha8.Read, the latter implementing io.Reader.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / math/rand/v2 on Go 1.23. This source records rand/v2 adds Uint/Rand.Uint and ChaCha8.Read, the latter implementing io.Reader. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.23#mathrandv2pkgmathrandv2).

<a id="rv308"></a>

## RV308: Standard library / Minor changes to the library / net

KeepAliveConfig fine-tunes TCP through TCPConn, Dialer and ListenConfig. DNSError wraps timeout/cancellation causes for errors.Is. netedns0=0 disables EDNS0 for incompatible DNS servers.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G266](../rules/resource-and-http-lifecycles.md#g266). The linked rules apply this source to Standard library / Minor changes to the library / net. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.23#netpkgnet).

<a id="rv309"></a>

## RV309: Standard library / Minor changes to the library / net/http

Cookie preserves quote state, adds Partitioned, and Request.CookiesNamed retrieves repeated names. ParseCookie parses all request cookies and ParseSetCookie validates a response cookie. ServeMux accepts multiple spaces/tabs after a method. ServeContent/ServeFile/ServeFileFS remove cache/encoding/ETag/modified headers on errors, with httpservecontentkeepheaders=1 restoring previous behavior. Encoding middleware must account for errors and Range semantics. Request.Pattern exposes the selected mux pattern except under httpmuxgo121=1.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G262](../rules/resource-and-http-lifecycles.md#g262). The linked rules apply this source to Standard library / Minor changes to the library / net/http. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.23#nethttppkgnethttp).

<a id="rv310"></a>

## RV310: Standard library / Minor changes to the library / net/http/httptest

httptest.NewRequestWithContext creates incoming test requests with a supplied context.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / net/http/httptest on Go 1.23. This source records httptest.NewRequestWithContext creates incoming test requests with a supplied context. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.23#nethttphttptestpkgnethttphttptest).

<a id="rv311"></a>

## RV311: Standard library / Minor changes to the library / net/netip

reflect.DeepEqual correctly distinguishes IPv4 netip.Addr from its IPv4-mapped IPv6 representation, matching == and Compare.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / net/netip on Go 1.23. This source records reflect.DeepEqual correctly distinguishes IPv4 netip.Addr from its IPv4-mapped IPv6 representation, matching == and Compare. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.23#netnetippkgnetnetip).

<a id="rv312"></a>

## RV312: Standard library / Minor changes to the library / os

Windows Stat identifies Unix sockets; winsymlink changes mount-point/irregular mode reporting and winreadlinkvolume stops forced drive-letter normalization. Both default to new behavior for go1.23. os.CopyFS copies an fs.FS to disk. Linux process operations use pidfds where supported (generally 5.4+), avoiding PID reuse races while consuming additional descriptors.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / os on Go 1.23. This source records Windows Stat identifies Unix sockets; winsymlink changes mount-point/irregular mode reporting and winreadlinkvolume stops forced drive-letter normalization. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.23#ospkgos).

<a id="rv313"></a>

## RV313: Standard library / Minor changes to the library / path/filepath

filepath.Localize converts valid slash paths to safe OS-local paths. Windows EvalSymlinks stops expanding mount points under winsymlink and stops normalizing volumes under winreadlinkvolume, with go1.23 defaults enabled.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G264](../rules/resource-and-http-lifecycles.md#g264). The linked rules apply this source to Standard library / Minor changes to the library / path/filepath. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.23#pathfilepathpkgpathfilepath).

<a id="rv314"></a>

## RV314: Standard library / Minor changes to the library / reflect

reflect.Type gains OverflowComplex/Float/Int/Uint. SliceAt creates a slice view at an address. Value.Pointer/UnsafePointer accept strings. Value.Seq/Seq2 iterate rangeable values and Type.CanSeq/CanSeq2 test support without panic.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / reflect on Go 1.23. This source records reflect.Type gains OverflowComplex/Float/Int/Uint. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.23#reflectpkgreflect).

<a id="rv315"></a>

## RV315: Standard library / Minor changes to the library / runtime/debug

debug.SetCrashOutput directs fatal reports to an additional file, enabling whole-process crash collection beyond recoverable goroutines.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / runtime/debug on Go 1.23. This source records debug.SetCrashOutput directs fatal reports to an additional file, enabling whole-process crash collection beyond recoverable goroutines. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.23#runtimedebugpkgruntimedebug).

<a id="rv316"></a>

## RV316: Standard library / Minor changes to the library / runtime/pprof

Allocation, mutex, block, threadcreate and goroutine profiles retain up to 128 frames instead of 32.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / runtime/pprof on Go 1.23. This source records Allocation, mutex, block, threadcreate and goroutine profiles retain up to 128 frames instead of 32. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.23#runtimepprofpkgruntimepprof).

<a id="rv317"></a>

## RV317: Standard library / Minor changes to the library / runtime/trace

Uncaught panics explicitly flush trace data, improving crash recordings.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / runtime/trace on Go 1.23. This source records Uncaught panics explicitly flush trace data, improving crash recordings. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.23#runtimetracepkgruntimetrace).

<a id="rv318"></a>

## RV318: Standard library / Minor changes to the library / slices

slices.Repeat constructs repeated slice contents.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / slices on Go 1.23. This source records slices.Repeat constructs repeated slice contents. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.23#slicespkgslices).

<a id="rv319"></a>

## RV319: Standard library / Minor changes to the library / sync

sync.Map.Clear deletes all entries.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / sync on Go 1.23. This source records sync.Map.Clear deletes all entries. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.23#syncpkgsync).

<a id="rv320"></a>

## RV320: Standard library / Minor changes to the library / sync/atomic

atomic And/Or apply bitwise updates and return the previous value.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G251](../rules/shared-state-and-synchronization.md#g251). The linked rules apply this source to Standard library / Minor changes to the library / sync/atomic. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.23#syncatomicpkgsyncatomic).

<a id="rv321"></a>

## RV321: Standard library / Minor changes to the library / syscall

Windows syscall gains WSAENOPROTOOPT and GetsockoptInt.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / syscall on Go 1.23. This source records Windows syscall gains WSAENOPROTOOPT and GetsockoptInt. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.23#syscallpkgsyscall).

<a id="rv322"></a>

## RV322: Standard library / Minor changes to the library / testing/fstest

fstest.TestFS returns a multi-unwrappable structured error for Is/As inspection.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / testing/fstest on Go 1.23. This source records fstest.TestFS returns a multi-unwrappable structured error for Is/As inspection. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.23#testingfstestpkgtestingfstest).

<a id="rv323"></a>

## RV323: Standard library / Minor changes to the library / text/template

text/template supports else with chains.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / text/template on Go 1.23. This source records text/template supports else with chains. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.23#texttemplatepkgtexttemplate).

<a id="rv324"></a>

## RV324: Standard library / Minor changes to the library / time

Time parsing rejects out-of-range zone offsets. Windows timer/ticker/sleep resolution improves from 15.6 ms to 0.5 ms.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / time on Go 1.23. This source records Time parsing rejects out-of-range zone offsets. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.23#timepkgtime).

<a id="rv325"></a>

## RV325: Standard library / Minor changes to the library / unicode/utf16

utf16.RuneLen counts encoding words or returns -1 for invalid runes.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / unicode/utf16 on Go 1.23. This source records utf16.RuneLen counts encoding words or returns -1 for invalid runes. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.23#unicodeutf16pkgunicodeutf16).

<a id="rv326"></a>

## RV326: Ports / Darwin

macOS 11+ is required.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / Darwin on Go 1.23. This source records macOS 11+ is required. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.23#darwin).

<a id="rv327"></a>

## RV327: Ports / Linux

Go 1.23 is the last release with Linux 2.6.32 minimum. Go 1.24 requires Linux 3.2+.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / Linux on Go 1.23. This source records Go 1.23 is the last release with Linux 2.6.32 minimum. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.23#linux).

<a id="rv328"></a>

## RV328: Ports / OpenBSD

openbsd/riscv64 support is experimental.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / OpenBSD on Go 1.23. This source records openbsd/riscv64 support is experimental. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.23#openbsd).

<a id="rv329"></a>

## RV329: Ports / ARM64

GOARM64 selects v8.0-v8.9 or v9.0-v9.5 minimum architecture with optional lse/crypto extensions. Default is v8.0, so higher settings constrain deployment CPUs.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: [G246](../rules/versions-and-tooling.md#g246). The linked rules apply this source to Ports / ARM64. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.23#arm64).

<a id="rv330"></a>

## RV330: Ports / RISC-V

GORISCV64 selects rva20u64 or rva22u64 and defaults to rva20u64.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: [G246](../rules/versions-and-tooling.md#g246). The linked rules apply this source to Ports / RISC-V. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.23#riscv).

<a id="rv331"></a>

## RV331: Ports / Wasm

The WASI execution helper drops wasmtime versions older than 14.0.0.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / Wasm on Go 1.23. This source records The WASI execution helper drops wasmtime versions older than 14.0.0. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.23#wasm).
