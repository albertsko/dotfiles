# Go 1.21 source reference

Status: published-stable-release. Source: [official release notes](https://go.dev/doc/go1.21).

These are versioned source summaries. The linked rules cover recurring actions. A reference disposition preserves an API or implementation detail for tasks that need it. Read later releases before applying historical defaults.

<a id="rv178"></a>

## RV178: Introduction to Go 1.21

Initial toolchain releases now use 1.N.0, while 1.N names the language/release family. Version parsers must accept go1.21.0 rather than expecting go1.21.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Introduction to Go 1.21 on Go 1.21. This source records Initial toolchain releases now use 1.N.0, while 1.N names the language/release family. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#introduction).

<a id="rv179"></a>

## RV179: Changes to the language

min/max operate on a fixed list of arguments. clear deletes map entries or zeroes slice elements. Package initialization chooses the first import-path-sorted package whose imports are initialized, so implicit ordering dependencies can change. Inference now handles generic function arguments/assignments/returns, matching interface and constraint methods, mixed untyped constants, and stricter component-type identity. Per-iteration loop variables are only a preview here. panic(nil) produces *runtime.PanicNilError so direct deferred recover during panic cannot return nil. panicnil=1 restores old behavior and defaults on for main modules declaring go 1.20 or earlier.

Applicability: Separate the Go 1.21 built-ins and inference changes from clarified initialization ordering, the opt-in loop-variable preview, and panic(nil) runtime compatibility. The panicnil default follows the main module version: go 1.20 or earlier retains the old behavior. A single language-feature gate does not describe all these changes.

Disposition: [G5](../rules/code-and-api-design.md#g5), [G59](../rules/collections-and-ownership.md#g59), [G95](../rules/errors-and-cleanup.md#g95). The linked rules apply this source to Changes to the language. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.21#language).

<a id="rv180"></a>

## RV180: Tools

GODEBUG compatibility defaults follow the workspace go line or main module go line, allowing many older behaviors under newer toolchains. go directives become strict minimum versions, including patch/prerelease ordering. The go command can find/download another toolchain, and a toolchain directive suggests a minimum newer than the module's strict requirement. Selection remains subject to toolchain configuration.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: [G241](../rules/versions-and-tooling.md#g241). The linked rules apply this source to Tools. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.21#tools).

<a id="rv181"></a>

## RV181: Tools / Go command

-pgo=auto becomes default and works for multiple main packages, each using its own default.pgo. -C must be first. Tests gain -fullpath, multi-package -c output (duplicate package names fail), and directory -o destinations. External cgo linking adds runtime/cgo as a dependency for compatibility with extra C libraries.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: [G269](../rules/performance-and-diagnostics.md#g269). The linked rules apply this source to Tools / Go command. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.21#go-command).

<a id="rv182"></a>

## RV182: Tools / Cgo

Declaring Go methods on C types now correctly fails compilation.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Tools / Cgo on Go 1.21. This source records Declaring Go methods on C types now correctly fails compilation. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#cgo).

<a id="rv183"></a>

## RV183: Runtime

Deep tracebacks show the innermost and outermost 50 frames. Linux huge-page handling improves utilization but no longer masks problematic max_ptes_none settings, so tune OS settings where needed. GC tuning can reduce tail latency/memory at some throughput cost; GOGC/GOMEMLIMIT can adjust the tradeoff. Unix C-created threads retain Go-call setup between calls, greatly reducing repeated callback overhead.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: release-reference. Consult when using Runtime on Go 1.21. This source records Deep tracebacks show the innermost and outermost 50 frames. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#runtime-changes).

<a id="rv184"></a>

## RV184: Compiler

PGO is supported for general use, with typical measured 2-7% gains. It devirtualizes hot interface calls for further inlining. The compiler itself uses PGO, improving builds by up to 6%.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: [G269](../rules/performance-and-diagnostics.md#g269). The linked rules apply this source to Compiler. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.21#compiler).

<a id="rv185"></a>

## RV185: Assembler

amd64 frameless nosplit assembly must explicitly request NOFRAME. Frame pointers are maintained across transitions. Dynamic-linking R15 misuse detection improves.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Assembler on Go 1.21. This source records amd64 frameless nosplit assembly must explicitly request NOFRAME. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#assembler).

<a id="rv186"></a>

## RV186: Linker

windows/amd64 emits SEH unwind data for debuggers. The linker removes unreferenced global maps with sufficiently large, side-effect-free initializers.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Linker on Go 1.21. This source records windows/amd64 emits SEH unwind data for debuggers. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#linker).

<a id="rv187"></a>

## RV187: Standard library / New log/slog package

log/slog adds leveled structured logging with key/value attributes for machine processing.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G272](../rules/code-and-api-design.md#g272). The linked rules apply this source to Standard library / New log/slog package. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.21#slog).

<a id="rv188"></a>

## RV188: Standard library / New testing/slogtest package

testing/slogtest validates custom slog.Handler implementations.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G272](../rules/code-and-api-design.md#g272). The linked rules apply this source to Standard library / New testing/slogtest package. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.21#slogtest).

<a id="rv189"></a>

## RV189: Standard library / New slices package

Stable slices provides generic slice operations. It is distinct from the earlier experimental x/exp package.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G249](../rules/collections-and-ownership.md#g249). The linked rules apply this source to Standard library / New slices package. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.21#slices).

<a id="rv190"></a>

## RV190: Standard library / New maps package

Stable maps provides generic map operations.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G249](../rules/collections-and-ownership.md#g249). The linked rules apply this source to Standard library / New maps package. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.21#maps).

<a id="rv191"></a>

## RV191: Standard library / New cmp package

cmp supplies Ordered and Less/Compare for ordered values.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G249](../rules/collections-and-ownership.md#g249). The linked rules apply this source to Standard library / New cmp package. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.21#cmp).

<a id="rv192"></a>

## RV192: Standard library / Minor changes to the library / archive/tar

tar Header.FileInfo results implement String via fs.FormatFileInfo.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / archive/tar on Go 1.21. This source records tar Header.FileInfo results implement String via fs.FormatFileInfo. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#archivetarpkgarchivetar).

<a id="rv193"></a>

## RV193: Standard library / Minor changes to the library / archive/zip

zip FileHeader.FileInfo and Reader.Open directory entries gain standard FileInfo/DirEntry string formatting.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / archive/zip on Go 1.21. This source records zip FileHeader.FileInfo and Reader.Open directory entries gain standard FileInfo/DirEntry string formatting. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#archivezippkgarchivezip).

<a id="rv194"></a>

## RV194: Standard library / Minor changes to the library / bytes

bytes.Buffer.Available/AvailableBuffer support appending directly into spare buffer capacity before Write.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / bytes on Go 1.21. This source records bytes.Buffer.Available/AvailableBuffer support appending directly into spare buffer capacity before Write. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#bytespkgbytes).

<a id="rv195"></a>

## RV195: Standard library / Minor changes to the library / context

context.WithoutCancel detaches cancellation, WithDeadlineCause/WithTimeoutCause record expiry reasons, and AfterFunc schedules a callback after cancellation. Background/TODO may compare equal after conversion to a common type. Context equality was never a defined identity contract.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G122](../rules/concurrency-and-lifecycles.md#g122), [G252](../rules/concurrency-and-lifecycles.md#g252). The linked rules apply this source to Standard library / Minor changes to the library / context. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.21#contextpkgcontext).

<a id="rv196"></a>

## RV196: Standard library / Minor changes to the library / crypto/ecdsa

ECDSA public/private key equality checks run in constant time.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/ecdsa on Go 1.21. This source records ECDSA public/private key equality checks run in constant time. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#cryptoecdsapkgcryptoecdsa).

<a id="rv197"></a>

## RV197: Standard library / Minor changes to the library / crypto/elliptic

elliptic Curve methods and GenerateKey/Marshal/Unmarshal are deprecated. Use crypto/ecdh for key exchange and appropriate external modules for lower-level arithmetic.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G274](../rules/security-and-compatibility.md#g274). The linked rules apply this source to Standard library / Minor changes to the library / crypto/elliptic. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.21#cryptoellipticpkgcryptoelliptic).

<a id="rv198"></a>

## RV198: Standard library / Minor changes to the library / crypto/rand

crypto/rand uses getrandom on NetBSD 10+.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/rand on Go 1.21. This source records crypto/rand uses getrandom on NetBSD 10+. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#cryptorandpkgcryptorand).

<a id="rv199"></a>

## RV199: Standard library / Minor changes to the library / crypto/rsa

RSA private operations recover and exceed 1.19 performance on amd64/arm64. Precompute must run after deserializing a key because private cached fields are not preserved. Key equality becomes constant-time. GenerateMultiPrimeKey and CRTValues are deprecated; CRTValues remains populated but is unused for decryption.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/rsa on Go 1.21. This source records RSA private operations recover and exceed 1.19 performance on amd64/arm64. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#cryptorsapkgcryptorsa).

<a id="rv200"></a>

## RV200: Standard library / Minor changes to the library / crypto/sha256

amd64 SHA224/SHA256 use native instructions where available, giving measured 3-4x speedups.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/sha256 on Go 1.21. This source records amd64 SHA224/SHA256 use native instructions where available, giving measured 3-4x speedups. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#cryptosha256pkgcryptosha256).

<a id="rv201"></a>

## RV201: Standard library / Minor changes to the library / crypto/tls

Resumed TLS servers skip client-certificate re-verification and VerifyPeerCertificate except expiry checks. On session resumption, clients check expiry even with InsecureSkipVerify. SessionState/Bytes/ParseSessionState, WrapSession/UnwrapSession, EncryptTicket/DecryptTicket and client ResumptionState APIs expose ticket management. Servers rotate tickets on every resumption and remove key identifiers, reducing tracking but increasing trial-key cost. Extended Master Secret restores TLSUnique for supported resumed sessions. QUICConn supports QUIC handshakes and 0-RTT but is not a QUIC transport and does not add TLS 0-RTT. VersionName formats versions. For TLS 1.3 connections requiring client authentication through RequireAnyClientCert or RequireAndVerifyClientCert, a missing client certificate produces the certificate-required alert. An untrusted issuing CA produces the unknown-certificate-authority alert. Expired or not-yet-valid certificates produce the expired-certificate alert. Other client-authentication failures retain bad-certificate.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/tls on Go 1.21. This source records Resumed TLS servers skip client-certificate re-verification and VerifyPeerCertificate except expiry checks. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#cryptotlspkgcryptotls).

<a id="rv202"></a>

## RV202: Standard library / Minor changes to the library / crypto/x509

RevokedCertificateEntries/RevocationListEntry replace deprecated RevokedCertificates and include reason codes. Name constraints apply to non-leaf descendants, not the certificate declaring the constraint.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/x509 on Go 1.21. This source records RevokedCertificateEntries/RevocationListEntry replace deprecated RevokedCertificates and include reason codes. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#cryptox509pkgcryptox509).

<a id="rv203"></a>

## RV203: Standard library / Minor changes to the library / debug/elf

elf.File.DynValue reads numeric dynamic-tag values. DynFlag1/DF_1 constants, COMPRESS_ZSTD and R_PPC64_REL24_P9NOTOC support more binary metadata.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / debug/elf on Go 1.21. This source records elf.File.DynValue reads numeric dynamic-tag values. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#debugelfpkgdebugelf).

<a id="rv204"></a>

## RV204: Standard library / Minor changes to the library / debug/pe

PE uninitialized-data sections reject Data/Open reads.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / debug/pe on Go 1.21. This source records PE uninitialized-data sections reject Data/Open reads. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#debugpepkgdebugpe).

<a id="rv205"></a>

## RV205: Standard library / Minor changes to the library / embed

embed files implement ReaderAt. Their Stat results use standard FileInfo string formatting.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / embed on Go 1.21. This source records embed files implement ReaderAt. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#embedpkgembed).

<a id="rv206"></a>

## RV206: Standard library / Minor changes to the library / encoding/binary

binary.NativeEndian encodes/decodes integers in host byte order.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / encoding/binary on Go 1.21. This source records binary.NativeEndian encodes/decodes integers in host byte order. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#encodingbinarypkgencodingbinary).

<a id="rv207"></a>

## RV207: Standard library / Minor changes to the library / errors

errors.ErrUnsupported provides a common errors.Is target for unsupported operations.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / errors on Go 1.21. This source records errors.ErrUnsupported provides a common errors.Is target for unsupported operations. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#errorspkgerrors).

<a id="rv208"></a>

## RV208: Standard library / Minor changes to the library / flag

flag.BoolFunc invokes a callback without requiring an argument. Defining a flag after Set attempted the same name panics, exposing initialization-order dependencies. Express required package dependencies explicitly.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G5](../rules/code-and-api-design.md#g5). The linked rules apply this source to Standard library / Minor changes to the library / flag. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.21#flagpkgflag).

<a id="rv209"></a>

## RV209: Standard library / Minor changes to the library / go/ast

ast.IsGenerated recognizes generated-file markers. File.GoVersion records minimum versions implied by build constraints.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G277](../rules/versions-and-tooling.md#g277). The linked rules apply this source to Standard library / Minor changes to the library / go/ast. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.21#goastpkggoast).

<a id="rv210"></a>

## RV210: Standard library / Minor changes to the library / go/build

go/build records header //go: directives in Directives/TestDirectives/XTestDirectives.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / go/build on Go 1.21. This source records go/build records header //go: directives in Directives/TestDirectives/XTestDirectives. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#gobuildpkggobuild).

<a id="rv211"></a>

## RV211: Standard library / Minor changes to the library / go/build/constraint

constraint.GoVersion derives a minimum Go version from a build expression.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / go/build/constraint on Go 1.21. This source records constraint.GoVersion derives a minimum Go version from a build expression. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#gobuildconstraintpkggobuildconstraint).

<a id="rv212"></a>

## RV212: Standard library / Minor changes to the library / go/token

token.File.Lines exposes the line table in SetLines format.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / go/token on Go 1.21. This source records token.File.Lines exposes the line table in SetLines format. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#gotokenpkggotoken).

<a id="rv213"></a>

## RV213: Standard library / Minor changes to the library / go/types

types.Package.GoVersion reports the language version used for checking.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / go/types on Go 1.21. This source records types.Package.GoVersion reports the language version used for checking. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#gotypespkggotypes).

<a id="rv214"></a>

## RV214: Standard library / Minor changes to the library / hash/maphash

maphash offers a pure Go implementation selected by purego.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / hash/maphash on Go 1.21. This source records maphash offers a pure Go implementation selected by purego. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#hashmaphashpkghashmaphash).

<a id="rv215"></a>

## RV215: Standard library / Minor changes to the library / html/template

html/template exports ErrJSTemplate for forbidden actions inside JavaScript template literals.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / html/template on Go 1.21. This source records html/template exports ErrJSTemplate for forbidden actions inside JavaScript template literals. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#htmltemplatepkghtmltemplate).

<a id="rv216"></a>

## RV216: Standard library / Minor changes to the library / io/fs

fs.FormatFileInfo/FormatDirEntry produce standard display forms. ReadDir and WalkDir entries implement corresponding String methods.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / io/fs on Go 1.21. This source records fs.FormatFileInfo/FormatDirEntry produce standard display forms. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#iofspkgiofs).

<a id="rv217"></a>

## RV217: Standard library / Minor changes to the library / math/big

big.Int.Float64 reports the nearest floating-point value and rounding accuracy.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / math/big on Go 1.21. This source records big.Int.Float64 reports the nearest floating-point value and rounding accuracy. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#mathbigpkgmathbig).

<a id="rv218"></a>

## RV218: Standard library / Minor changes to the library / net

Linux Multipath TCP is opt-in through Dialer/ListenConfig.SetMultipathTCP, with silent ordinary-TCP fallback when unavailable. TCPConn.MultipathTCP reports actual use. Possible future default enablement is only a plan.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / net on Go 1.21. This source records Linux Multipath TCP is opt-in through Dialer/ListenConfig.SetMultipathTCP, with silent ordinary-TCP fallback when unavailable. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#netpkgnet).

<a id="rv219"></a>

## RV219: Standard library / Minor changes to the library / net/http

ResponseController.EnableFullDuplex permits simultaneous HTTP/1 request reads and response writes, disabling automatic body consumption that normally avoids client deadlocks. ErrSchemeMismatch identifies HTTP replies to HTTPS. ErrNotSupported matches errors.ErrUnsupported.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / net/http on Go 1.21. This source records ResponseController.EnableFullDuplex permits simultaneous HTTP/1 request reads and response writes, disabling automatic body consumption that normally avoids client deadlocks. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#nethttppkgnethttp).

<a id="rv220"></a>

## RV220: Standard library / Minor changes to the library / os

Chtimes accepts zero times to preserve either timestamp. Windows File.Chdir works, Truncate stops creating missing files, TempDir prefers hardened GetTempPath2W, UTF-16 names beyond valid UTF-8 are supported, and Lstat follows links when paths end in a separator. Unix NewFile on nonblocking descriptors keeps Fd nonblocking. Directory entries gain standard formatting and DirFS implements ReadFileFS/ReadDirFS.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / os on Go 1.21. This source records Chtimes accepts zero times to preserve either timestamp. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#ospkgos).

<a id="rv221"></a>

## RV221: Standard library / Minor changes to the library / path/filepath

filepath.WalkDir entries gain standard DirEntry string formatting.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / path/filepath on Go 1.21. This source records filepath.WalkDir entries gain standard DirEntry string formatting. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#pathfilepathpkgpathfilepath).

<a id="rv222"></a>

## RV222: Standard library / Minor changes to the library / reflect

reflect.ValueOf and many operations permit stack allocation. Value.Clear mirrors clear. SliceHeader/StringHeader are deprecated in favor of unsafe.Slice/SliceData/String/StringData.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G271](../rules/performance-and-diagnostics.md#g271). The linked rules apply this source to Standard library / Minor changes to the library / reflect. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.21#reflectpkgreflect).

<a id="rv223"></a>

## RV223: Standard library / Minor changes to the library / regexp

regexp gains text marshal/unmarshal methods, changing integration with serializers that honor those interfaces.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / regexp on Go 1.21. This source records regexp gains text marshal/unmarshal methods, changing integration with serializers that honor those interfaces. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#regexppkgregexp).

<a id="rv224"></a>

## RV224: Standard library / Minor changes to the library / runtime

Text stack traces include creator goroutine IDs. GOTRACEBACK=wer enables Windows Error Reporting with crash behavior and is ignored elsewhere. Thorough cgo checking moves from runtime cgocheck=2 to build-time GOEXPERIMENT=cgocheck2; cgocheck=1 remains default. runtime.Pinner permits pinned Go memory and certain nested references across cgo boundaries subject to pointer rules.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / runtime on Go 1.21. This source records Text stack traces include creator goroutine IDs. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#runtimepkgruntime).

<a id="rv225"></a>

## RV225: Standard library / Minor changes to the library / runtime/metrics

Runtime metrics expose additional GC information including live heap, GOGC and GOMEMLIMIT.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / runtime/metrics on Go 1.21. This source records Runtime metrics expose additional GC information including live heap, GOGC and GOMEMLIMIT. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#runtimemetricspkgruntimemetrics).

<a id="rv226"></a>

## RV226: Standard library / Minor changes to the library / runtime/trace

Tracing costs fall substantially on amd64/arm64, and traces identify all stop-the-world reasons rather than GC alone.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / runtime/trace on Go 1.21. This source records Tracing costs fall substantially on amd64/arm64, and traces identify all stop-the-world reasons rather than GC alone. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#runtimetracepkgruntimetrace).

<a id="rv227"></a>

## RV227: Standard library / Minor changes to the library / sync

sync.OnceFunc/OnceValue/OnceValues package one-time execution and lazy value initialization.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / sync on Go 1.21. This source records sync.OnceFunc/OnceValue/OnceValues package one-time execution and lazy value initialization. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#syncpkgsync).

<a id="rv228"></a>

## RV228: Standard library / Minor changes to the library / syscall

Windows Fchdir works and UTF16 conversions support WTF-8 for otherwise unrepresentable filenames. FreeBSD SysProcAttr.Jail selects a jail. ENOSYS/ENOTSUP/EOPNOTSUPP, Plan 9 EPLAN9 and Windows ERROR_CALL_NOT_IMPLEMENTED/ERROR_NOT_SUPPORTED/EWINDOWS match errors.ErrUnsupported.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / syscall on Go 1.21. This source records Windows Fchdir works and UTF16 conversions support WTF-8 for otherwise unrepresentable filenames. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#syscallpkgsyscall).

<a id="rv229"></a>

## RV229: Standard library / Minor changes to the library / testing

-test.fullpath prints full filenames. testing.Testing reports whether go test created the program.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / testing on Go 1.21. This source records -test.fullpath prints full filenames. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#testingpkgtesting).

<a id="rv230"></a>

## RV230: Standard library / Minor changes to the library / testing/fstest

fstest Stat results implement standard FileInfo string formatting.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / testing/fstest on Go 1.21. This source records fstest Stat results implement standard FileInfo string formatting. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#testingfstestpkgtestingfstest).

<a id="rv231"></a>

## RV231: Standard library / Minor changes to the library / unicode

Unicode data advances to 15.0.0 throughout the library.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / unicode on Go 1.21. This source records Unicode data advances to 15.0.0 throughout the library. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#unicodepkgunicode).

<a id="rv232"></a>

## RV232: Ports / Darwin

macOS 10.15+ is now required.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / Darwin on Go 1.21. This source records macOS 10.15+ is now required. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#darwin).

<a id="rv233"></a>

## RV233: Ports / Windows

Windows 10 or Server 2016+ is now required.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / Windows on Go 1.21. This source records Windows 10 or Server 2016+ is now required. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#windows).

<a id="rv234"></a>

## RV234: Ports / ARM

Building an ARM cross-toolchain defaults GOARM to 7. Native ARM toolchain builds continue detecting the host.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / ARM on Go 1.21. This source records Building an ARM cross-toolchain defaults GOARM to 7. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#arm).

<a id="rv235"></a>

## RV235: Ports / WebAssembly

go:wasmimport imports host functions. The WebAssembly scheduler cooperates more efficiently with JavaScript asynchronous events.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / WebAssembly on Go 1.21. This source records go:wasmimport imports host functions. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#wasm).

<a id="rv236"></a>

## RV236: Ports / WebAssembly System Interface

Experimental wasip1/wasm targets WASI Preview 1. The new GOOS makes *_wasip1.go files target-specific, so unrelated existing names may need changes.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / WebAssembly System Interface on Go 1.21. This source records Experimental wasip1/wasm targets WASI Preview 1. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#wasip1).

<a id="rv237"></a>

## RV237: Ports / ppc64/ppc64le

GOPPC64=power10 enables newer instructions. Linux additionally uses PC-relative instructions and can reduce ppc64le position-independent binary size in c-archive/c-shared/shared/pie/plugin modes. AIX does not use PC-relative instructions.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / ppc64/ppc64le on Go 1.21. This source records GOPPC64=power10 enables newer instructions. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#PPC64).

<a id="rv238"></a>

## RV238: Ports / loong64

linux/loong64 adds c-archive, c-shared and pie build modes.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / loong64 on Go 1.21. This source records linux/loong64 adds c-archive, c-shared and pie build modes. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.21#loong64).
