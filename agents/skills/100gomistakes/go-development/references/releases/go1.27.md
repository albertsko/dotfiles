# Go 1.27 source reference

Status: published-stable-release. Source: [official release notes](https://go.dev/doc/go1.27).

These are versioned source summaries. The linked rules cover recurring actions. A reference disposition preserves an API or implementation detail for tasks that need it. Read later releases before applying historical defaults.

<a id="rv502"></a>

## RV502: Changes to the language

Methods may declare their own type parameters, but interface methods cannot and generic methods cannot implement interface methods. Struct literal keys may use any valid field selector, including nested selectors. Generic function inference applies wherever assignment/conversion provides a matching function type.

Applicability: Generic methods, expanded struct-literal selectors and broader function inference require Go 1.27 language support. Generic methods still cannot implement interface methods.

Disposition: [G17](../rules/code-and-api-design.md#g17). The linked rules apply this source to Changes to the language. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.27#language).

<a id="rv503"></a>

## RV503: Tools

compile/link/asm/cgo/cover/pack accept @response files with GCC-compatible whitespace, quoting, escapes and continued lines, reducing command-line length problems.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Tools on Go 1.27. This source records compile/link/asm/cgo/cover/pack accept @response files with GCC-compatible whitespace, quoting, escapes and continued lines, reducing command-line length problems. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.27#tools).

<a id="rv504"></a>

## RV504: Tools / Go command

The go command drops direct Bazaar (bzr) fetching. Affected module distribution must use another supported route.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Tools / Go command on Go 1.27. This source records The go command drops direct Bazaar (bzr) fetching. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.27#go-command).

<a id="rv505"></a>

## RV505: Tools / Go command / GODEBUG

Removed GODEBUG keys in go.mod or //go:debug remain accepted only when set to their final default. Old values fail the build. Recognizing a removed declaration does not restore its behavior.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: [G242](../rules/versions-and-tooling.md#g242). The linked rules apply this source to Tools / Go command / GODEBUG. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.27#godebug).

<a id="rv506"></a>

## RV506: Tools / Go command / go test

go test runs stdversion by default, exposing too-new library symbols for a file's module/build-tag language version. Test JSON output can include OutputType values error, error-continue and frame.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: [G241](../rules/versions-and-tooling.md#g241), [G243](../rules/versions-and-tooling.md#g243), [G277](../rules/versions-and-tooling.md#g277). The linked rules apply this source to Tools / Go command / go test. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.27#go-test).

<a id="rv507"></a>

## RV507: Tools / Go command / go doc

go doc accepts package@version and -ex for executable examples. Naming an example prints source and comments.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Tools / Go command / go doc on Go 1.27. This source records go doc accepts package@version and -ex for executable examples. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.27#go-doc).

<a id="rv508"></a>

## RV508: Tools / Go command / go fix

go fix adds atomictypes/embedlit/slicesbackward/unsafefuncs modernizers, removes fmtappendf for style concerns and renames waitgroup to waitgroupgo.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: [G243](../rules/versions-and-tooling.md#g243). The linked rules apply this source to Tools / Go command / go fix. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.27#go-fix).

<a id="rv509"></a>

## RV509: Tools / Go command / go mod tidy

For go1.27+ modules, tidy consolidates requires into at most direct/indirect blocks. Comments survive; comments spanning mixed dependency kinds attach to the new direct block. Older module versions do not receive this structural rule.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: [G244](../rules/versions-and-tooling.md#g244). The linked rules apply this source to Tools / Go command / go mod tidy. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.27#go-mod-tidy).

<a id="rv510"></a>

## RV510: Tools / Gofmt

gofmt/go/format alignment becomes architecture-independent, with small whitespace changes possible on previously formatted files.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Tools / Gofmt on Go 1.27. This source records gofmt/go/format alignment becomes architecture-independent, with small whitespace changes possible on previously formatted files. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.27#gofmt).

<a id="rv511"></a>

## RV511: Tools / Vet

vet printf flags %w of *E when E already implements error, exposing accidental pointer wrapping that breaks intended error-type matching.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: [G243](../rules/versions-and-tooling.md#g243). The linked rules apply this source to Tools / Vet. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.27#vet).

<a id="rv512"></a>

## RV512: Tools / Trace

trace -http=:port binds localhost, matching pprof. Explicit 0.0.0.0 is required for all-interface listening.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: [G270](../rules/performance-and-diagnostics.md#g270). The linked rules apply this source to Tools / Trace. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.27#trace).

<a id="rv513"></a>

## RV513: Runtime

For go1.27+ modules, traceback headers include pprof goroutine labels. tracebacklabels=0 disables this and is expected to remain for sensitive-label concerns. asynctimerchan is permanently removed, making time channels synchronous even for old modules.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: [G147](../rules/time-and-serialization.md#g147), [G148](../rules/time-and-serialization.md#g148), [G242](../rules/versions-and-tooling.md#g242), [G270](../rules/performance-and-diagnostics.md#g270). The linked rules apply this source to Runtime. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.27#runtime).

<a id="rv514"></a>

## RV514: Runtime / Faster memory allocation

Size-specialized allocators accelerate some sub-80-byte allocations up to 30%, with expected roughly 1% allocation-heavy application gains and about 60 KB fixed binary growth. nosizespecializedmalloc temporarily opts out;1.28 removal is only anticipated.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: [G269](../rules/performance-and-diagnostics.md#g269). The linked rules apply this source to Runtime / Faster memory allocation. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.27#faster-memory-allocation).

<a id="rv515"></a>

## RV515: Runtime / Goroutine leak profile

goroutineleak profiling becomes supported in pprof and /debug/pprof/goroutineleak; the experiment switch is deleted. Reachability finds synchronization objects with no possible unblocker, but misses leaks whose objects remain reachable from globals or runnable stacks. Absence of samples does not prove absence of leaks.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: [G268](../rules/performance-and-diagnostics.md#g268). The linked rules apply this source to Runtime / Goroutine leak profile. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.27#goroutineleak-profiles).

<a id="rv516"></a>

## RV516: Compiler

Relative //line and /*line*/ paths resolve against the containing file's directory, matching scanner. Closure names no longer depend on inlining and duplicate code may merge. Do not assert closure symbol names or equate function code pointers with closure identity, because distinct captures can share code.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: [G271](../rules/performance-and-diagnostics.md#g271). The linked rules apply this source to Compiler. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.27#compiler).

<a id="rv517"></a>

## RV517: Linker

macOS linker -macos/-macsdk control LC_BUILD_VERSION. Defaults are supported minimum 13.0.0 and SDK 26.2.0 in these notes.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Linker on Go 1.27. This source records macOS linker -macos/-macsdk control LC_BUILD_VERSION. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.27#linker).

<a id="rv518"></a>

## RV518: Standard library / New encoding/json/v2 and encoding/json/jsontext packages

JSONv2/jsontext become supported. v2 Marshal/MarshalWrite/MarshalEncode and Unmarshal/UnmarshalRead/UnmarshalDecode accept Options, defaulting to rejection of invalid UTF-8 and duplicate object names. jsontext Encoder/Decoder process Token/Value streams with syntax-state validation. Legacy encoding/json uses the engine while preserving v1 semantics except error wording and remains supported. nojsonv2 temporarily restores the original engine. Experimental migration removes format/unknown tags, DiscardUnknownMembers and SkipFunc; inline becomes embed; string tags and MatchCaseInsensitiveNames change; numeric Token accessors now return errors. Encoding remains broadly comparable in speed while decoding improves.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G53](../rules/collections-and-ownership.md#g53), [G153](../rules/time-and-serialization.md#g153), [G247](../rules/versions-and-tooling.md#g247), [G260](../rules/time-and-serialization.md#g260), [G276](../rules/security-and-compatibility.md#g276). The linked rules apply this source to Standard library / New encoding/json/v2 and encoding/json/jsontext packages. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.27#jsonv2).

<a id="rv519"></a>

## RV519: Standard library / New crypto/mldsa package

crypto/mldsa implements FIPS 204 ML-DSA. x509 supports its keys/signatures and TLS 1.3 supports MLDSA44/65/87 signature schemes.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / New crypto/mldsa package on Go 1.27. This source records crypto/mldsa implements FIPS 204 ML-DSA. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.27#crypto_mldsa).

<a id="rv520"></a>

## RV520: Standard library / New uuid package

uuid provides UUID generation and parsing.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / New uuid package on Go 1.27. This source records uuid provides UUID generation and parsing. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.27#uuid).

<a id="rv521"></a>

## RV521: Standard library / New experimental simd package

Experimental portable simd requires GOEXPERIMENT=simd. Unspecified-width vector types such as Int8s/Float32s run on all architectures, using hardware or emulation for scalable operations. It remains distinct from architecture-specific APIs.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G247](../rules/versions-and-tooling.md#g247). The linked rules apply this source to Standard library / New experimental simd package. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.27#simd).

<a id="rv522"></a>

## RV522: Standard library / Experimental simd/archsimd package

Experimental archsimd revises amd64 APIs and adds 128-bit arm64 Neon/wasm vectors. amd64 also offers 256/512-bit types where supported. GOEXPERIMENT=simd is required and the API remains unstable/nonportable.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G247](../rules/versions-and-tooling.md#g247). The linked rules apply this source to Standard library / Experimental simd/archsimd package. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.27#archsimd).

<a id="rv523"></a>

## RV523: Standard library / Minor changes to the library / bytes

bytes.CutLast splits at the last separator occurrence.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / bytes on Go 1.27. This source records bytes.CutLast splits at the last separator occurrence. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.27#bytespkgbytes).

<a id="rv524"></a>

## RV524: Standard library / Minor changes to the library / compress/flate

DEFLATE compression accelerates and exact output can change in flate and dependent zip/gzip/zlib/png encoders. Validate decoded content rather than fixed encoding bytes unless a protocol requires otherwise.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G276](../rules/security-and-compatibility.md#g276). The linked rules apply this source to Standard library / Minor changes to the library / compress/flate. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.27#compressflatepkgcompressflate).

<a id="rv525"></a>

## RV525: Standard library / Minor changes to the library / crypto

crypto.MLDSAMu signals External-mu ML-DSA signing.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto on Go 1.27. This source records crypto.MLDSAMu signals External-mu ML-DSA signing. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.27#cryptopkgcrypto).

<a id="rv526"></a>

## RV526: Standard library / Minor changes to the library / crypto/ecdsa

ECDSA PrivateKey.Sign validates hash length when SignerOpts is non-nil.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/ecdsa on Go 1.27. This source records ECDSA PrivateKey.Sign validates hash length when SignerOpts is non-nil. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.27#cryptoecdsapkgcryptoecdsa).

<a id="rv527"></a>

## RV527: Standard library / Minor changes to the library / crypto/tls

QUICConfig.ClientHelloInfoConn supplies connection context for server callbacks. MLKEM1024 is opt-in through CurvePreferences. Config.Rand is deprecated for cryptotest.SetGlobalRandom. Explicit hybrid groups now override tlsmlkem/tlssecpmlkem default-disable settings. ConnectionState.LocalCertificate exposes the presented local chain. tlsunsafeekm/tlsrsakex/tls3des/tls10server/x509keypairleaf are permanently removed: EKM requires TLS 1.3/EMS, defaults exclude RSA-only/3DES and require TLS 1.2, and key-pair loading always fills Leaf. Explicit allowed configuration is distinct from restoring removed defaults. tlskyber's 1.24 removal is documented retrospectively.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G242](../rules/versions-and-tooling.md#g242), [G275](../rules/security-and-compatibility.md#g275). The linked rules apply this source to Standard library / Minor changes to the library / crypto/tls. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.27#cryptotlspkgcryptotls).

<a id="rv528"></a>

## RV528: Standard library / Minor changes to the library / crypto/x509

x509 pkix.Name parsing supports more attribute values, preserving unknown types as asn1.RawValue. RawSignatureAlgorithm exposes DER AlgorithmIdentifier for certificates/requests/CRLs even with unknown enum algorithms. Windows/Darwin SystemCertPool honor SSL_CERT_FILE/DIR and switch to disk roots plus Go verification; x509sslcertoverrideplatform=0 restores platform behavior.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G275](../rules/security-and-compatibility.md#g275). The linked rules apply this source to Standard library / Minor changes to the library / crypto/x509. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.27#cryptox509pkgcryptox509).

<a id="rv529"></a>

## RV529: Standard library / Minor changes to the library / crypto/x509/pkix

pkix name rendering uses strings for string-valued unknown OIDs instead of always DER hex, changing display output.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/x509/pkix on Go 1.27. This source records pkix name rendering uses strings for string-valued unknown OIDs instead of always DER hex, changing display output. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.27#cryptox509pkixpkgcryptox509pkix).

<a id="rv530"></a>

## RV530: Standard library / Minor changes to the library / database/sql

sql.ConvertAssign exposes Rows.Scan conversions to drivers.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / database/sql on Go 1.27. This source records sql.ConvertAssign exposes Rows.Scan conversions to drivers. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.27#databasesqlpkgdatabasesql).

<a id="rv531"></a>

## RV531: Standard library / Minor changes to the library / database/sql/driver

driver.RowsColumnScanner allows direct scans into user destinations.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / database/sql/driver on Go 1.27. This source records driver.RowsColumnScanner allows direct scans into user destinations. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.27#databasesqldriverpkgdatabasesqldriver).

<a id="rv532"></a>

## RV532: Standard library / Minor changes to the library / go/constant

constant.StringLen gets string-constant length without constructing the full value.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / go/constant on Go 1.27. This source records constant.StringLen gets string-constant length without constructing the full value. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.27#goconstantpkggoconstant).

<a id="rv533"></a>

## RV533: Standard library / Minor changes to the library / go/scanner

scanner.Scanner.End reports the current token's end position.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / go/scanner on Go 1.27. This source records scanner.Scanner.End reports the current token's end position. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.27#goscannerpkggoscanner).

<a id="rv534"></a>

## RV534: Standard library / Minor changes to the library / go/token

token.File.String provides a string representation.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / go/token on Go 1.27. This source records token.File.String provides a string representation. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.27#gotokenpkggotoken).

<a id="rv535"></a>

## RV535: Standard library / Minor changes to the library / go/types

types.Hasher/HasherIgnoreTags hash types consistently with Identical/IdenticalIgnoreTags. gotypesalias is removed and Alias nodes are unconditional regardless of module version.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G242](../rules/versions-and-tooling.md#g242), [G277](../rules/versions-and-tooling.md#g277). The linked rules apply this source to Standard library / Minor changes to the library / go/types. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.27#gotypespkggotypes).

<a id="rv536"></a>

## RV536: Standard library / Minor changes to the library / hash/maphash

maphash.Hasher defines equality/hashing contracts for future hashed structures. ComparableHasher implements == equality for comparable types.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / hash/maphash on Go 1.27. This source records maphash.Hasher defines equality/hashing contracts for future hashed structures. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.27#hashmaphashpkghashmaphash).

<a id="rv537"></a>

## RV537: Standard library / Minor changes to the library / math/big

big.Int.Divide computes quotient/remainder with Trunc/Floor/Round/Ceil rounding modes.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / math/big on Go 1.27. This source records big.Int.Divide computes quotient/remainder with Trunc/Floor/Round/Ceil rounding modes. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.27#mathbigpkgmathbig).

<a id="rv538"></a>

## RV538: Standard library / Minor changes to the library / math/rand/v2

rand/v2.Rand.N is a generic method matching package-level N, enabling typed bounded values from private generators.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G254](../rules/security-and-compatibility.md#g254). The linked rules apply this source to Standard library / Minor changes to the library / math/rand/v2. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.27#rand).

<a id="rv539"></a>

## RV539: Standard library / Minor changes to the library / net

UnixConn reads return io.EOF directly rather than net.OpError-wrapped EOF. Callers must tolerate the corrected sentinel shape.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G276](../rules/security-and-compatibility.md#g276). The linked rules apply this source to Standard library / Minor changes to the library / net. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.27#netpkgnet).

<a id="rv540"></a>

## RV540: Standard library / Minor changes to the library / net/http

HTTP supports ALPN on custom net.Conn values exposing ConnectionState. HTTP2 servers honor RFC 9218 client priorities, with DisableClientPriority restoring round-robin. Closing HTTP1 response bodies drains unread data only up to a conservative bound to improve reuse; closing remains required and unlimited reuse is not guaranteed. Recheck idle-pool/client reuse configuration if costs rise; DisableKeepAlives intentionally disables reuse. Server.MaxHeaderValueCount bounds header-value counts with a default when unset.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G161](../rules/resource-and-http-lifecycles.md#g161), [G263](../rules/resource-and-http-lifecycles.md#g263). The linked rules apply this source to Standard library / Minor changes to the library / net/http. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.27#nethttppkgnethttp).

<a id="rv541"></a>

## RV541: Standard library / Minor changes to the library / net/http/httptest

httptest.NewTestServer uses an in-memory fake network compatible with synctest.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G257](../rules/testing.md#g257). The linked rules apply this source to Standard library / Minor changes to the library / net/http/httptest. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.27#nethttphttptestpkgnethttphttptest).

<a id="rv542"></a>

## RV542: Standard library / Minor changes to the library / net/url

URL.Clone and Values.Clone make deep copies.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / net/url on Go 1.27. This source records URL.Clone and Values.Clone make deep copies. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.27#neturlpkgneturl).

<a id="rv543"></a>

## RV543: Standard library / Minor changes to the library / runtime/secret

Goroutines created in experimental secret mode inherit that mode. This note does not graduate runtime/secret from its experiment.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: [G247](../rules/versions-and-tooling.md#g247). The linked rules apply this source to Standard library / Minor changes to the library / runtime/secret. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.27#runtimesecretpkgruntimesecret).

<a id="rv544"></a>

## RV544: Standard library / Minor changes to the library / strings

strings.CutLast splits at the final separator.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / strings on Go 1.27. This source records strings.CutLast splits at the final separator. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.27#stringspkgstrings).

<a id="rv545"></a>

## RV545: Standard library / Minor changes to the library / syscall

Plan 9 defines syscall.Errno for portable compilation, but its syscalls still return ErrorString rather than Errno.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / syscall on Go 1.27. This source records Plan 9 defines syscall.Errno for portable compilation, but its syscalls still return ErrorString rather than Errno. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.27#syscallpkgsyscall).

<a id="rv546"></a>

## RV546: Standard library / Minor changes to the library / testing/synctest

synctest.Sleep combines time.Sleep with Wait for stable bubble progress.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G257](../rules/testing.md#g257). The linked rules apply this source to Standard library / Minor changes to the library / testing/synctest. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.27#testingsynctestpkgtestingsynctest).

<a id="rv547"></a>

## RV547: Standard library / Minor changes to the library / unicode

Unicode data advances from 15 to 17, incorporating 16 and 17 changes throughout the library.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G276](../rules/security-and-compatibility.md#g276). The linked rules apply this source to Standard library / Minor changes to the library / unicode. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.27#unicodepkgunicode).

<a id="rv548"></a>

## RV548: Ports / Darwin

macOS 13+ is required.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: [G246](../rules/versions-and-tooling.md#g246). The linked rules apply this source to Ports / Darwin. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.27#darwin).

<a id="rv549"></a>

## RV549: Ports / PowerPC

linux/ppc64 switches to ELFv2, requiring Linux 3.13+ or compatible backports such as RHEL7's 3.10. cgo/PIE/external linking become supported but require ELFv2-compatible libc and all libraries. Pure Go remains statically internally linked by default; CGO_ENABLED=0 requests that for cgo-capable programs.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: [G246](../rules/versions-and-tooling.md#g246). The linked rules apply this source to Ports / PowerPC. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.27#ppc64).
