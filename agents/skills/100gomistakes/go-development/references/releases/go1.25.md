# Go 1.25 source reference

Status: published-stable-release. Source: [official release notes](https://go.dev/doc/go1.25).

These are versioned source summaries. The linked rules cover recurring actions. A reference disposition preserves an API or implementation detail for tasks that need it. Read later releases before applying historical defaults.

<a id="rv393"></a>

## RV393: Changes to the language

The spec replaces the core-type concept with direct descriptions. This changes exposition, not accepted program behavior.

Applicability: This changes specification wording only. The release notes identify no resulting program-behavior change or new language permission.

Disposition: release-reference. Consult when using Changes to the language on Go 1.25. This source records The spec replaces the core-type concept with direct descriptions. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#language).

<a id="rv394"></a>

## RV394: Tools / Go command

-asan enables C leak detection at exit, disabled at runtime with ASAN_OPTIONS=detect_leaks=0. Less-used go tools build on demand. go.mod ignore excludes directories from package-pattern matching but not module ZIPs. doc -http serves browser documentation. version -m -json emits BuildInfo. go-import metadata can identify a repository subdirectory module root. The work pattern selects all work-module packages. Updating the go directive no longer automatically inserts the current toolchain directive.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Tools / Go command on Go 1.25. This source records -asan enables C leak detection at exit, disabled at runtime with ASAN_OPTIONS=detect_leaks=0. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#go-command).

<a id="rv395"></a>

## RV395: Tools / Vet

vet adds waitgroup for misplaced Add calls and hostport for IPv6-unsafe address formatting. Use net.JoinHostPort instead of formatting host:port manually.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: [G139](../rules/shared-state-and-synchronization.md#g139), [G266](../rules/resource-and-http-lifecycles.md#g266). The linked rules apply this source to Tools / Vet. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.25#vet).

<a id="rv396"></a>

## RV396: Runtime / Container-aware GOMAXPROCS

On Linux, default GOMAXPROCS considers cgroup CPU bandwidth limits, not Kubernetes CPU requests. On all platforms, the runtime can periodically refresh defaults when available CPUs change, also considering changed cgroup limits on Linux. On Go 1.25+ these behaviors default on for program compatibility defaults >=1.25. For defaults <=1.24, containermaxprocs and updatemaxprocs both default to 0. Program defaults follow the active workspace or work module, with godebug and main-package //go:debug overrides. Per-file language gates do not select them. Runtime GODEBUG environment settings can override these defaults. Explicit positive GOMAXPROCS environment settings or runtime.GOMAXPROCS calls that set a value override automatic selection and disable updates. The two GODEBUG settings independently control the behaviors. Cgroup file descriptors remain cached.

Applicability: Check the toolchain, program defaults with go list -f '{{.DefaultGODEBUG}}' for the actual main package, and runtime GODEBUG overrides before relying on quota awareness or automatic updates. Linux quota awareness and updates on all platforms are distinct. Exact default selection also considers CPU affinity; consult runtime documentation for quota rounding and the minimum rule.

Disposition: [G115](../rules/concurrency-and-lifecycles.md#g115), [G227](../rules/performance-and-diagnostics.md#g227), [G228](../rules/performance-and-diagnostics.md#g228). The linked rules apply this source to Runtime / Container-aware GOMAXPROCS. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.25#container-aware-gomaxprocs), [source 2](https://pkg.go.dev/runtime#GOMAXPROCS), [program GODEBUG defaults](https://go.dev/doc/godebug#default).

<a id="rv397"></a>

## RV397: Runtime / New experimental garbage collector

GOEXPERIMENT=greenteagc previews locality/scalability improvements for scanning small objects, with expected 10-40% GC-overhead reductions on GC-heavy workloads. It is not the default collector yet.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: [G269](../rules/performance-and-diagnostics.md#g269). The linked rules apply this source to Runtime / New experimental garbage collector. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.25#new-experimental-garbage-collector).

<a id="rv398"></a>

## RV398: Runtime / Trace flight recorder

trace.FlightRecorder keeps recent events in a configurable in-memory ring. WriteTo snapshots the relevant interval after a rare event, avoiding continuous large trace files. FlightRecorderConfig controls time/data retention.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: [G270](../rules/performance-and-diagnostics.md#g270). The linked rules apply this source to Runtime / Trace flight recorder. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.25#trace-flight-recorder).

<a id="rv399"></a>

## RV399: Runtime / Change to unhandled panic output

Unhandled recovered-and-repanicked output no longer repeats the panic value text. Log parsers must not depend on the old formatting.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: release-reference. Consult when using Runtime / Change to unhandled panic output on Go 1.25. This source records Unhandled recovered-and-repanicked output no longer repeats the panic value text. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#change-to-unhandled-panic-output).

<a id="rv400"></a>

## RV400: Runtime / VMA names on Linux

Linux CONFIG_ANON_VMA_NAME systems label runtime mappings by purpose, such as Go heap. decoratemappings=0 disables labels.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: release-reference. Consult when using Runtime / VMA names on Linux on Go 1.25. This source records Linux CONFIG_ANON_VMA_NAME systems label runtime mappings by purpose, such as Go heap. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#vma-names-on-linux).

<a id="rv401"></a>

## RV401: Compiler / nil pointer bug

The compiler fixes delayed nil checks introduced in 1.21: dereferencing a failed result before checking its error now correctly panics. Check errors immediately before using results rather than depending on reordered checks.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Compiler / nil pointer bug on Go 1.25. This source records The compiler fixes delayed nil checks introduced in 1.21: dereferencing a failed result before checking its error now correctly panics. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#nil-pointer-bug).

<a id="rv402"></a>

## RV402: Compiler / DWARF5 support

DWARF 5 reduces debug data and link costs. nodwarf5 temporarily restores older output for incompatible tools.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Compiler / DWARF5 support on Go 1.25. This source records DWARF 5 reduces debug data and link costs. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#dwarf5-support).

<a id="rv403"></a>

## RV403: Compiler / Faster slices

More slice backing arrays stay on the stack. Incorrect unsafe pointer lifetimes can become visible. bisect -compile=variablemake identifies affected allocations and -d=variablemakehash=n disables new stack placement for diagnosis.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G271](../rules/performance-and-diagnostics.md#g271). The linked rules apply this source to Compiler / Faster slices. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.25#faster-slices).

<a id="rv404"></a>

## RV404: Linker

Linker -funcalign=N selects function-entry alignment; defaults are unchanged.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Linker on Go 1.25. This source records Linker -funcalign=N selects function-entry alignment; defaults are unchanged. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#linker).

<a id="rv405"></a>

## RV405: Standard library / New testing/synctest package

testing/synctest is supported with Test and Wait. A bubble virtualizes time and advances when all goroutines are durably blocked. The 1.24 Run API survives only under the old experiment and is scheduled for 1.26 removal.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G247](../rules/versions-and-tooling.md#g247), [G257](../rules/testing.md#g257). The linked rules apply this source to Standard library / New testing/synctest package. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.25#new-testingsynctest-package).

<a id="rv406"></a>

## RV406: Standard library / New experimental encoding/json/v2 package

GOEXPERIMENT=jsonv2 enables experimental encoding/json/v2 and lower-level jsontext. Legacy encoding/json uses the new engine with its behavior preserved except possible error text and exposes compatibility options. Decoding often accelerates substantially. APIs remain subject to change; do not present this as stable 1.25 JSONv2.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G247](../rules/versions-and-tooling.md#g247), [G260](../rules/time-and-serialization.md#g260). The linked rules apply this source to Standard library / New experimental encoding/json/v2 package. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.25#json_v2).

<a id="rv407"></a>

## RV407: Standard library / Minor changes to the library / archive/tar

tar.Writer.AddFS preserves symlinks from ReadLinkFS implementations.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / archive/tar on Go 1.25. This source records tar.Writer.AddFS preserves symlinks from ReadLinkFS implementations. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#archivetarpkgarchivetar).

<a id="rv408"></a>

## RV408: Standard library / Minor changes to the library / encoding/asn1

ASN1 T61String/BMPString parsing becomes consistent and rejects some malformed encodings accepted earlier.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / encoding/asn1 on Go 1.25. This source records ASN1 T61String/BMPString parsing becomes consistent and rejects some malformed encodings accepted earlier. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#encodingasn1pkgencodingasn1).

<a id="rv409"></a>

## RV409: Standard library / Minor changes to the library / crypto

crypto.MessageSigner supports signers that hash whole messages themselves. SignMessage adapts MessageSigner or legacy Signer. Changing fips140 after startup becomes a no-op rather than a possible panic. SHA1/SHA256/SHA512 slow on amd64 without AVX2.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto on Go 1.25. This source records crypto.MessageSigner supports signers that hash whole messages themselves. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#cryptopkgcrypto).

<a id="rv410"></a>

## RV410: Standard library / Minor changes to the library / crypto/ecdsa

ECDSA ParseRawPrivateKey/ParseUncompressedPublicKey and key Bytes methods replace low-level elliptic/big-number encodings. FIPS signing accelerates to non-FIPS performance.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/ecdsa on Go 1.25. This source records ECDSA ParseRawPrivateKey/ParseUncompressedPublicKey and key Bytes methods replace low-level elliptic/big-number encodings. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#cryptoecdsapkgcryptoecdsa).

<a id="rv411"></a>

## RV411: Standard library / Minor changes to the library / crypto/ed25519

Ed25519 FIPS signing accelerates to non-FIPS performance.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/ed25519 on Go 1.25. This source records Ed25519 FIPS signing accelerates to non-FIPS performance. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#cryptoed25519pkgcryptoed25519).

<a id="rv412"></a>

## RV412: Standard library / Minor changes to the library / crypto/elliptic

Undocumented elliptic Inverse and CombinedMult methods are removed.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/elliptic on Go 1.25. This source records Undocumented elliptic Inverse and CombinedMult methods are removed. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#cryptoellipticpkgcryptoelliptic).

<a id="rv413"></a>

## RV413: Standard library / Minor changes to the library / crypto/rsa

RSA modulus secrecy is no longer promised: public operations may expose public inputs and the modulus is mathematically recoverable. Key generation becomes roughly three times faster.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/rsa on Go 1.25. This source records RSA modulus secrecy is no longer promised: public operations may expose public inputs and the modulus is mathematically recoverable. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#cryptorsapkgcryptorsa).

<a id="rv414"></a>

## RV414: Standard library / Minor changes to the library / crypto/sha1

SHA1 hashing roughly doubles on amd64 with SHA-NI, without changing its security status.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/sha1 on Go 1.25. This source records SHA1 hashing roughly doubles on amd64 with SHA-NI, without changing its security status. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#cryptosha1pkgcryptosha1).

<a id="rv415"></a>

## RV415: Standard library / Minor changes to the library / crypto/sha3

SHA3.Clone implements hash.Cloner. Apple M-series hashing roughly doubles in speed.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/sha3 on Go 1.25. This source records SHA3.Clone implements hash.Cloner. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#cryptosha3pkgcryptosha3).

<a id="rv416"></a>

## RV416: Standard library / Minor changes to the library / crypto/tls

TLS ConnectionState.CurveID reports key exchange. GetEncryptedClientHelloKeys dynamically supplies server ECH keys. TLS 1.2 forbids SHA1 signatures by default, with tlssha1=1 escape. FIPS TLS 1.2 requires Extended Master Secret and permits Ed25519/X25519MLKEM768. Servers choose the highest supported version and both sides reject more noncompliant peers.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G275](../rules/security-and-compatibility.md#g275). The linked rules apply this source to Standard library / Minor changes to the library / crypto/tls. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.25#cryptotlspkgcryptotls).

<a id="rv417"></a>

## RV417: Standard library / Minor changes to the library / crypto/x509

x509 creation accepts MessageSigner for one-shot hashing/signing. Missing SubjectKeyId uses truncated SHA256, with x509sha256skid=0 restoring SHA1. Negative pathLenConstraint and malformed T61/BMP encodings are rejected.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/x509 on Go 1.25. This source records x509 creation accepts MessageSigner for one-shot hashing/signing. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#cryptox509pkgcryptox509).

<a id="rv418"></a>

## RV418: Standard library / Minor changes to the library / debug/elf

ELF adds PT_RISCV_ATTRIBUTES and SHT_RISCV_ATTRIBUTES.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / debug/elf on Go 1.25. This source records ELF adds PT_RISCV_ATTRIBUTES and SHT_RISCV_ATTRIBUTES. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#debugelfpkgdebugelf).

<a id="rv419"></a>

## RV419: Standard library / Minor changes to the library / go/ast

ast FilterPackage/PackageExports/MergePackageFiles/MergeMode are deprecated with old syntactic resolution. PreorderStack adds controllable traversal with enclosing-node stacks.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G277](../rules/versions-and-tooling.md#g277). The linked rules apply this source to Standard library / Minor changes to the library / go/ast. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.25#goastpkggoast).

<a id="rv420"></a>

## RV420: Standard library / Minor changes to the library / go/parser

parser.ParseDir is deprecated.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G277](../rules/versions-and-tooling.md#g277). The linked rules apply this source to Standard library / Minor changes to the library / go/parser. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.25#goparserpkggoparser).

<a id="rv421"></a>

## RV421: Standard library / Minor changes to the library / go/token

token.FileSet.AddExistingFiles reuses existing file metadata across selected FileSets, helping long-lived tools avoid a global accumulator.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / go/token on Go 1.25. This source records token.FileSet.AddExistingFiles reuses existing file metadata across selected FileSets, helping long-lived tools avoid a global accumulator. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#gotokenpkggotoken).

<a id="rv422"></a>

## RV422: Standard library / Minor changes to the library / go/types

types.Var.Kind classifies package/receiver/parameter/result/local/field variables. LookupSelection returns a Selection for a field/method lookup.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / go/types on Go 1.25. This source records types.Var.Kind classifies package/receiver/parameter/result/local/field variables. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#gotypespkggotypes).

<a id="rv423"></a>

## RV423: Standard library / Minor changes to the library / hash

hash.XOF describes extendable-output hashes. Cloner copies hash state and all standard Hash implementations implement it.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / hash on Go 1.25. This source records hash.XOF describes extendable-output hashes. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#hashpkghash).

<a id="rv424"></a>

## RV424: Standard library / Minor changes to the library / hash/maphash

maphash.Hash.Clone implements hash.Cloner.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / hash/maphash on Go 1.25. This source records maphash.Hash.Clone implements hash.Cloner. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#hashmaphashpkghashmaphash).

<a id="rv425"></a>

## RV425: Standard library / Minor changes to the library / io/fs

fs.ReadLinkFS exposes filesystem symlink reading.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / io/fs on Go 1.25. This source records fs.ReadLinkFS exposes filesystem symlink reading. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#iofspkgiofs).

<a id="rv426"></a>

## RV426: Standard library / Minor changes to the library / log/slog

slog.GroupAttrs builds a group from []Attr. Record.Source reports source location or nil.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / log/slog on Go 1.25. This source records slog.GroupAttrs builds a group from []Attr. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#logslogpkglogslog).

<a id="rv427"></a>

## RV427: Standard library / Minor changes to the library / mime/multipart

multipart.FileContentDisposition constructs a file-part Content-Disposition value.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / mime/multipart on Go 1.25. This source records multipart.FileContentDisposition constructs a file-part Content-Disposition value. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#mimemultipartpkgmimemultipart).

<a id="rv428"></a>

## RV428: Standard library / Minor changes to the library / net

MX lookup retains IP-looking DNS names used by real servers despite RFC expectations. Windows multicast UDP supports IPv6. Windows FileConn/FilePacketConn/FileListener and connection/listener File methods convert between socket files and net objects.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / net on Go 1.25. This source records MX lookup retains IP-looking DNS names used by real servers despite RFC expectations. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#netpkgnet).

<a id="rv429"></a>

## RV429: Standard library / Minor changes to the library / net/http

http.CrossOriginProtection rejects unsafe cross-origin browser requests using Fetch metadata, without token/cookie requirements. Origin/pattern bypasses must be configured deliberately; it is a specific CSRF defense, not general authentication.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G263](../rules/resource-and-http-lifecycles.md#g263). The linked rules apply this source to Standard library / Minor changes to the library / net/http. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.25#nethttppkgnethttp).

<a id="rv430"></a>

## RV430: Standard library / Minor changes to the library / os

Windows NewFile associates overlapped handles with runtime IOCP, enabling nonblocking-thread I/O and deadlines. Handles already owned by another completion port fall back to synchronous blocking with no deadlines. DirFS/Root.FS implement ReadLinkFS and CopyFS preserves supported symlinks. Root adds Chmod/Chown/Chtimes/Lchown/Link/MkdirAll/ReadFile/Readlink/RemoveAll/Rename/Symlink/WriteFile.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G264](../rules/resource-and-http-lifecycles.md#g264). The linked rules apply this source to Standard library / Minor changes to the library / os. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.25#ospkgos).

<a id="rv431"></a>

## RV431: Standard library / Minor changes to the library / reflect

reflect.TypeAssert[T] converts Value directly to T with fewer unnecessary allocations than Interface plus assertion.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / reflect on Go 1.25. This source records reflect.TypeAssert[T] converts Value directly to T with fewer unnecessary allocations than Interface plus assertion. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#reflectpkgreflect).

<a id="rv432"></a>

## RV432: Standard library / Minor changes to the library / regexp/syntax

Regexp Unicode classes add Any/ASCII/Assigned/Cn/LC and aliases such as Letter. Lookup ignores case, spaces, underscores and hyphens under Unicode TR18 rules.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / regexp/syntax on Go 1.25. This source records Regexp Unicode classes add Any/ASCII/Assigned/Cn/LC and aliases such as Letter. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#regexpsyntaxpkgregexpsyntax).

<a id="rv433"></a>

## RV433: Standard library / Minor changes to the library / runtime

AddCleanup callbacks run concurrently/in parallel, but long blocking work should still move off the cleanup queue. checkfinalizers=1 diagnoses lifecycle mistakes and prints queue lengths. SetDefaultGOMAXPROCS restores runtime-managed defaults after explicit overrides.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: [G115](../rules/concurrency-and-lifecycles.md#g115), [G227](../rules/performance-and-diagnostics.md#g227), [G228](../rules/performance-and-diagnostics.md#g228), [G267](../rules/performance-and-diagnostics.md#g267). The linked rules apply this source to Standard library / Minor changes to the library / runtime. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.25#runtimepkgruntime).

<a id="rv434"></a>

## RV434: Standard library / Minor changes to the library / runtime/pprof

Runtime-lock mutex profiles now point to the end of the delaying critical section, matching sync.Mutex. runtimecontentionstacks is removed.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: [G219](../rules/performance-and-diagnostics.md#g219). The linked rules apply this source to Standard library / Minor changes to the library / runtime/pprof. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.25#runtimepprofpkgruntimepprof).

<a id="rv435"></a>

## RV435: Standard library / Minor changes to the library / sync

WaitGroup.Go combines goroutine creation with counting, reducing Add/start ordering mistakes. Its function must obey the documented no-panic contract.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G139](../rules/shared-state-and-synchronization.md#g139). The linked rules apply this source to Standard library / Minor changes to the library / sync. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.25#syncpkgsync).

<a id="rv436"></a>

## RV436: Standard library / Minor changes to the library / testing

T/B/F.Attr emit metadata and test JSON gains attr events. Output returns an indented test-log writer without file/line prefixes. AllocsPerRun panics during parallel tests because concurrent activity invalidates its measurement.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G258](../rules/testing.md#g258). The linked rules apply this source to Standard library / Minor changes to the library / testing. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.25#testingpkgtesting).

<a id="rv437"></a>

## RV437: Standard library / Minor changes to the library / testing/fstest

fstest.MapFS implements ReadLinkFS; TestFS checks it when present and stops following symlinks to avoid recursion.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / testing/fstest on Go 1.25. This source records fstest.MapFS implements ReadLinkFS; TestFS checks it when present and stops following symlinks to avoid recursion. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#testingfstestpkgtestingfstest).

<a id="rv438"></a>

## RV438: Standard library / Minor changes to the library / unicode

unicode.CategoryAliases exposes long names. New Cn (unassigned) and LC (cased letters) complete missing categories; C now includes unassigned code points.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / unicode on Go 1.25. This source records unicode.CategoryAliases exposes long names. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#unicodepkgunicode).

<a id="rv439"></a>

## RV439: Standard library / Minor changes to the library / unique

unique reclaims unused values more eagerly and in parallel. Nested Handle chains can collect in one GC cycle rather than one cycle per depth.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / unique on Go 1.25. This source records unique reclaims unused values more eagerly and in parallel. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#uniquepkgunique).

<a id="rv440"></a>

## RV440: Ports / Darwin

macOS 12+ is required.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / Darwin on Go 1.25. This source records macOS 12+ is required. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#darwin).

<a id="rv441"></a>

## RV441: Ports / Windows

Go 1.25 is the final release containing the broken windows/arm port. Removal is announced for 1.26.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / Windows on Go 1.25. This source records Go 1.25 is the final release containing the broken windows/arm port. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#windows).

<a id="rv442"></a>

## RV442: Ports / AMD64

GOAMD64=v3+ uses fused multiply-add, which can change exact floating-point results. Explicit rounding such as float64(a*b)+c prevents fusion.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / AMD64 on Go 1.25. This source records GOAMD64=v3+ uses fused multiply-add, which can change exact floating-point results. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#amd64).

<a id="rv443"></a>

## RV443: Ports / Loong64

linux/loong64 gains race detection, SetCgoTraceback and internal cgo linking.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / Loong64 on Go 1.25. This source records linux/loong64 gains race detection, SetCgoTraceback and internal cgo linking. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#loong64).

<a id="rv444"></a>

## RV444: Ports / RISC-V

linux/riscv64 supports plugins. GORISCV64 accepts rva23u64.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / RISC-V on Go 1.25. This source records linux/riscv64 supports plugins. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.25#risc-v).
