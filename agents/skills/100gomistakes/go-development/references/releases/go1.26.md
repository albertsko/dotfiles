# Go 1.26 source reference

Status: published-stable-release. Source: [official release notes](https://go.dev/doc/go1.26).

These are versioned source summaries. The linked rules cover recurring actions. A reference disposition preserves an API or implementation detail for tasks that need it. Read later releases before applying historical defaults.

<a id="rv445"></a>

## RV445: Changes to the language

new accepts an expression and returns a pointer to a variable initialized with its value, simplifying optional fields. Generic types may refer to themselves inside their type-parameter constraints, enabling recursive/self-describing constraints.

Applicability: Expression operands to new and self-referential generic constraints require Go 1.26 language support. Select the effective module/file version accordingly.

Disposition: [G248](../rules/code-and-api-design.md#g248), [G259](../rules/time-and-serialization.md#g259). The linked rules apply this source to Changes to the language. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.26#language).

<a id="rv446"></a>

## RV446: Tools / Go command

go fix is rebuilt on the analysis framework with modernizers and //go:fix inline API migrations; obsolete fixers are removed. Fixes intend to preserve behavior and need review/testing. Stable 1.N.X mod init defaults to go1.(N-1).0; prereleases default to 1.(N-2).0. Override with go get go@version. cmd/doc/go tool doc are removed; go doc preserves their arguments and behavior.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: [G243](../rules/versions-and-tooling.md#g243). The linked rules apply this source to Tools / Go command. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.26#go-command).

<a id="rv447"></a>

## RV447: Tools / Pprof

pprof -http defaults to flame graphs. The graph view remains in the View menu or /ui/graph.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Tools / Pprof on Go 1.26. This source records pprof -http defaults to flame graphs. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.26#pprof).

<a id="rv448"></a>

## RV448: Runtime / New garbage collector

Green Tea GC becomes default, improving small-object scanning locality/scalability. GC-heavy workloads show expected 10-40% overhead reductions, with additional vector scanning gains on Ice Lake/Zen4-class amd64 CPUs. nogreenteagc is still an available build-time opt-out here; anticipated 1.27 removal must be checked separately.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: [G269](../rules/performance-and-diagnostics.md#g269). The linked rules apply this source to Runtime / New garbage collector. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.26#new-garbage-collector).

<a id="rv449"></a>

## RV449: Runtime / Faster cgo calls

Baseline cgo-call overhead falls about 30%.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: release-reference. Consult when using Runtime / Faster cgo calls on Go 1.26. This source records Baseline cgo-call overhead falls about 30%. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.26#faster-cgo-calls).

<a id="rv450"></a>

## RV450: Runtime / Heap base address randomization

64-bit heap bases are randomized at startup for hardening, especially relevant to cgo. norandomizedheapbase64 temporarily opts out.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: release-reference. Consult when using Runtime / Heap base address randomization on Go 1.26. This source records 64-bit heap bases are randomized at startup for hardening, especially relevant to cgo. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.26#heap-base-address-randomization).

<a id="rv451"></a>

## RV451: Runtime / Experimental goroutine leak profile

Experimental goroutineleak profiling requires GOEXPERIMENT=goroutineleakprofile and appears in pprof and HTTP pprof. GC reachability identifies blocked goroutines whose synchronization objects cannot be reached by possible unblockers. This catches abandoned unbuffered-channel workers but misses globally/reachably held deadlocks. The implementation is production-ready while API shape remains experimental, with no intended inactive overhead. Default enablement is planned for 1.27.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: [G268](../rules/performance-and-diagnostics.md#g268). The linked rules apply this source to Runtime / Experimental goroutine leak profile. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.26#goroutineleak-profiles).

<a id="rv452"></a>

## RV452: Compiler

More slice backing arrays can stay on the stack. Diagnose incorrect unsafe lifetime assumptions with bisect -compile=variablemake or temporarily -d=variablemakehash=n.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: [G271](../rules/performance-and-diagnostics.md#g271). The linked rules apply this source to Compiler. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.26#compiler).

<a id="rv453"></a>

## RV453: Linker

windows/arm64 supports internal cgo linking. Executable layout changes affect binary readers/scripts: moduledata moves to .go.module; cutab length is corrected; pcHeader text start is zero; relocation-free .gopclntab moves to rodata and now holds funcdata/findfunctab; empty .gosymtab disappears; internal ELF section headers sort by address. Mach-O uses corresponding double-underscore, dotless names.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: [G277](../rules/versions-and-tooling.md#g277). The linked rules apply this source to Linker. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.26#linker).

<a id="rv454"></a>

## RV454: Bootstrap

Bootstrap requires Go 1.24.6+. A 1.26 point-release requirement for 1.28 is a future plan.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Bootstrap on Go 1.26. This source records Bootstrap requires Go 1.24.6+. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.26#bootstrap).

<a id="rv455"></a>

## RV455: Standard library / New crypto/hpke package

crypto/hpke implements RFC 9180 hybrid public-key encryption including post-quantum hybrid KEMs.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / New crypto/hpke package on Go 1.26. This source records crypto/hpke implements RFC 9180 hybrid public-key encryption including post-quantum hybrid KEMs. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.26#new-cryptohpke-package).

<a id="rv456"></a>

## RV456: Standard library / New experimental simd/archsimd package

Experimental simd/archsimd requires GOEXPERIMENT=simd. amd64 exposes architecture-specific 128/256/512-bit vectors and operations. It is unstable and intentionally nonportable; other architectures and portable SIMD are future plans here.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G247](../rules/versions-and-tooling.md#g247). The linked rules apply this source to Standard library / New experimental simd/archsimd package. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.26#simd).

<a id="rv457"></a>

## RV457: Standard library / New experimental runtime/secret package

Experimental runtime/secret requires GOEXPERIMENT=runtimesecret and supports linux/amd64 and linux/arm64. It securely erases temporaries in registers, stacks and new heap allocations used for secrets, supporting forward secrecy within its documented scope.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: [G247](../rules/versions-and-tooling.md#g247). The linked rules apply this source to Standard library / New experimental runtime/secret package. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.26#new-experimental-runtimesecret-package).

<a id="rv458"></a>

## RV458: Standard library / Minor changes to the library / bytes

bytes.Buffer.Peek views the next n bytes without consuming them.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / bytes on Go 1.26. This source records bytes.Buffer.Peek views the next n bytes without consuming them. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.26#bytespkgbytes).

<a id="rv459"></a>

## RV459: Standard library / Minor changes to the library / crypto

crypto.Encapsulator/Decapsulator abstract KEM keys.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto on Go 1.26. This source records crypto.Encapsulator/Decapsulator abstract KEM keys. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.26#cryptopkgcrypto).

<a id="rv460"></a>

## RV460: Standard library / Minor changes to the library / crypto/dsa

DSA GenerateKey ignores caller randomness and uses secure global randomness. cryptotest.SetGlobalRandom supplies deterministic tests; cryptocustomrand=1 temporarily restores custom-reader behavior.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G273](../rules/security-and-compatibility.md#g273). The linked rules apply this source to Standard library / Minor changes to the library / crypto/dsa. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.26#cryptodsapkgcryptodsa).

<a id="rv461"></a>

## RV461: Standard library / Minor changes to the library / crypto/ecdh

ECDH Curve.GenerateKey ignores caller randomness by default, with the same cryptotest/cryptocustomrand migration. KeyExchanger abstracts private keys, including hardware implementations.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G273](../rules/security-and-compatibility.md#g273). The linked rules apply this source to Standard library / Minor changes to the library / crypto/ecdh. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.26#cryptoecdhpkgcryptoecdh).

<a id="rv462"></a>

## RV462: Standard library / Minor changes to the library / crypto/ecdsa

ECDSA big.Int key fields are deprecated. GenerateKey/SignASN1/Sign and non-nil randomness passed to PrivateKey.Sign use secure internal randomness by default, with cryptotest support and temporary cryptocustomrand=1 restoration. PrivateKey.Sign with nil randomness still selects RFC 6979 deterministic signing. The broad release-note wording must not erase that special case.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G273](../rules/security-and-compatibility.md#g273). The linked rules apply this source to Standard library / Minor changes to the library / crypto/ecdsa. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.26#cryptoecdsapkgcryptoecdsa), [source 2](https://go.dev/src/crypto/ecdsa/ecdsa.go#L313).

<a id="rv463"></a>

## RV463: Standard library / Minor changes to the library / crypto/ed25519

Ed25519 GenerateKey with nil randomness uses a secure source independent of an overridden rand.Reader. cryptocustomrand=1 restores old behavior; explicit non-nil readers are a distinct case.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G273](../rules/security-and-compatibility.md#g273). The linked rules apply this source to Standard library / Minor changes to the library / crypto/ed25519. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.26#cryptoed25519pkgcryptoed25519).

<a id="rv464"></a>

## RV464: Standard library / Minor changes to the library / crypto/fips140

GOFIPS140 can select module v1.26.0. WithoutEnforcement/Enforced permit scoped strict-check control in fips140=only mode. Version reports a resolved frozen module version.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G274](../rules/security-and-compatibility.md#g274). The linked rules apply this source to Standard library / Minor changes to the library / crypto/fips140. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.26#cryptofips140pkgcryptofips140).

<a id="rv465"></a>

## RV465: Standard library / Minor changes to the library / crypto/mlkem

MLKEM decapsulation keys expose Encapsulator to implement crypto.Decapsulator. Encapsulation/decapsulation speed improves about 18%.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/mlkem on Go 1.26. This source records MLKEM decapsulation keys expose Encapsulator to implement crypto.Decapsulator. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.26#cryptomlkempkgcryptomlkem).

<a id="rv466"></a>

## RV466: Standard library / Minor changes to the library / crypto/mlkem/mlkemtest

crypto/mlkem/mlkemtest exposes deterministic Encapsulate768/1024 for known-answer tests.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/mlkem/mlkemtest on Go 1.26. This source records crypto/mlkem/mlkemtest exposes deterministic Encapsulate768/1024 for known-answer tests. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.26#cryptomlkemmlkemtestpkgcryptomlkemmlkemtest).

<a id="rv467"></a>

## RV467: Standard library / Minor changes to the library / crypto/rand

crypto/rand.Prime ignores caller randomness by default. Use cryptotest.SetGlobalRandom for tests or temporary cryptocustomrand=1 for compatibility.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G273](../rules/security-and-compatibility.md#g273). The linked rules apply this source to Standard library / Minor changes to the library / crypto/rand. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.26#cryptorandpkgcryptorand).

<a id="rv468"></a>

## RV468: Standard library / Minor changes to the library / crypto/rsa

RSA EncryptOAEPWithOptions independently chooses OAEP/MGF1 hashes. GenerateKey/GenerateMultiPrimeKey/EncryptPKCS1v15 ignore caller randomness by default, with cryptotest and temporary override support. Validate rejects changes after Precompute and checks D against cached values. PKCS1v15 encryption/decryption/session-key padding APIs are deprecated as unsafe.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G273](../rules/security-and-compatibility.md#g273), [G274](../rules/security-and-compatibility.md#g274). The linked rules apply this source to Standard library / Minor changes to the library / crypto/rsa. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.26#cryptorsapkgcryptorsa).

<a id="rv469"></a>

## RV469: Standard library / Minor changes to the library / crypto/sha3

Zero-value SHA3 and SHAKE are usable SHA3-256 and SHAKE256 instances.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/sha3 on Go 1.26. This source records Zero-value SHA3 and SHAKE are usable SHA3-256 and SHAKE256 instances. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.26#cryptosha3pkgcryptosha3).

<a id="rv470"></a>

## RV470: Standard library / Minor changes to the library / crypto/subtle

WithDataIndependentTiming no longer pins an OS thread. Spawned goroutines and descendants inherit timing mode for life. C calls inherit it and Go restores it after C disables it; C-to-Go callbacks preserve the C timing state for the call.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/subtle on Go 1.26. This source records WithDataIndependentTiming no longer pins an OS thread. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.26#cryptosubtlepkgcryptosubtle).

<a id="rv471"></a>

## RV471: Standard library / Minor changes to the library / crypto/tls

TLS defaults add SecP256r1MLKEM768/SecP384r1MLKEM1024, disabled by explicit CurvePreferences or tlssecpmlkem=0. HelloRetryRequest fields expose retry handshakes. QUIC emits handshake-error events. TLS 1.2+ uses MessageSigner when available. Removal of tlsunsafeekm/tlsrsakex/tls10server/tls3des/x509keypairleaf is announced for 1.27, so older module defaults will no longer preserve those behaviors then.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G275](../rules/security-and-compatibility.md#g275). The linked rules apply this source to Standard library / Minor changes to the library / crypto/tls. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.26#cryptotlspkgcryptotls).

<a id="rv472"></a>

## RV472: Standard library / Minor changes to the library / crypto/x509

x509 KeyUsage/ExtKeyUsage gain readable String forms, ExtKeyUsage.OID returns its identifier, and OIDFromASN1OID converts legacy identifiers.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/x509 on Go 1.26. This source records x509 KeyUsage/ExtKeyUsage gain readable String forms, ExtKeyUsage.OID returns its identifier, and OIDFromASN1OID converts legacy identifiers. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.26#cryptox509pkgcryptox509).

<a id="rv473"></a>

## RV473: Standard library / Minor changes to the library / debug/elf

ELF adds LoongArch psABI v20250521/v2.40 relocation constants.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / debug/elf on Go 1.26. This source records ELF adds LoongArch psABI v20250521/v2.40 relocation constants. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.26#debugelfpkgdebugelf).

<a id="rv474"></a>

## RV474: Standard library / Minor changes to the library / errors

errors.AsType[T] offers typed error extraction with less boilerplate and improved performance compared with As's pointer target.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G99](../rules/errors-and-cleanup.md#g99), [G253](../rules/errors-and-cleanup.md#g253). The linked rules apply this source to Standard library / Minor changes to the library / errors. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.26#errorspkgerrors).

<a id="rv475"></a>

## RV475: Standard library / Minor changes to the library / fmt

Unformatted fmt.Errorf strings allocate less, generally matching errors.New.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / fmt on Go 1.26. This source records Unformatted fmt.Errorf strings allocate less, generally matching errors.New. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.26#fmtpkgfmt).

<a id="rv476"></a>

## RV476: Standard library / Minor changes to the library / go/ast

ast.ParseDirective parses conventional directive comments for tooling. BasicLit.ValueEnd fixes precise literal ends, especially CRLF raw strings. Tools changing ValuePos must update or clear ValueEnd too.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G277](../rules/versions-and-tooling.md#g277). The linked rules apply this source to Standard library / Minor changes to the library / go/ast. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.26#goastpkggoast).

<a id="rv477"></a>

## RV477: Standard library / Minor changes to the library / go/token

token.File.End exposes the file-end position.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / go/token on Go 1.26. This source records token.File.End exposes the file-end position. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.26#gotokenpkggotoken).

<a id="rv478"></a>

## RV478: Standard library / Minor changes to the library / go/types

gotypesalias removal is announced for 1.27. Alias nodes will become unconditional, so consumers must prepare now.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / go/types on Go 1.26. This source records gotypesalias removal is announced for 1.27. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.26#gotypespkggotypes).

<a id="rv479"></a>

## RV479: Standard library / Minor changes to the library / image/jpeg

JPEG encoding/decoding is faster and more accurate but exact output bytes/pixels can change. Avoid unjustified bit-for-bit implementation expectations.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G276](../rules/security-and-compatibility.md#g276). The linked rules apply this source to Standard library / Minor changes to the library / image/jpeg. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.26#imagejpegpkgimagejpeg).

<a id="rv480"></a>

## RV480: Standard library / Minor changes to the library / io

io.ReadAll reduces intermediate allocation and returns a tightly sized slice, often roughly doubling speed and halving total allocated memory. It still reads the whole input.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / io on Go 1.26. This source records io.ReadAll reduces intermediate allocation and returns a tightly sized slice, often roughly doubling speed and halving total allocated memory. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.26#iopkgio).

<a id="rv481"></a>

## RV481: Standard library / Minor changes to the library / log/slog

slog.NewMultiHandler broadcasts to handlers. Enabled succeeds when any child is enabled; child handling and attribute/group derivation follow the documented multi-handler rules.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G272](../rules/code-and-api-design.md#g272). The linked rules apply this source to Standard library / Minor changes to the library / log/slog. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.26#logslogpkglogslog).

<a id="rv482"></a>

## RV482: Standard library / Minor changes to the library / net

Dialer.DialIP/DialTCP/DialUDP/DialUnix add context-aware typed network dialing.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / net on Go 1.26. This source records Dialer.DialIP/DialTCP/DialUDP/DialUnix add context-aware typed network dialing. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.26#netpkgnet).

<a id="rv483"></a>

## RV483: Standard library / Minor changes to the library / net/http

HTTP2Config.StrictMaxConcurrentRequests controls opening extra connections at stream limits. Transport.NewClientConn supports custom connection management, while RoundTrip remains normal pooled usage. Client cookies use Request.Host when supplied. ServeMux slash redirects change from 301 to 307, preserving request method/body semantics.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G262](../rules/resource-and-http-lifecycles.md#g262). The linked rules apply this source to Standard library / Minor changes to the library / net/http. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.26#nethttppkgnethttp).

<a id="rv484"></a>

## RV484: Standard library / Minor changes to the library / net/http/httptest

httptest.Server.Client routes example.com and subdomains to the test server.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / net/http/httptest on Go 1.26. This source records httptest.Server.Client routes example.com and subdomains to the test server. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.26#nethttphttptestpkgnethttphttptest).

<a id="rv485"></a>

## RV485: Standard library / Minor changes to the library / net/http/httputil

ReverseProxy.Director is deprecated because hostile hop-by-hop declarations can remove headers it adds. Rewrite, available since 1.20, safely separates inbound/outbound processing.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G261](../rules/resource-and-http-lifecycles.md#g261). The linked rules apply this source to Standard library / Minor changes to the library / net/http/httputil. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.26#nethttphttputilpkgnethttphttputil).

<a id="rv486"></a>

## RV486: Standard library / Minor changes to the library / net/netip

netip.Prefix.Compare orders prefixes.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / net/netip on Go 1.26. This source records netip.Prefix.Compare orders prefixes. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.26#netnetippkgnetnetip).

<a id="rv487"></a>

## RV487: Standard library / Minor changes to the library / net/url

url.Parse rejects malformed colon-containing hosts such as unbracketed IPv6 or doubled ports. Bracketed IPv6 remains valid. urlstrictcolons=0 temporarily restores lax parsing.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G266](../rules/resource-and-http-lifecycles.md#g266). The linked rules apply this source to Standard library / Minor changes to the library / net/url. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.26#neturlpkgneturl).

<a id="rv488"></a>

## RV488: Standard library / Minor changes to the library / os

Process.WithHandle exposes pidfds on supported Linux and process handles on Windows. Windows OpenFile accepts native file flags such as OVERLAPPED/SEQUENTIAL_SCAN.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / os on Go 1.26. This source records Process.WithHandle exposes pidfds on supported Linux and process handles on Windows. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.26#ospkgos).

<a id="rv489"></a>

## RV489: Standard library / Minor changes to the library / os/signal

signal.NotifyContext supplies a cancellation cause identifying the received signal.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G252](../rules/concurrency-and-lifecycles.md#g252). The linked rules apply this source to Standard library / Minor changes to the library / os/signal. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.26#ossignalpkgossignal).

<a id="rv490"></a>

## RV490: Standard library / Minor changes to the library / reflect

reflect.Type.Fields/Methods/Ins/Outs iterate members/signatures. Value.Fields/Methods yield both member metadata and values.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / reflect on Go 1.26. This source records reflect.Type.Fields/Methods/Ins/Outs iterate members/signatures. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.26#reflectpkgreflect).

<a id="rv491"></a>

## RV491: Standard library / Minor changes to the library / runtime/metrics

Scheduler metrics expose goroutine states, known OS threads and cumulative created goroutines.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / runtime/metrics on Go 1.26. This source records Scheduler metrics expose goroutine states, known OS threads and cumulative created goroutines. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.26#runtimemetricspkgruntimemetrics).

<a id="rv492"></a>

## RV492: Standard library / Minor changes to the library / testing

T/B/F.ArtifactDir provides output directories. With -artifacts they persist under -outputdir/current directory and their location is logged; otherwise temporary artifacts are removed. B.Loop permits normal inlining while keeping call inputs/results and assigned variables alive against wholesale elimination, correcting 1.24-1.25 benchmark distortion.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G190](../rules/benchmarking.md#g190). The linked rules apply this source to Standard library / Minor changes to the library / testing. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.26#testingpkgtesting).

<a id="rv493"></a>

## RV493: Standard library / Minor changes to the library / testing/cryptotest

cryptotest.SetGlobalRandom installs deterministic crypto randomness for a test, including implicit crypto sources. Respect its global-state test restrictions.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G258](../rules/testing.md#g258), [G273](../rules/security-and-compatibility.md#g273). The linked rules apply this source to Standard library / Minor changes to the library / testing/cryptotest. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.26#testingcryptotestpkgtestingcryptotest).

<a id="rv494"></a>

## RV494: Standard library / Minor changes to the library / time

asynctimerchan removal is announced for 1.27. Timer channels will become synchronous regardless of module language version or the old switch.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / time on Go 1.26. This source records asynctimerchan removal is announced for 1.27. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.26#timepkgtime).

<a id="rv495"></a>

## RV495: Ports / Darwin

Go 1.26 is the last macOS 12 release. Go 1.27 requires macOS 13+.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / Darwin on Go 1.26. This source records Go 1.26 is the last macOS 12 release. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.26#darwin).

<a id="rv496"></a>

## RV496: Ports / FreeBSD

freebsd/riscv64 is marked broken.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / FreeBSD on Go 1.26. This source records freebsd/riscv64 is marked broken. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.26#freebsd).

<a id="rv497"></a>

## RV497: Ports / Windows

The broken 32-bit windows/arm port is removed.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / Windows on Go 1.26. This source records The broken 32-bit windows/arm port is removed. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.26#windows).

<a id="rv498"></a>

## RV498: Ports / PowerPC

Go 1.26 is the last linux/ppc64 ELFv1 release;1.27 plans ELFv2. With no external-object linking support, ordinary users are expected not to notice.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / PowerPC on Go 1.26. This source records Go 1.26 is the last linux/ppc64 ELFv1 release;1.27 plans ELFv2. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.26#powerpc).

<a id="rv499"></a>

## RV499: Ports / RISC-V

linux/riscv64 gains race detection.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / RISC-V on Go 1.26. This source records linux/riscv64 gains race detection. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.26#risc-v).

<a id="rv500"></a>

## RV500: Ports / S390X

s390x gains register argument/result passing.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / S390X on Go 1.26. This source records s390x gains register argument/result passing. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.26#s390x).

<a id="rv501"></a>

## RV501: Ports / WebAssembly

Wasm always uses sign-extension and saturating float-to-int instructions standardized by Wasm 2.0. GOWASM signext/satconv controls are ignored. Smaller heap increments reduce memory use for heaps below roughly 16 MiB.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / WebAssembly on Go 1.26. This source records Wasm always uses sign-extension and saturating float-to-int instructions standardized by Wasm 2.0. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.26#wasm).
