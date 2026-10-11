# Go 1.20 source reference

Status: published-stable-release. Source: [official release notes](https://go.dev/doc/go1.20).

These are versioned source summaries. The linked rules cover recurring actions. A reference disposition preserves an API or implementation detail for tasks that need it. Read later releases before applying historical defaults.

<a id="rv115"></a>

## RV115: Changes to the language

Slices can convert directly to arrays, complementing array-pointer conversions. unsafe.SliceData/String/StringData avoid depending on slice/string header layout, but remain unsafe operations. The spec now explicitly requires ordered, short-circuit struct/array comparisons, matching existing implementations and determining whether later fields can panic. Non-strictly-comparable types such as interfaces may satisfy comparable constraints, but comparing their dynamic values can still panic.

Applicability: Direct slice-to-array conversion and revised comparable constraint satisfaction require Go 1.20 language support. The unsafe helpers require the Go 1.20 library. Ordered struct/array comparison clarifies existing implementations rather than introducing a new runtime mode.

Disposition: [G17](../rules/code-and-api-design.md#g17), [G63](../rules/collections-and-ownership.md#g63), [G271](../rules/performance-and-diagnostics.md#g271). The linked rules apply this source to Changes to the language. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.20#language).

<a id="rv116"></a>

## RV116: Ports / Windows

Go 1.20 is the last release for Windows 7/8 and Server 2008/2012. Go 1.21 requires Windows 10 or Server 2016+.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / Windows on Go 1.20. This source records Go 1.20 is the last release for Windows 7/8 and Server 2008/2012. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#windows).

<a id="rv117"></a>

## RV117: Ports / Darwin and iOS

Go 1.20 is the last release for macOS 10.13/10.14. Go 1.21 requires 10.15+.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / Darwin and iOS on Go 1.20. This source records Go 1.20 is the last release for macOS 10.13/10.14. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#darwin).

<a id="rv118"></a>

## RV118: Ports / FreeBSD/RISC-V

freebsd/riscv64 support is experimental.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / FreeBSD/RISC-V on Go 1.20. This source records freebsd/riscv64 support is experimental. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#freebsd-riscv).

<a id="rv119"></a>

## RV119: Tools / Go command

Standard packages are built into the normal cache instead of distributed/stored under GOROOT/pkg. Direct test2json users should pass -v=test2json. Test JSON gains ordered package start events. Architecture-feature tags select implementations. Subcommands accept -C directory. build/test remove -i; generate/test gain -skip. Module-mode install no longer writes non-main libraries into GOPATH/pkg or reports their Target. -pgo enables preview profile optimization, with auto looking for default.pgo only for one main package in this release, and off disabling it. -cover instruments application builds.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Tools / Go command on Go 1.20. This source records Standard packages are built into the normal cache instead of distributed/stored under GOROOT/pkg. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#go-command).

<a id="rv120"></a>

## RV120: Tools / Go command / go version

go version -m reads Windows c-shared DLLs and non-executable Linux binaries.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Tools / Go command / go version on Go 1.20. This source records go version -m reads Windows c-shared DLLs and non-executable Linux binaries. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#go-version).

<a id="rv121"></a>

## RV121: Tools / Cgo

With CGO_ENABLED and CC unset and no default C compiler in PATH, cgo defaults off. net/os/user use pure Go alternatives where needed; macOS implementations no longer need cgo, and Windows already did not. A macOS c-archive using net must link C code with -lresolv. macOS race builds no longer need Xcode/cgo; other supported systems still need a host C toolchain.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: [G246](../rules/versions-and-tooling.md#g246). The linked rules apply this source to Tools / Cgo. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.20#cgo).

<a id="rv122"></a>

## RV122: Tools / Cover

Application/integration coverage uses go build -cover and GOCOVERDIR during execution. It extends coverage beyond unit tests.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: [G256](../rules/testing.md#g256). The linked rules apply this source to Tools / Cover. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.20#cover).

<a id="rv123"></a>

## RV123: Tools / Vet / Improved detection of loop variable capture by nested functions

vet detects loop captures after T.Parallel and recursively inside final if/switch/select branches. Under the pre-1.22 loop semantics these can skip test cases or race.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: [G179](../rules/testing.md#g179). The linked rules apply this source to Tools / Vet / Improved detection of loop variable capture by nested functions. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.20#vet-loopclosure).

<a id="rv124"></a>

## RV124: Tools / Vet / New diagnostic for incorrect time formats

vet diagnoses the commonly mistaken layout 2006-02-01 in time.Parse/Format. ISO date order is 2006-01-02.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Tools / Vet / New diagnostic for incorrect time formats on Go 1.20. This source records vet diagnoses the commonly mistaken layout 2006-02-01 in time.Parse/Format. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#vet-timeformat).

<a id="rv125"></a>

## RV125: Runtime

GC data structures use less memory/CPU and goroutine assists become more predictable. runtime/coverage lets long-running programs explicitly write coverage without relying on normal process exit.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: [G256](../rules/testing.md#g256). The linked rules apply this source to Runtime. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.20#runtime).

<a id="rv126"></a>

## RV126: Compiler

Preview PGO consumes pprof CPU profiles and inlines hot calls, with workload-dependent measured gains around 3-4%. A new compiler front end fixes generic issues and permits local type declarations in generic functions/methods. Anonymous interface cycles are rejected by default, anticipating a later spec ban. Build speed recovers up to 10% relative to 1.19 and generated-code performance improves slightly.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Compiler on Go 1.20. This source records Preview PGO consumes pprof CPU profiles and inlines hot calls, with workload-dependent measured gains around 3-4%. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#compiler).

<a id="rv127"></a>

## RV127: Linker

Linux linking chooses the glibc/musl dynamic interpreter at link time. Windows supports LLVM C toolchains. Generated symbols use go:/type: prefixes; binary tools need updated debug/gosym.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Linker on Go 1.20. This source records Linux linking chooses the glibc/musl dynamic interpreter at link time. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#linker).

<a id="rv128"></a>

## RV128: Bootstrap

Source bootstrap requires Go 1.17.13, searched in ~/go1.17.13 and ~/sdk/go1.17.13 before the historical ~/go1.4 path. The path fallback does not permit an actual 1.4 compiler. Annual bootstrap advances and a final-1.20 requirement for 1.22 are plans stated here.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Bootstrap on Go 1.20. This source records Source bootstrap requires Go 1.17.13, searched in ~/go1.17.13 and ~/sdk/go1.17.13 before the historical ~/go1.4 path. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#bootstrap).

<a id="rv129"></a>

## RV129: Standard library / New crypto/ecdh package

crypto/ecdh supplies NIST-curve and Curve25519 key exchange. Prefer it to low-level elliptic arithmetic for ECDH; more specialized operations need suitable external libraries.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G274](../rules/security-and-compatibility.md#g274). The linked rules apply this source to Standard library / New crypto/ecdh package. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.20#crypto_ecdh).

<a id="rv130"></a>

## RV130: Standard library / Wrapping multiple errors

Errors can wrap multiple children with Unwrap() []error. errors.Is/As traverse them, fmt.Errorf accepts multiple %w operands, and errors.Join constructs a multi-error.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G99](../rules/errors-and-cleanup.md#g99), [G105](../rules/errors-and-cleanup.md#g105), [G253](../rules/errors-and-cleanup.md#g253). The linked rules apply this source to Standard library / Wrapping multiple errors. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.20#errors).

<a id="rv131"></a>

## RV131: Standard library / HTTP ResponseController

http.ResponseController exposes optional per-request operations more directly than type assertions on ResponseWriter. New SetReadDeadline/SetWriteDeadline control individual requests.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G168](../rules/resource-and-http-lifecycles.md#g168). The linked rules apply this source to Standard library / HTTP ResponseController. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.20#http_responsecontroller).

<a id="rv132"></a>

## RV132: Standard library / New ReverseProxy Rewrite hook

ReverseProxy.Rewrite supersedes Director and receives both inbound/outbound requests, avoiding removal of hook-added headers by malicious inbound connection headers. ProxyRequest.SetURL also sets outbound Host. SetXForwarded explicitly supplies forwarding headers, which Rewrite does not add automatically. Absent incoming User-Agent is no longer synthesized.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G261](../rules/resource-and-http-lifecycles.md#g261). The linked rules apply this source to Standard library / New ReverseProxy Rewrite hook. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.20#reverseproxy_rewrite).

<a id="rv133"></a>

## RV133: Standard library / Minor changes to the library / archive/tar

With tarinsecurepath=0, tar.Reader.Next reports ErrInsecurePath for nonlocal/invalid names, including Windows reserved names. This is opt-in here; a possible future default is not current behavior.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / archive/tar on Go 1.20. This source records With tarinsecurepath=0, tar.Reader.Next reports ErrInsecurePath for nonlocal/invalid names, including Windows reserved names. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#archivetarpkgarchivetar).

<a id="rv134"></a>

## RV134: Standard library / Minor changes to the library / archive/zip

With zipinsecurepath=0, zip.NewReader reports ErrInsecurePath for nonlocal/invalid archive names. Directory entries containing file data now fail reads because such archives are invalid.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / archive/zip on Go 1.20. This source records With zipinsecurepath=0, zip.NewReader reports ErrInsecurePath for nonlocal/invalid archive names. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#archivezippkgarchivezip).

<a id="rv135"></a>

## RV135: Standard library / Minor changes to the library / bytes

bytes.CutPrefix/CutSuffix report whether removal occurred. Clone copies slice storage.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / bytes on Go 1.20. This source records bytes.CutPrefix/CutSuffix report whether removal occurred. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#bytespkgbytes).

<a id="rv136"></a>

## RV136: Standard library / Minor changes to the library / context

context.WithCancelCause records a cancellation error retrievable with context.Cause, separating the reason from the ordinary cancellation status.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G252](../rules/concurrency-and-lifecycles.md#g252). The linked rules apply this source to Standard library / Minor changes to the library / context. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.20#contextpkgcontext).

<a id="rv137"></a>

## RV137: Standard library / Minor changes to the library / crypto/ecdsa

Supported ECDSA curves use constant-time operations, at a measured CPU cost especially on P384/P521. PrivateKey.ECDH converts to the safer key-exchange API.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/ecdsa on Go 1.20. This source records Supported ECDSA curves use constant-time operations, at a measured CPU cost especially on P384/P521. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#cryptoecdsapkgcryptoecdsa).

<a id="rv138"></a>

## RV138: Standard library / Minor changes to the library / crypto/ed25519

Ed25519 supports prehashed Ed25519ph via SHA512 Options.HashFunc and context-bearing Ed25519ctx/Ed25519ph via Options.Context.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/ed25519 on Go 1.20. This source records Ed25519 supports prehashed Ed25519ph via SHA512 Options.HashFunc and context-bearing Ed25519ctx/Ed25519ph via Options.Context. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#cryptoed25519pkgcryptoed25519).

<a id="rv139"></a>

## RV139: Standard library / Minor changes to the library / crypto/rsa

RSA OAEPOptions.MGFHash independently selects the MGF1 hash for decryption. A safer constant-time backend increases costs, particularly encryption and 32-bit operations. Do not modify or hand-build PrecomputedValues.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/rsa on Go 1.20. This source records RSA OAEPOptions.MGFHash independently selects the MGF1 hash for decryption. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#cryptorsapkgcryptorsa).

<a id="rv140"></a>

## RV140: Standard library / Minor changes to the library / crypto/subtle

subtle.XORBytes XORs two byte slices.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/subtle on Go 1.20. This source records subtle.XORBytes XORs two byte slices. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#cryptosubtlepkgcryptosubtle).

<a id="rv141"></a>

## RV141: Standard library / Minor changes to the library / crypto/tls

TLS shares parsed certificates among active clients to reduce memory. CertificateVerificationError exposes presented certificates when handshake verification fails.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/tls on Go 1.20. This source records TLS shares parsed certificates among active clients to reduce memory. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#cryptotlspkgcryptotls).

<a id="rv142"></a>

## RV142: Standard library / Minor changes to the library / crypto/x509

PKCS8/PKIX marshal/parse functions support ecdh keys. Parsed NIST keys still use ECDSA types and need ECDH conversion. SetFallbackRoots supplies trust roots when platform verification/root bundles are unavailable, commonly from x/crypto/x509roots/fallback.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/x509 on Go 1.20. This source records PKCS8/PKIX marshal/parse functions support ecdh keys. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#cryptox509pkgcryptox509).

<a id="rv143"></a>

## RV143: Standard library / Minor changes to the library / debug/elf

ELF reads of SHT_NOBITS data fail rather than pretending bytes exist. More LoongArch/PPC64 ELFv2 relocation constants are exported, and R_PPC64_SECTOFF_LO_DS is corrected to 62.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / debug/elf on Go 1.20. This source records ELF reads of SHT_NOBITS data fail rather than pretending bytes exist. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#debugelfpkgdebugelf).

<a id="rv144"></a>

## RV144: Standard library / Minor changes to the library / debug/gosym

Use 1.20 debug/gosym to read binaries with the new generated-symbol prefixes while retaining older-binary support.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / debug/gosym on Go 1.20. This source records Use 1.20 debug/gosym to read binaries with the new generated-symbol prefixes while retaining older-binary support. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#debuggosympkgdebuggosym).

<a id="rv145"></a>

## RV145: Standard library / Minor changes to the library / debug/pe

debug/pe adds IMAGE_FILE_MACHINE_RISCV* constants.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / debug/pe on Go 1.20. This source records debug/pe adds IMAGE_FILE_MACHINE_RISCV* constants. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#debugpepkgdebugpe).

<a id="rv146"></a>

## RV146: Standard library / Minor changes to the library / encoding/binary

binary.ReadVarint/ReadUvarint return io.ErrUnexpectedEOF for truncated values, reserving io.EOF for no value.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / encoding/binary on Go 1.20. This source records binary.ReadVarint/ReadUvarint return io.ErrUnexpectedEOF for truncated values, reserving io.EOF for no value. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#encodingbinarypkgencodingbinary).

<a id="rv147"></a>

## RV147: Standard library / Minor changes to the library / encoding/xml

xml.Encoder.Close checks unfinished elements. Decoding rejects multi-colon names, empty namespace bindings and mismatched opening/closing prefixes even when their namespace URIs match.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / encoding/xml on Go 1.20. This source records xml.Encoder.Close checks unfinished elements. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#encodingxmlpkgencodingxml).

<a id="rv148"></a>

## RV148: Standard library / Minor changes to the library / errors

errors.Join wraps a list of errors for traversal by Is/As.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G105](../rules/errors-and-cleanup.md#g105), [G253](../rules/errors-and-cleanup.md#g253). The linked rules apply this source to Standard library / Minor changes to the library / errors. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.20#errorspkgerrors).

<a id="rv149"></a>

## RV149: Standard library / Minor changes to the library / fmt

fmt.Errorf supports several %w operands. FormatString reconstructs a formatting directive from fmt.State for Formatter implementations.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G105](../rules/errors-and-cleanup.md#g105), [G253](../rules/errors-and-cleanup.md#g253). The linked rules apply this source to Standard library / Minor changes to the library / fmt. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.20#fmtpkgfmt).

<a id="rv150"></a>

## RV150: Standard library / Minor changes to the library / go/ast

ast.RangeStmt.Range records the keyword position. FileStart/FileEnd delimit the whole source file.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / go/ast on Go 1.20. This source records ast.RangeStmt.Range records the keyword position. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#goastpkggoast).

<a id="rv151"></a>

## RV151: Standard library / Minor changes to the library / go/token

token.FileSet.RemoveFile lets long-running tools release obsolete file metadata.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / go/token on Go 1.20. This source records token.FileSet.RemoveFile lets long-running tools release obsolete file metadata. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#gotokenpkggotoken).

<a id="rv152"></a>

## RV152: Standard library / Minor changes to the library / go/types

types.Satisfies distinguishes satisfying a generic constraint from implementing an interface under the revised comparable rules.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / go/types on Go 1.20. This source records types.Satisfies distinguishes satisfying a generic constraint from implementing an interface under the revised comparable rules. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#gotypespkggotypes).

<a id="rv153"></a>

## RV153: Standard library / Minor changes to the library / html/template

From Go 1.20.3, html/template blocks actions in ECMAScript template literals. jstmpllitinterp=1 temporarily restores them. Preserve the patch threshold.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / html/template on Go 1.20. This source records From Go 1.20.3, html/template blocks actions in ECMAScript template literals. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#htmltemplatepkghtmltemplate).

<a id="rv154"></a>

## RV154: Standard library / Minor changes to the library / io

io.OffsetWriter adapts WriterAt with a fixed offset and supports Seek/Write/WriteAt.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / io on Go 1.20. This source records io.OffsetWriter adapts WriterAt with a fixed offset and supports Seek/Write/WriteAt. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#iopkgio).

<a id="rv155"></a>

## RV155: Standard library / Minor changes to the library / io/fs

fs.SkipAll stops WalkDir successfully.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / io/fs on Go 1.20. This source records fs.SkipAll stops WalkDir successfully. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#iofspkgiofs).

<a id="rv156"></a>

## RV156: Standard library / Minor changes to the library / math/big

math/big's broad functionality and input-dependent timing make it unsuitable for cryptographic implementations. Standard crypto stops using nontrivial Int operations on attacker-controlled values. Security triage depends on wider standard-library impact.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G274](../rules/security-and-compatibility.md#g274). The linked rules apply this source to Standard library / Minor changes to the library / math/big. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.20#mathbigpkgmathbig).

<a id="rv157"></a>

## RV157: Standard library / Minor changes to the library / math/rand

math/rand globally autoseeds. Top-level Seed is deprecated, with randautoseed=0 temporarily restoring old initialization. Reproducible sequences should use a private seeded Rand. Top-level Read is deprecated; crypto/rand.Read usually fits random-byte needs better.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G254](../rules/security-and-compatibility.md#g254), [G273](../rules/security-and-compatibility.md#g273). The linked rules apply this source to Standard library / Minor changes to the library / math/rand. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.20#mathrandpkgmathrand).

<a id="rv158"></a>

## RV158: Standard library / Minor changes to the library / mime

mime.ParseMediaType accepts repeated parameter names when their values agree.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / mime on Go 1.20. This source records mime.ParseMediaType accepts repeated parameter names when their values agree. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#mimepkgmime).

<a id="rv159"></a>

## RV159: Standard library / Minor changes to the library / mime/multipart

multipart readers wrap underlying errors. The served 1.20 notes repeat the 1.19.8 header/part-limit wording: 10,000 headers and 1,000 parts with multipartmaxheaders/multipartmaxparts overrides. Treat the 1.20-line hardening as patch-era evidence, not a 1.20.0 default inferred from that wording.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / mime/multipart on Go 1.20. This source records multipart readers wrap underlying errors. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#mimemultipartpkgmimemultipart).

<a id="rv160"></a>

## RV160: Standard library / Minor changes to the library / net

LookupCNAME succeeds for an existing CNAME even if its target lacks address records. FlagRunning distinguishes operational readiness from administrative FlagUp. Dialer.ControlContext overrides Control and receives context. The resolver sends AD for trust-ad but does not use response AD. nsswitch.conf reload checks occur at most every five seconds.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / net on Go 1.20. This source records LookupCNAME succeeds for an existing CNAME even if its target lacks address records. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#netpkgnet).

<a id="rv161"></a>

## RV161: Standard library / Minor changes to the library / net/http

HTTP notes reiterate 1xx response support. DisableGeneralOptionsHandler disables OPTIONS *. OnProxyConnectResponse observes proxy CONNECT replies. Servers accept HEAD bodies. HTTP/2 stream errors support errors.As to x/net/http2.StreamError. Cookie names trim surrounding spaces and an unset Expires is valid.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / net/http on Go 1.20. This source records HTTP notes reiterate 1xx response support. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#nethttppkgnethttp).

<a id="rv162"></a>

## RV162: Standard library / Minor changes to the library / net/netip

netip adds IPv6LinkLocalAllRouters and IPv6Loopback constructors.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / net/netip on Go 1.20. This source records netip adds IPv6LinkLocalAllRouters and IPv6Loopback constructors. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#netnetippkgnetnetip).

<a id="rv163"></a>

## RV163: Standard library / Minor changes to the library / os

Windows Mkdir/Stat stop special-casing NUL. Directory File.Stat queries the handle, with Open omitting FILE_SHARE_DELETE as for regular files. File.Seek can return a directory to its beginning.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / os on Go 1.20. This source records Windows Mkdir/Stat stop special-casing NUL. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#ospkgos).

<a id="rv164"></a>

## RV164: Standard library / Minor changes to the library / os/exec

exec.Cmd.Cancel and WaitDelay customize context cancellation and bound waits on pipes left open by child processes.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G265](../rules/resource-and-http-lifecycles.md#g265). The linked rules apply this source to Standard library / Minor changes to the library / os/exec. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.20#osexecpkgosexec).

<a id="rv165"></a>

## RV165: Standard library / Minor changes to the library / path/filepath

filepath.SkipAll stops Walk successfully. IsLocal performs lexical containment checks, which do not resolve symlinks or prove filesystem confinement.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G264](../rules/resource-and-http-lifecycles.md#g264). The linked rules apply this source to Standard library / Minor changes to the library / path/filepath. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.20#pathfilepathpkgpathfilepath).

<a id="rv166"></a>

## RV166: Standard library / Minor changes to the library / reflect

reflect.Value.Comparable/Equal expose safe equality checks, Grow reserves slice capacity and SetZero clears values. SetIterKey/SetIterValue now enforce the unexported-field checks that their nonoptimized equivalents already required.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / reflect on Go 1.20. This source records reflect.Value.Comparable/Equal expose safe equality checks, Grow reserves slice capacity and SetZero clears values. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#reflectpkgreflect).

<a id="rv167"></a>

## RV167: Standard library / Minor changes to the library / regexp

regexp/syntax.ErrLarge identifies excessive expression size. The rejection itself was backported in 1.19.2/1.18.7 using ErrInternalError.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / regexp on Go 1.20. This source records regexp/syntax.ErrLarge identifies excessive expression size. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#regexppkgregexp).

<a id="rv168"></a>

## RV168: Standard library / Minor changes to the library / runtime/cgo

cgo.Incomplete marks incomplete C types in generated code.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / runtime/cgo on Go 1.20. This source records cgo.Incomplete marks incomplete C types in generated code. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#runtimecgopkgruntimecgo).

<a id="rv169"></a>

## RV169: Standard library / Minor changes to the library / runtime/metrics

Runtime metrics include GOMAXPROCS, cgo calls, total mutex blocking and GC time measures. Time histograms trade precision for substantially less memory.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / runtime/metrics on Go 1.20. This source records Runtime metrics include GOMAXPROCS, cgo calls, total mutex blocking and GC time measures. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#runtimemetricspkgruntimemetrics).

<a id="rv170"></a>

## RV170: Standard library / Minor changes to the library / runtime/pprof

Mutex profiles pre-scale samples so later sampling-rate changes do not distort earlier data. Windows profiles include mappings for correct position-independent-binary symbolization.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / runtime/pprof on Go 1.20. This source records Mutex profiles pre-scale samples so later sampling-rate changes do not distort earlier data. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#runtimepprofpkgruntimepprof).

<a id="rv171"></a>

## RV171: Standard library / Minor changes to the library / runtime/trace

The background sweeper yields less often, reducing extraneous trace events.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / runtime/trace on Go 1.20. This source records The background sweeper yields less often, reducing extraneous trace events. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#runtimetracepkgruntimetrace).

<a id="rv172"></a>

## RV172: Standard library / Minor changes to the library / strings

strings.CutPrefix/CutSuffix return whether a prefix/suffix was removed.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / strings on Go 1.20. This source records strings.CutPrefix/CutSuffix return whether a prefix/suffix was removed. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#stringspkgstrings).

<a id="rv173"></a>

## RV173: Standard library / Minor changes to the library / sync

sync.Map adds atomic Swap, CompareAndSwap and CompareAndDelete for existing entries.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / sync on Go 1.20. This source records sync.Map adds atomic Swap, CompareAndSwap and CompareAndDelete for existing entries. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#syncpkgsync).

<a id="rv174"></a>

## RV174: Standard library / Minor changes to the library / syscall

FreeBSD 11 compatibility shims are removed. Linux adds CLONE_* constants and CgroupFD/UseCgroupFD child-placement controls.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / syscall on Go 1.20. This source records FreeBSD 11 compatibility shims are removed. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#syscallpkgsyscall).

<a id="rv175"></a>

## RV175: Standard library / Minor changes to the library / testing

testing.B.Elapsed supports custom rate metrics. T.Run from a Cleanup callback now panics because that lifecycle use was never defined.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / testing on Go 1.20. This source records testing.B.Elapsed supports custom rate metrics. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#testingpkgtesting).

<a id="rv176"></a>

## RV176: Standard library / Minor changes to the library / time

time adds DateTime/DateOnly/TimeOnly layouts and Time.Compare. Parse discards precision beyond nanoseconds. Time.MarshalJSON enforces RFC 3339 more strictly.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / time on Go 1.20. This source records time adds DateTime/DateOnly/TimeOnly layouts and Time.Compare. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#timepkgtime).

<a id="rv177"></a>

## RV177: Standard library / Minor changes to the library / unicode/utf16

utf16.AppendRune appends a rune's UTF-16 encoding to a uint16 slice.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / unicode/utf16 on Go 1.20. This source records utf16.AppendRune appends a rune's UTF-16 encoding to a uint16 slice. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.20#unicodeutf16pkgunicodeutf16).
