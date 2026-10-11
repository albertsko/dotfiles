# Go 1.24 source reference

Status: published-stable-release. Source: [official release notes](https://go.dev/doc/go1.24).

These are versioned source summaries. The linked rules cover recurring actions. A reference disposition preserves an API or implementation detail for tasks that need it. Read later releases before applying historical defaults.

<a id="rv332"></a>

## RV332: Changes to the language

Generic type aliases are fully supported, including cross-package use. noaliastypeparams temporarily disables the feature; removal of that control is announced for 1.25.

Applicability: Generic aliases require Go 1.24 language support. In this release the build-time noaliastypeparams control can still disable implementation support; its planned removal is a separate transition.

Disposition: [G248](../rules/code-and-api-design.md#g248). The linked rules apply this source to Changes to the language. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.24#language).

<a id="rv333"></a>

## RV333: Tools / Go command

go.mod tool directives track executable dependencies, replacing tools.go blank-import workarounds. go get -tool adds them, go tool runs them, and the tool meta-pattern upgrades/installs all. run/tool executables are cached, trading disk for speed. build/install -json and test -json expose build events; gotestjsonbuildtext=1 restores text build output for older consumers. GOAUTH authenticates private fetches. Main-module binary versions derive from VCS tags/commits plus +dirty, disabled with -buildvcs=false. toolchaintrace=1 explains selection.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: [G244](../rules/versions-and-tooling.md#g244). The linked rules apply this source to Tools / Go command. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.24#go-command).

<a id="rv334"></a>

## RV334: Tools / Cgo

#cgo noescape and nocallback annotations permit optimizations only when C truly does not retain pointers or call Go. Incorrect promises violate their contracts. cgo more reliably detects conflicting C declarations across files.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Tools / Cgo on Go 1.24. This source records #cgo noescape and nocallback annotations permit optimizations only when C truly does not retain pointers or call Go. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#cgo).

<a id="rv335"></a>

## RV335: Tools / Objdump

objdump disassembles loong64, riscv64 and s390x.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Tools / Objdump on Go 1.24. This source records objdump disassembles loong64, riscv64 and s390x. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#objdump).

<a id="rv336"></a>

## RV336: Tools / Vet

vet tests checks test/fuzz/benchmark/example names, signatures and referenced identifiers, including during go test. printf flags nonconstant format-only calls for language 1.24+ files. buildtag rejects patch-version constraints. copylock catches per-iteration copies of lock-containing three-clause-loop variables under 1.22 semantics.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: [G144](../rules/shared-state-and-synchronization.md#g144). The linked rules apply this source to Tools / Vet. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.24#vet).

<a id="rv337"></a>

## RV337: Tools / GOCACHEPROG

GOCACHEPROG becomes supported rather than experimental. A child process implements the JSON protocol for build/test caching.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Tools / GOCACHEPROG on Go 1.24. This source records GOCACHEPROG becomes supported rather than experimental. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#gocacheprog).

<a id="rv338"></a>

## RV338: Runtime

Swiss-table builtin maps, small-object allocation and runtime mutex changes reduce measured average CPU overhead 2-3%. noswissmap/nospinbitmutex temporarily select older implementations. Benchmark the actual workload.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: [G62](../rules/collections-and-ownership.md#g62), [G269](../rules/performance-and-diagnostics.md#g269). The linked rules apply this source to Runtime. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.24#runtime).

<a id="rv339"></a>

## RV339: Compiler

Methods on cgo-generated receiver types are rejected even through aliases, closing a loophole.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Compiler on Go 1.24. This source records Methods on cgo-generated receiver types are rejected even through aliases, closing a loophole. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#compiler).

<a id="rv340"></a>

## RV340: Linker

ELF GNU build IDs and Mach-O UUIDs are generated from Go build IDs by default. -B none disables them and -B 0x... supplies a value.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Linker on Go 1.24. This source records ELF GNU build IDs and Mach-O UUIDs are generated from Go build IDs by default. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#linker).

<a id="rv341"></a>

## RV341: Bootstrap

Bootstrap requires Go 1.22.6+. A 1.24 point-release requirement for 1.26 is a plan here.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Bootstrap on Go 1.24. This source records Bootstrap requires Go 1.22.6+. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#bootstrap).

<a id="rv342"></a>

## RV342: Standard library / Directory-limited filesystem access

os.OpenRoot/os.Root provide directory-confined filesystem operations such as Open/Create/Mkdir/Stat. Paths cannot escape the root, including through outward symlinks. This is stronger than lexical path checking, subject to platform/API limitations.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G264](../rules/resource-and-http-lifecycles.md#g264). The linked rules apply this source to Standard library / Directory-limited filesystem access. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.24#directory-limited-filesystem-access).

<a id="rv343"></a>

## RV343: Standard library / New benchmark function

testing.B.Loop runs benchmark setup/cleanup once per count and keeps call parameters/results alive against total elimination. Use the prescribed for b.Loop() form; later releases adjust optimization behavior.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G188](../rules/benchmarking.md#g188), [G190](../rules/benchmarking.md#g190). The linked rules apply this source to Standard library / New benchmark function. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.24#new-benchmark-function).

<a id="rv344"></a>

## RV344: Standard library / Improved finalizers

runtime.AddCleanup attaches cleanup after unreachability, supporting multiple callbacks, interior pointers and cycles more flexibly than SetFinalizer without delaying object release. Prefer it for new GC-triggered cleanup, while explicit resource lifetime remains separate.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G267](../rules/performance-and-diagnostics.md#g267). The linked rules apply this source to Standard library / Improved finalizers. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.24#improved-finalizers).

<a id="rv345"></a>

## RV345: Standard library / New weak package

weak pointers enable caches, weak maps and canonicalization without retaining referents. They complement AddCleanup and maphash.Comparable and are low-level lifecycle primitives.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G267](../rules/performance-and-diagnostics.md#g267). The linked rules apply this source to Standard library / New weak package. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.24#weak).

<a id="rv346"></a>

## RV346: Standard library / New crypto/mlkem package

crypto/mlkem implements standardized ML-KEM-768/1024 (FIPS 203), distinct from draft Kyber.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / New crypto/mlkem package on Go 1.24. This source records crypto/mlkem implements standardized ML-KEM-768/1024 (FIPS 203), distinct from draft Kyber. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#crypto-mlkem).

<a id="rv347"></a>

## RV347: Standard library / New crypto/hkdf, crypto/pbkdf2, and crypto/sha3 packages

crypto/hkdf, pbkdf2 and sha3 move established x/crypto functionality into the standard library: HKDF, PBKDF2, SHA3 and SHAKE/cSHAKE.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / New crypto/hkdf, crypto/pbkdf2, and crypto/sha3 packages on Go 1.24. This source records crypto/hkdf, pbkdf2 and sha3 move established x/crypto functionality into the standard library: HKDF, PBKDF2, SHA3 and SHAKE/cSHAKE. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#crypto-packages).

<a id="rv348"></a>

## RV348: Standard library / FIPS 140-3 compliance

The Go Cryptographic Module transparently supplies approved algorithms. GOFIPS140 chooses its build version and fips140 enables runtime mode. Included v1.0.0 is under laboratory testing in these notes, not yet a claim of completed validation.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G274](../rules/security-and-compatibility.md#g274). The linked rules apply this source to Standard library / FIPS 140-3 compliance. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.24#fips140).

<a id="rv349"></a>

## RV349: Standard library / New experimental testing/synctest package

Experimental testing/synctest requires GOEXPERIMENT=synctest. Run creates a goroutine bubble with fake time; Wait waits until bubble goroutines block. The API is explicitly unstable and later stable Test usage must be version-separated.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G247](../rules/versions-and-tooling.md#g247), [G257](../rules/testing.md#g257). The linked rules apply this source to Standard library / New experimental testing/synctest package. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.24#testing-synctest).

<a id="rv350"></a>

## RV350: Standard library / Minor changes to the library / archive

tar/zip Writer.AddFS emits headers for empty directories.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / archive on Go 1.24. This source records tar/zip Writer.AddFS emits headers for empty directories. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#archivepkgarchive).

<a id="rv351"></a>

## RV351: Standard library / Minor changes to the library / bytes

bytes.Lines/SplitSeq/SplitAfterSeq/FieldsSeq/FieldsFuncSeq provide lazy line, separator and Unicode-whitespace/predicate iteration over subslices.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G250](../rules/iteration-and-control-flow.md#g250). The linked rules apply this source to Standard library / Minor changes to the library / bytes. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.24#bytespkgbytes).

<a id="rv352"></a>

## RV352: Standard library / Minor changes to the library / crypto/aes

AES blocks stop exposing undocumented NewCTR/NewGCM/NewCBCEncrypter/NewCBCDecrypter methods. Pass blocks to crypto/cipher instead. cipher still recognizes these hooks on external blocks for now.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/aes on Go 1.24. This source records AES blocks stop exposing undocumented NewCTR/NewGCM/NewCBCEncrypter/NewCBCDecrypter methods. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#cryptoaespkgcryptoaes).

<a id="rv353"></a>

## RV353: Standard library / Minor changes to the library / crypto/cipher

cipher.NewGCMWithRandomNonce generates and prefixes nonces. AES-CTR accelerates on amd64/arm64. OFB/CFB constructors are deprecated because unauthenticated encryption permits active attacks. Prefer AEAD, or CTR when a separate requirement truly needs an unauthenticated stream.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G274](../rules/security-and-compatibility.md#g274). The linked rules apply this source to Standard library / Minor changes to the library / crypto/cipher. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.24#cryptocipherpkgcryptocipher).

<a id="rv354"></a>

## RV354: Standard library / Minor changes to the library / crypto/ecdsa

ECDSA PrivateKey.Sign with nil randomness produces RFC 6979 deterministic signatures.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/ecdsa on Go 1.24. This source records ECDSA PrivateKey.Sign with nil randomness produces RFC 6979 deterministic signatures. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#cryptoecdsapkgcryptoecdsa).

<a id="rv355"></a>

## RV355: Standard library / Minor changes to the library / crypto/md5

md5 hash state implements BinaryAppender. This serialization feature does not make MD5 secure.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G274](../rules/security-and-compatibility.md#g274). The linked rules apply this source to Standard library / Minor changes to the library / crypto/md5. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.24#cryptomd5pkgcryptomd5).

<a id="rv356"></a>

## RV356: Standard library / Minor changes to the library / crypto/rand

crypto/rand.Read returns a nil error after success and irrecoverably terminates on Reader failure. Overridden Readers and pre-3.17 Linux /dev/urandom failures can expose that fatal path. Linux 6.11+ uses faster vDSO getrandom, OpenBSD uses arc4random_buf, and Text generates secure random strings.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G273](../rules/security-and-compatibility.md#g273). The linked rules apply this source to Standard library / Minor changes to the library / crypto/rand. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.24#cryptorandpkgcryptorand).

<a id="rv357"></a>

## RV357: Standard library / Minor changes to the library / crypto/rsa

RSA operations reject keys below 1024 bits; rsa1024min=0 is a compatibility escape mainly for tests. Precompute is safe before Validate and handles partially cached keys faster. More malformed keys/random sources fail, and supplied prime/CRT data is validated. PKCS1v15 supports SHA512/224, SHA512/256 and SHA3. Generation uses Carmichael rather than Euler totients, yielding potentially different compatible exponents. wasm key operations accelerate.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/rsa on Go 1.24. This source records RSA operations reject keys below 1024 bits; rsa1024min=0 is a compatibility escape mainly for tests. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#cryptorsapkgcryptorsa).

<a id="rv358"></a>

## RV358: Standard library / Minor changes to the library / crypto/sha1

sha1 hash state implements BinaryAppender without changing SHA1's security limitations.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G274](../rules/security-and-compatibility.md#g274). The linked rules apply this source to Standard library / Minor changes to the library / crypto/sha1. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.24#cryptosha1pkgcryptosha1).

<a id="rv359"></a>

## RV359: Standard library / Minor changes to the library / crypto/sha256

sha256.New/New224 states implement BinaryAppender.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/sha256 on Go 1.24. This source records sha256.New/New224 states implement BinaryAppender. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#cryptosha256pkgcryptosha256).

<a id="rv360"></a>

## RV360: Standard library / Minor changes to the library / crypto/sha512

SHA512-family hash states implement BinaryAppender.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/sha512 on Go 1.24. This source records SHA512-family hash states implement BinaryAppender. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#cryptosha512pkgcryptosha512).

<a id="rv361"></a>

## RV361: Standard library / Minor changes to the library / crypto/subtle

subtle.WithDataIndependentTiming enables architecture timing guarantees (arm64 DIT; otherwise no-op), while dataindependenttiming=1 enables DIT globally. It supports already constant-time code rather than converting arbitrary code. XORBytes panics on partial overlap; exact overlap or disjoint buffers are required.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/subtle on Go 1.24. This source records subtle.WithDataIndependentTiming enables architecture timing guarantees (arm64 DIT; otherwise no-op), while dataindependenttiming=1 enables DIT globally. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#cryptosubtlepkgcryptosubtle).

<a id="rv362"></a>

## RV362: Standard library / Minor changes to the library / crypto/tls

TLS servers support ECH through EncryptedClientHelloKeys. Default X25519MLKEM768 replaces draft X25519Kyber768Draft00; tlsmlkem=0 restores earlier default selection for incompatible peers. Draft Kyber and tlskyber are removed. CurvePreferences selects enabled groups but its order is ignored. ClientHelloInfo.Extensions exposes received extension IDs.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G275](../rules/security-and-compatibility.md#g275). The linked rules apply this source to Standard library / Minor changes to the library / crypto/tls. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.24#cryptotlspkgcryptotls).

<a id="rv363"></a>

## RV363: Standard library / Minor changes to the library / crypto/x509

x509sha1 is removed and certificate verification no longer accepts SHA1 signatures. OID implements append interfaces. Certificate creation uses Policies by default, with x509usepolicies=0 restoring PolicyIdentifiers; parsing fills both. Nil serials are generated automatically. VerifyOptions.CertificatePolicies enables policy-graph validation. PKCS8 marshaling rejects invalid RSA keys; PKCS1's invalid-key behavior remains undefined. PKCS1/PKCS8 parsing validates encoded CRT data, with x509rsacrt=0 restoring recomputation.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G275](../rules/security-and-compatibility.md#g275). The linked rules apply this source to Standard library / Minor changes to the library / crypto/x509. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.24#cryptox509pkgcryptox509).

<a id="rv364"></a>

## RV364: Standard library / Minor changes to the library / debug/elf

ELF DynamicVersions/DynamicVersionNeeds and Symbol.HasVersion/VersionIndex expose symbol-version definitions, requirements and associations.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / debug/elf on Go 1.24. This source records ELF DynamicVersions/DynamicVersionNeeds and Symbol.HasVersion/VersionIndex expose symbol-version definitions, requirements and associations. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#debugelfpkgdebugelf).

<a id="rv365"></a>

## RV365: Standard library / Minor changes to the library / encoding

encoding.TextAppender/BinaryAppender append representations into caller buffers, complementing allocating marshaler interfaces. Corresponding standard-library types adopt them.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / encoding on Go 1.24. This source records encoding.TextAppender/BinaryAppender append representations into caller buffers, complementing allocating marshaler interfaces. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#encodingpkgencoding).

<a id="rv366"></a>

## RV366: Standard library / Minor changes to the library / encoding/json

JSON omitzero omits values using IsZero when available or the type's zero value, including zero time.Time. Combined omitempty/omitzero omits either condition. UnmarshalTypeError.Field includes embedded-struct paths.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G259](../rules/time-and-serialization.md#g259). The linked rules apply this source to Standard library / Minor changes to the library / encoding/json. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.24#encodingjsonpkgencodingjson).

<a id="rv367"></a>

## RV367: Standard library / Minor changes to the library / go/types

go/types adds sequence iterators: Interface.EmbeddedTypes/ExplicitMethods/Methods, MethodSet.Methods, Named.Methods, Scope.Children, Struct.Fields, Tuple.Variables, TypeList.Types, TypeParamList.TypeParams and Union.Terms.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / go/types on Go 1.24. This source records go/types adds sequence iterators: Interface.EmbeddedTypes/ExplicitMethods/Methods, MethodSet.Methods, Named.Methods, Scope.Children, Struct.Fields, Tuple.Variables, TypeList.Types, TypeParamList.TypeParams and Union.Terms. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#gotypespkggotypes).

<a id="rv368"></a>

## RV368: Standard library / Minor changes to the library / hash/adler32

adler32 states implement BinaryAppender.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / hash/adler32 on Go 1.24. This source records adler32 states implement BinaryAppender. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#hashadler32pkghashadler32).

<a id="rv369"></a>

## RV369: Standard library / Minor changes to the library / hash/crc32

crc32 New/NewIEEE states implement BinaryAppender.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / hash/crc32 on Go 1.24. This source records crc32 New/NewIEEE states implement BinaryAppender. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#hashcrc32pkghashcrc32).

<a id="rv370"></a>

## RV370: Standard library / Minor changes to the library / hash/crc64

crc64 states implement BinaryAppender.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / hash/crc64 on Go 1.24. This source records crc64 states implement BinaryAppender. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#hashcrc64pkghashcrc64).

<a id="rv371"></a>

## RV371: Standard library / Minor changes to the library / hash/fnv

FNV32/32a/64/64a/128/128a states implement BinaryAppender.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / hash/fnv on Go 1.24. This source records FNV32/32a/64/64a/128/128a states implement BinaryAppender. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#hashfnvpkghashfnv).

<a id="rv372"></a>

## RV372: Standard library / Minor changes to the library / hash/maphash

maphash.Comparable/WriteComparable hash values usable as map keys, supporting custom generic hashed structures.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / hash/maphash on Go 1.24. This source records maphash.Comparable/WriteComparable hash values usable as map keys, supporting custom generic hashed structures. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#hashmaphashpkghashmaphash).

<a id="rv373"></a>

## RV373: Standard library / Minor changes to the library / log/slog

slog.DiscardHandler is always disabled and discards records. Level/LevelVar implement TextAppender.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / log/slog on Go 1.24. This source records slog.DiscardHandler is always disabled and discards records. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#logslogpkglogslog).

<a id="rv374"></a>

## RV374: Standard library / Minor changes to the library / math/big

big.Float/Int/Rat implement TextAppender.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / math/big on Go 1.24. This source records big.Float/Int/Rat implement TextAppender. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#mathbigpkgmathbig).

<a id="rv375"></a>

## RV375: Standard library / Minor changes to the library / math/rand

Top-level math/rand.Seed becomes a no-op. randseednop=0 temporarily restores it; deterministic code should own a seeded generator.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G254](../rules/security-and-compatibility.md#g254). The linked rules apply this source to Standard library / Minor changes to the library / math/rand. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.24#mathrandpkgmathrand).

<a id="rv376"></a>

## RV376: Standard library / Minor changes to the library / math/rand/v2

rand/v2.ChaCha8 and PCG implement BinaryAppender.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / math/rand/v2 on Go 1.24. This source records rand/v2.ChaCha8 and PCG implement BinaryAppender. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#mathrandv2pkgmathrandv2).

<a id="rv377"></a>

## RV377: Standard library / Minor changes to the library / net

ListenConfig defaults to MPTCP where supported (currently Linux). IP implements TextAppender.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / net on Go 1.24. This source records ListenConfig defaults to MPTCP where supported (currently Linux). It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#netpkgnet).

<a id="rv378"></a>

## RV378: Standard library / Minor changes to the library / net/http

Transport bounds aggregate 1xx header bytes using MaxResponseHeaderBytes rather than a five-response count. A Got1xxResponse hook removes the total-count limit and can abort itself. Transport/Server HTTP2 fields expose protocol settings. Protocols controls HTTP1/HTTP2, including unencrypted HTTP2 prior knowledge. A server can accept both on one cleartext port; a client uses cleartext HTTP2 only when HTTP1 is disabled. h2c Upgrade is unsupported.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / net/http on Go 1.24. This source records Transport bounds aggregate 1xx header bytes using MaxResponseHeaderBytes rather than a five-response count. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#nethttppkgnethttp).

<a id="rv379"></a>

## RV379: Standard library / Minor changes to the library / net/netip

netip.Addr/AddrPort/Prefix implement BinaryAppender and TextAppender.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / net/netip on Go 1.24. This source records netip.Addr/AddrPort/Prefix implement BinaryAppender and TextAppender. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#netnetippkgnetnetip).

<a id="rv380"></a>

## RV380: Standard library / Minor changes to the library / net/url

url.URL implements BinaryAppender.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / net/url on Go 1.24. This source records url.URL implements BinaryAppender. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#neturlpkgneturl).

<a id="rv381"></a>

## RV381: Standard library / Minor changes to the library / os/user

Windows user.Current works on Nano Server, speeds up slow-domain lookup, and reports the process owner during impersonation. Current/Lookup/LookupId support SYSTEM, LOCAL SERVICE and NETWORK SERVICE accounts.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / os/user on Go 1.24. This source records Windows user.Current works on Nano Server, speeds up slow-domain lookup, and reports the process owner during impersonation. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#osuserpkgosuser).

<a id="rv382"></a>

## RV382: Standard library / Minor changes to the library / regexp

regexp.Regexp implements TextAppender.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / regexp on Go 1.24. This source records regexp.Regexp implements TextAppender. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#regexppkgregexp).

<a id="rv383"></a>

## RV383: Standard library / Minor changes to the library / runtime

runtime.GOROOT is deprecated. Find go through PATH and query go env GOROOT for that toolchain.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / runtime on Go 1.24. This source records runtime.GOROOT is deprecated. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#runtimepkgruntime).

<a id="rv384"></a>

## RV384: Standard library / Minor changes to the library / strings

strings.Lines/SplitSeq/SplitAfterSeq/FieldsSeq/FieldsFuncSeq lazily iterate lines and separator/Unicode/predicate-delimited substrings.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G250](../rules/iteration-and-control-flow.md#g250). The linked rules apply this source to Standard library / Minor changes to the library / strings. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.24#stringspkgstrings).

<a id="rv385"></a>

## RV385: Standard library / Minor changes to the library / sync

sync.Map's new implementation reduces disjoint-key contention and removes low-contention-load warmup. nosynchashtriemap temporarily restores the old implementation.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / sync on Go 1.24. This source records sync.Map's new implementation reduces disjoint-key contention and removes low-contention-load warmup. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#syncpkgsync).

<a id="rv386"></a>

## RV386: Standard library / Minor changes to the library / testing

T.Context/B.Context cancel after test execution and before cleanup callbacks. T.Chdir/B.Chdir scope working-directory changes to the test or benchmark, subject to process-wide-state restrictions.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G258](../rules/testing.md#g258). The linked rules apply this source to Standard library / Minor changes to the library / testing. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.24#testingpkgtesting).

<a id="rv387"></a>

## RV387: Standard library / Minor changes to the library / text/template

text/template range accepts iterator functions and integers.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / text/template on Go 1.24. This source records text/template range accepts iterator functions and integers. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#texttemplatepkgtexttemplate).

<a id="rv388"></a>

## RV388: Standard library / Minor changes to the library / time

time.Time implements BinaryAppender/TextAppender.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / time on Go 1.24. This source records time.Time implements BinaryAppender/TextAppender. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#timepkgtime).

<a id="rv389"></a>

## RV389: Ports / Linux

Linux 3.2+ is required.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / Linux on Go 1.24. This source records Linux 3.2+ is required. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#linux).

<a id="rv390"></a>

## RV390: Ports / Darwin

Go 1.24 is the final macOS 11 release. Go 1.25 requires macOS 12+.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / Darwin on Go 1.24. This source records Go 1.24 is the final macOS 11 release. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#darwin).

<a id="rv391"></a>

## RV391: Ports / WebAssembly

go:wasmexport exports host-callable functions; wasip1/wasm c-shared builds reactors/libraries. Import/export signatures accept bool/string/uintptr and selected pointers in addition to numeric and unsafe.Pointer types. Support files move from misc/wasm to lib/wasm. Initial linear-memory use drops substantially.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / WebAssembly on Go 1.24. This source records go:wasmexport exports host-callable functions; wasip1/wasm c-shared builds reactors/libraries. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#wasm).

<a id="rv392"></a>

## RV392: Ports / Windows

windows/arm (32-bit) is marked broken, distinct from immediate removal.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / Windows on Go 1.24. This source records windows/arm (32-bit) is marked broken, distinct from immediate removal. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.24#windows).
