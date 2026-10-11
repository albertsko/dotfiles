# Go 1.19 source reference

Status: published-stable-release. Source: [official release notes](https://go.dev/doc/go1.19).

These are versioned source summaries. The linked rules cover recurring actions. A reference disposition preserves an API or implementation detail for tasks that need it. Read later releases before applying historical defaults.

<a id="rv65"></a>

## RV65: Changes to the language

A specification correction adjusts type-parameter scope in method declarations without changing existing programs.

Applicability: This is a specification clarification of type-parameter scope. The release notes explicitly say existing programs are unaffected, so it does not describe a new feature permission or a migration switch.

Disposition: release-reference. Consult when using Changes to the language on Go 1.19. This source records A specification correction adjusts type-parameter scope in method declarations without changing existing programs. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#language).

<a id="rv66"></a>

## RV66: Memory Model

The revised memory model clarifies synchronization consistently with other languages. Go atomics remain sequentially consistent. Typed atomic values improve safe expression of atomic state.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G251](../rules/shared-state-and-synchronization.md#g251). The linked rules apply this source to Memory Model. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.19#mem).

<a id="rv67"></a>

## RV67: Ports / LoongArch 64-bit

linux/loong64 adds the LP64D ABI and requires Linux 5.19+. Older distribution syscall ABIs are incompatible even with static binaries. Such systems need their distribution's Go build.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / LoongArch 64-bit on Go 1.19. This source records linux/loong64 adds the LP64D ABI and requires Linux 5.19+. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#loong64).

<a id="rv68"></a>

## RV68: Ports / RISC-V

riscv64 passes arguments/results in registers, with measured typical speedups around 10% or more.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / RISC-V on Go 1.19. This source records riscv64 passes arguments/results in registers, with measured typical speedups around 10% or more. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#riscv64).

<a id="rv69"></a>

## RV69: Tools / Doc Comments

Doc comments support links, lists and clearer headings. gofmt reformats them and new go/doc/comment parses, formats and renders HTML, Markdown or text.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Tools / Doc Comments on Go 1.19. This source records Doc comments support links, lists and clearer headings. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#go-doc).

<a id="rv70"></a>

## RV70: Tools / New unix build constraint

The unix build tag matches Unix-like targets (aix, android, darwin, dragonfly, freebsd, hurd, illumos, ios, linux, netbsd, openbsd, solaris in this release). Its set may grow.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Tools / New unix build constraint on Go 1.19. This source records The unix build tag matches Unix-like targets (aix, android, darwin, dragonfly, freebsd, hurd, illumos, ios, linux, netbsd, openbsd, solaris in this release). It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#go-unix).

<a id="rv71"></a>

## RV71: Tools / Go command

Build metadata records -trimpath. go generate explicitly sets GOROOT, and test/generate prepend GOROOT/bin to child PATH. go env quotes spaces in cgo/compiler flag values. go list -json=fields avoids unused computation and can consequently suppress unrelated errors. Module-loading information is cached to accelerate some list operations.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Tools / Go command on Go 1.19. This source records Build metadata records -trimpath. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#go-command).

<a id="rv72"></a>

## RV72: Tools / Vet

vet's errorsas check rejects the common misuse of passing *error as errors.As's second argument.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: [G99](../rules/errors-and-cleanup.md#g99). The linked rules apply this source to Tools / Vet. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.19#vet).

<a id="rv73"></a>

## RV73: Runtime

GOMEMLIMIT/debug.SetMemoryLimit sets a soft limit on runtime-managed memory, excluding external allocations and OS-held memory. It works with GOGC, even GOGC=off. Very small limits may overshoot. To preserve progress near the live-heap size, GC limits its CPU use near 50% excluding idle time and may exceed the memory limit. The limiter metric exposes activation. Idle periodic GC uses fewer workers, initial stacks adapt to historical usage, and importing os raises Unix RLIMIT_NOFILE to the hard limit (potentially affecting old child programs). Fatal application errors show shorter tracebacks unless system/crash is requested. ARM64 supports debugger-injected calls and ASan tracks arguments/globals more precisely.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: [G224](../rules/performance-and-diagnostics.md#g224), [G226](../rules/performance-and-diagnostics.md#g226). The linked rules apply this source to Runtime. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.19#runtime).

<a id="rv74"></a>

## RV74: Compiler

Large integer/string switches use jump tables on amd64/arm64. Direct compiler invocations require -p=importpath and must replace removed -importmap with -importcfg. Normal go/Bazel builds already supply -p.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Compiler on Go 1.19. This source records Large integer/string switches use jump tables on amd64/arm64. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#compiler).

<a id="rv75"></a>

## RV75: Assembler

Direct assembler invocations also require -p=importpath to produce linkable objects. go supplies it automatically.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Assembler on Go 1.19. This source records Direct assembler invocations also require -p=importpath to produce linkable objects. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#assembler).

<a id="rv76"></a>

## RV76: Linker

ELF compressed DWARF uses standard SHF_COMPRESSED instead of .zdebug. Binary consumers need compatible readers.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Linker on Go 1.19. This source records ELF compressed DWARF uses standard SHF_COMPRESSED instead of .zdebug. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#linker).

<a id="rv77"></a>

## RV77: Standard library / New atomic types

atomic.Bool/Int32/Int64/Uint32/Uint64/Uintptr/Pointer hide underlying values behind atomic operations. Pointer avoids unsafe casts. Int64/Uint64 ensure 64-bit alignment even on 32-bit targets.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G251](../rules/shared-state-and-synchronization.md#g251). The linked rules apply this source to Standard library / New atomic types. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.19#atomic_types).

<a id="rv78"></a>

## RV78: Standard library / PATH lookups

exec.Command/LookPath reject PATH results relative to the current directory. Use explicit paths when intentional. Windows also honors NoDefaultCurrentDirectoryInExePath to disable implicit current-directory searching.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G265](../rules/resource-and-http-lifecycles.md#g265). The linked rules apply this source to Standard library / PATH lookups. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.19#os-exec-path).

<a id="rv79"></a>

## RV79: Standard library / Minor changes to the library / archive/zip

zip.Reader skips leading non-ZIP bytes, allowing JAR and similar prefixed archives.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / archive/zip on Go 1.19. This source records zip.Reader skips leading non-ZIP bytes, allowing JAR and similar prefixed archives. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#archivezippkgarchivezip).

<a id="rv80"></a>

## RV80: Standard library / Minor changes to the library / crypto/elliptic

elliptic Marshal/MarshalCompressed/Add/Double/ScalarMult panic on invalid points, which were already unsupported and unsafe. P224/P384/P521 base multiplication accelerates, while a verified-model generic P256 implementation can slow 32-bit targets.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/elliptic on Go 1.19. This source records elliptic Marshal/MarshalCompressed/Add/Double/ScalarMult panic on invalid points, which were already unsupported and unsafe. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#cryptoellipticpkgcryptoelliptic).

<a id="rv81"></a>

## RV81: Standard library / Minor changes to the library / crypto/rand

crypto/rand.Read stops buffering OS randomness. High-frequency small reads may benefit from a buffered Reader with ReadFull. Plan 9 uses a fast-key-erasure generator. Prime uses rejection sampling to eliminate bias and reduce leakage, deliberately breaking deterministic-output assumptions about input streams.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G273](../rules/security-and-compatibility.md#g273). The linked rules apply this source to Standard library / Minor changes to the library / crypto/rand. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.19#cryptorandpkgcryptorand).

<a id="rv82"></a>

## RV82: Standard library / Minor changes to the library / crypto/tls

tls10default is removed. Explicit Config.MinVersion still enables TLS 1.0 clients. Both client/server reject duplicate handshake extensions.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G275](../rules/security-and-compatibility.md#g275). The linked rules apply this source to Standard library / Minor changes to the library / crypto/tls. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.19#cryptotlspkgcryptotls).

<a id="rv83"></a>

## RV83: Standard library / Minor changes to the library / crypto/x509

x509.CreateCertificate rejects MD5WithRSA and negative serials and omits empty extension sequences. x509sha1 remains temporarily available despite an earlier removal plan. Certificate/CSR parsing rejects duplicate extensions. CertPool gains Clone/Equal. ParseRevocationList and RevocationList.CheckSignatureFrom supersede ParseCRL/ParseDERCRL/CheckCRLSignature. Parsed CRLs expose RawIssuer, Signature, AuthorityKeyId and Extensions, ignored during creation. Verification builds better chains and enforces name constraints on non-leaf certificates too.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/x509 on Go 1.19. This source records x509.CreateCertificate rejects MD5WithRSA and negative serials and omits empty extension sequences. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#cryptox509pkgcryptox509).

<a id="rv84"></a>

## RV84: Standard library / Minor changes to the library / crypto/x509/pkix

pkix.CertificateList and TBSCertificateList are deprecated in favor of crypto/x509's new CRL API.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/x509/pkix on Go 1.19. This source records pkix.CertificateList and TBSCertificateList are deprecated in favor of crypto/x509's new CRL API. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#cryptox509pkixpkgcryptox509pkix).

<a id="rv85"></a>

## RV85: Standard library / Minor changes to the library / debug/elf

debug/elf gains EM_LOONGARCH and R_LARCH_* constants.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / debug/elf on Go 1.19. This source records debug/elf gains EM_LOONGARCH and R_LARCH_* constants. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#debugelfpkgdebugelf).

<a id="rv86"></a>

## RV86: Standard library / Minor changes to the library / debug/pe

pe.File.COFFSymbolReadSectionDefAux and COFFSymbolAuxFormat5 expose COMDAT information, supported by IMAGE_COMDAT_* and IMAGE_SCN_* constants.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / debug/pe on Go 1.19. This source records pe.File.COFFSymbolReadSectionDefAux and COFFSymbolAuxFormat5 expose COMDAT information, supported by IMAGE_COMDAT_* and IMAGE_SCN_* constants. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#debugpepkgdebugpe).

<a id="rv87"></a>

## RV87: Standard library / Minor changes to the library / encoding/binary

binary.AppendByteOrder, implemented by BigEndian/LittleEndian, appends fixed-width integers. AppendUvarint/AppendVarint append variable-width encodings.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / encoding/binary on Go 1.19. This source records binary.AppendByteOrder, implemented by BigEndian/LittleEndian, appends fixed-width integers. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#encodingbinarypkgencodingbinary).

<a id="rv88"></a>

## RV88: Standard library / Minor changes to the library / encoding/csv

csv.Reader.InputOffset reports the current input byte offset.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / encoding/csv on Go 1.19. This source records csv.Reader.InputOffset reports the current input byte offset. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#encodingcsvpkgencodingcsv).

<a id="rv89"></a>

## RV89: Standard library / Minor changes to the library / encoding/xml

xml.Decoder.InputPos reports line and column.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / encoding/xml on Go 1.19. This source records xml.Decoder.InputPos reports line and column. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#encodingxmlpkgencodingxml).

<a id="rv90"></a>

## RV90: Standard library / Minor changes to the library / flag

flag.TextVar accepts values implementing TextUnmarshaler, including big.Int, netip.Addr and time.Time.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / flag on Go 1.19. This source records flag.TextVar accepts values implementing TextUnmarshaler, including big.Int, netip.Addr and time.Time. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#flagpkgflag).

<a id="rv91"></a>

## RV91: Standard library / Minor changes to the library / fmt

fmt.Append/Appendf/Appendln format directly into byte slices.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / fmt on Go 1.19. This source records fmt.Append/Appendf/Appendln format directly into byte slices. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#fmtpkgfmt).

<a id="rv92"></a>

## RV92: Standard library / Minor changes to the library / go/parser

The parser represents ~x as a unary expression to improve recovery from misplaced constraints. This does not legalize that expression in ordinary code.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / go/parser on Go 1.19. This source records The parser represents ~x as a unary expression to improve recovery from misplaced constraints. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#goparserpkggoparser).

<a id="rv93"></a>

## RV93: Standard library / Minor changes to the library / go/types

types.Func.Origin and Var.Origin recover original generic objects from instantiated ones. Recursive Underlying/Method queries no longer generate unlimited distinct-but-identical Named instances.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / go/types on Go 1.19. This source records types.Func.Origin and Var.Origin recover original generic objects from instantiated ones. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#gotypespkggotypes).

<a id="rv94"></a>

## RV94: Standard library / Minor changes to the library / hash/maphash

maphash.Bytes/String hash one slice/string with less setup than a Hash object.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / hash/maphash on Go 1.19. This source records maphash.Bytes/String hash one slice/string with less setup than a Hash object. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#hashmaphashpkghashmaphash).

<a id="rv95"></a>

## RV95: Standard library / Minor changes to the library / html/template

html/template.FuncMap aliases text/template.FuncMap. Separately, Go 1.19.8+ blocks actions in ECMAScript template literals, with temporary jstmpllitinterp=1 reversal. This security behavior is patch-gated, not an original 1.19.0 change.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / html/template on Go 1.19. This source records html/template.FuncMap aliases text/template.FuncMap. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#htmltemplatepkghtmltemplate).

<a id="rv96"></a>

## RV96: Standard library / Minor changes to the library / image/draw

draw.Draw with Src again preserves unpremultiplied colors between matching NRGBA/NRGBA64 images, fixing a 1.18 regression.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / image/draw on Go 1.19. This source records draw.Draw with Src again preserves unpremultiplied colors between matching NRGBA/NRGBA64 images, fixing a 1.18 regression. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#imagedrawpkgimagedraw).

<a id="rv97"></a>

## RV97: Standard library / Minor changes to the library / io

io.NopCloser preserves WriterTo when supplied by its input. MultiReader always implements WriterTo, adapting readers that lack it.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / io on Go 1.19. This source records io.NopCloser preserves WriterTo when supplied by its input. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#iopkgio).

<a id="rv98"></a>

## RV98: Standard library / Minor changes to the library / mime

Windows MIME lookup ignores erroneous .js=text/plain registry entries and uses text/javascript; charset=utf-8. Explicit AddExtensionType can request other behavior.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / mime on Go 1.19. This source records Windows MIME lookup ignores erroneous .js=text/plain registry entries and uses text/javascript; charset=utf-8. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#mimepkgmime).

<a id="rv99"></a>

## RV99: Standard library / Minor changes to the library / mime/multipart

From 1.19.8, multipart limits each part's headers and aggregate FileHeader headers to 10,000 and forms to 1,000 parts. multipartmaxheaders/multipartmaxparts adjust those bounds. These are patch-gated input-hardening changes.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / mime/multipart on Go 1.19. This source records From 1.19.8, multipart limits each part's headers and aggregate FileHeader headers to 10,000 and forms to 1,000 parts. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#mimemultipartpkgmimemultipart).

<a id="rv100"></a>

## RV100: Standard library / Minor changes to the library / net

The Go DNS resolver advertises 1,232-byte replies via EDNS(0), up from 512. netdns=cgo can work around incompatible resolvers. Timeout/cancellation errors match context.DeadlineExceeded/context.Canceled through errors.Is. PreferGo works on Windows/Plan 9. Windows netgo support is initial and may choose the wrong DNS server in complex configurations.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G266](../rules/resource-and-http-lifecycles.md#g266). The linked rules apply this source to Standard library / Minor changes to the library / net. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.19#netpkgnet).

<a id="rv101"></a>

## RV101: Standard library / Minor changes to the library / net/http

ResponseWriter supports explicit 1xx responses. MaxBytesReader returns *MaxBytesError at its bound. Clients return 3xx responses lacking Location instead of reporting an error.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G263](../rules/resource-and-http-lifecycles.md#g263). The linked rules apply this source to Standard library / Minor changes to the library / net/http. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.19#nethttppkgnethttp).

<a id="rv102"></a>

## RV102: Standard library / Minor changes to the library / net/url

url.JoinPath and URL.JoinPath combine path components. URL.OmitHost preserves URLs with absent authority: http:/path omits //, while http:///path retains an empty authority. The release note calls both cases an empty authority in one sentence; the parser and formatter establish this distinction.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / net/url on Go 1.19. This source records url.JoinPath and URL.JoinPath combine path components. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#neturlpkgneturl), [source 2](https://go.dev/src/net/url/url.go#L486).

<a id="rv103"></a>

## RV103: Standard library / Minor changes to the library / os/exec

exec.Cmd with Dir and nil Env adjusts the child's PWD. Cmd.Environ reports that derived environment.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G265](../rules/resource-and-http-lifecycles.md#g265). The linked rules apply this source to Standard library / Minor changes to the library / os/exec. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.19#osexecpkgosexec).

<a id="rv104"></a>

## RV104: Standard library / Minor changes to the library / reflect

reflect.Value.Bytes accepts addressable arrays. Len/Cap accept array pointers, matching the built-ins.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / reflect on Go 1.19. This source records reflect.Value.Bytes accepts addressable arrays. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#reflectpkgreflect).

<a id="rv105"></a>

## RV105: Standard library / Minor changes to the library / regexp/syntax

regexp/syntax.ErrNestingDepth identifies excessive expression nesting. The rejection already existed in 1.18rc1/1.17.8/1.16.15 but previously returned ErrInternalError.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / regexp/syntax on Go 1.19. This source records regexp/syntax.ErrNestingDepth identifies excessive expression nesting. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#regexpsyntaxpkgregexpsyntax).

<a id="rv106"></a>

## RV106: Standard library / Minor changes to the library / runtime

runtime.GOROOT returns an empty string for -trimpath binaries when the environment supplies no GOROOT, replacing the old "go" fallback.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / runtime on Go 1.19. This source records runtime.GOROOT returns an empty string for -trimpath binaries when the environment supplies no GOROOT, replacing the old "go" fallback. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#runtimepkgruntime).

<a id="rv107"></a>

## RV107: Standard library / Minor changes to the library / runtime/metrics

Runtime metrics expose GOMAXPROCS threads, Go-to-C call count and the most recent GC cycle activating the CPU limiter.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / runtime/metrics on Go 1.19. This source records Runtime metrics expose GOMAXPROCS threads, Go-to-C call count and the most recent GC cycle activating the CPU limiter. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#runtimemetricspkgruntimemetrics).

<a id="rv108"></a>

## RV108: Standard library / Minor changes to the library / runtime/pprof

Goroutine profiling substantially reduces stop-the-world pauses. Heap profiles report MaxRSS on all Unix targets.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / runtime/pprof on Go 1.19. This source records Goroutine profiling substantially reduces stop-the-world pauses. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#runtimepprofpkgruntimepprof).

<a id="rv109"></a>

## RV109: Standard library / Minor changes to the library / runtime/race

Race detection uses ThreadSanitizer v3 except windows/amd64 and openbsd/amd64, with typical speed/memory improvements and no goroutine-count limit. Linux requires glibc 2.17 and binutils 2.26. s390x gains support. Upstream dropped openbsd/amd64, so its v2 implementation is unlikely to advance.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / runtime/race on Go 1.19. This source records Race detection uses ThreadSanitizer v3 except windows/amd64 and openbsd/amd64, with typical speed/memory improvements and no goroutine-count limit. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#runtimeracepkgruntimerace).

<a id="rv110"></a>

## RV110: Standard library / Minor changes to the library / runtime/trace

Execution traces include instantaneous CPU samples when CPU profiling runs concurrently.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / runtime/trace on Go 1.19. This source records Execution traces include instantaneous CPU samples when CPU profiling runs concurrently. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#runtimetracepkgruntimetrace).

<a id="rv111"></a>

## RV111: Standard library / Minor changes to the library / sort

sort adopts pattern-defeating quicksort. Find returns both an insertion/search position and whether equality was found.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / sort on Go 1.19. This source records sort adopts pattern-defeating quicksort. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#sortpkgsort).

<a id="rv112"></a>

## RV112: Standard library / Minor changes to the library / strconv

strconv quoting spells U+007F as \\x7f instead of \\u007f, which can affect textual comparisons.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G276](../rules/security-and-compatibility.md#g276). The linked rules apply this source to Standard library / Minor changes to the library / strconv. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.19#strconvpkgstrconv).

<a id="rv113"></a>

## RV113: Standard library / Minor changes to the library / syscall

PowerPC syscall families return zero in r2 rather than an undefined value. AIX/Solaris gain Getrusage.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / syscall on Go 1.19. This source records PowerPC syscall families return zero in r2 rather than an undefined value. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#syscallpkgsyscall).

<a id="rv114"></a>

## RV114: Standard library / Minor changes to the library / time

Duration.Abs saturates MinInt64 to MaxInt64 instead of overflowing. Time.ZoneBounds exposes the current zone interval for transition enumeration.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / time on Go 1.19. This source records Duration.Abs saturates MinInt64 to MaxInt64 instead of overflowing. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.19#timepkgtime).
