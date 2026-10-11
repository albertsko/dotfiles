# Go 1.18 source reference

Status: published-stable-release. Source: [official release notes](https://go.dev/doc/go1.18).

These are versioned source summaries. The linked rules cover recurring actions. A reference disposition preserves an API or implementation detail for tasks that need it. Read later releases before applying historical defaults.

<a id="rv1"></a>

## RV1: Changes to the language / Generics

Type parameters support generic functions and types, instantiated with bracketed type arguments. Interfaces can express type sets using unions and ~ underlying types, but these generalized interfaces are constraints, not ordinary value types. any aliases interface{} and comparable constrains equality-capable types. The initial implementation lacks production experience and specification or compiler corrections can invalidate buggy code. The x/exp helpers have no Go 1 compatibility promise.

Applicability: Generic syntax and constraint interfaces require Go 1.18 language support. Production-readiness warnings describe the initial compiler, while x/exp stability depends on that external module rather than the standard-library compatibility promise.

Disposition: [G17](../rules/code-and-api-design.md#g17). The linked rules apply this source to Changes to the language / Generics. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.18#generics).

<a id="rv2"></a>

## RV2: Changes to the language / Generics / golang.org/x/exp/constraints

Experimental x/exp/constraints supplies reusable constraints such as Ordered. Its API is outside the Go 1 guarantee.

Applicability: Applies when using the experimental x/exp/constraints module with a generics-capable language/toolchain. Its API version and lack of the Go 1 guarantee are separate from language-feature availability.

Disposition: [G249](../rules/collections-and-ownership.md#g249). The linked rules apply this source to Changes to the language / Generics / golang.org/x/exp/constraints. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.18#golangorgxexpconstraintshttpspkggodevgolangorgxexpconstraints).

<a id="rv3"></a>

## RV3: Changes to the language / Generics / golang.org/x/exp/slices

Experimental x/exp/slices supplies generic slice operations. It is distinct from the later stable slices package.

Applicability: Applies when using experimental x/exp/slices with a generics-capable language/toolchain. Track that module version separately from the stable slices package introduced later.

Disposition: [G249](../rules/collections-and-ownership.md#g249). The linked rules apply this source to Changes to the language / Generics / golang.org/x/exp/slices. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.18#golangorgxexpsliceshttpspkggodevgolangorgxexpslices).

<a id="rv4"></a>

## RV4: Changes to the language / Experimental maps and initial generic implementation restrictions

Experimental x/exp/maps supplies generic map operations. Separately, the initial generics implementation disallows local type declarations in generic functions, real/imag/complex on type parameters, implicit constraint methods, common struct-field access, embedding type parameters or their pointers, and multi-term unions containing method-bearing interfaces. Tools and libraries need generics support. Promised possible relaxations are not implemented features.

Applicability: The map helpers are experimental external-module APIs. The listed restrictions describe the initial Go 1.18 generic compiler and language implementation, not additional map-package restrictions. Check later releases before treating a historical restriction as current.

Disposition: [G249](../rules/collections-and-ownership.md#g249). The linked rules apply this source to Changes to the language / Experimental maps and initial generic implementation restrictions. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.18#golangorgxexpmapshttpspkggodevgolangorgxexpmaps).

<a id="rv5"></a>

## RV5: Changes to the language / Bug fixes

The compiler rejects variables only assigned inside closures but never used, and rejects overflowing rune constants passed to print/println. Repair invalid code or explicitly select the intended type. Compatibility does not preserve these compiler bugs.

Applicability: These are corrected diagnostics in the Go 1.18 compiler. The release notes provide no older-module-language escape hatch. Repair the invalid code when adopting the corrected compiler.

Disposition: release-reference. Consult when using Changes to the language / Bug fixes on Go 1.18. This source records The compiler rejects variables only assigned inside closures but never used, and rejects overflowing rune constants passed to print/println. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#bug_fixes).

<a id="rv6"></a>

## RV6: Ports / AMD64

GOAMD64 selects minimum x86-64 capabilities v1 through v4 and defaults to v1. Higher levels can improve generated code but require matching CPUs.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: [G246](../rules/versions-and-tooling.md#g246). The linked rules apply this source to Ports / AMD64. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.18#amd64).

<a id="rv7"></a>

## RV7: Ports / RISC-V

linux/riscv64 adds c-archive and c-shared build modes for C integration.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / RISC-V on Go 1.18. This source records linux/riscv64 adds c-archive and c-shared build modes for C integration. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#riscv).

<a id="rv8"></a>

## RV8: Ports / Linux

Linux deployments require kernel 2.6.32 or newer.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / Linux on Go 1.18. This source records Linux deployments require kernel 2.6.32 or newer. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#linux).

<a id="rv9"></a>

## RV9: Ports / Windows

windows/arm and windows/arm64 gain non-cooperative preemption, completing support across Windows ports and improving behavior around long-blocking Win32 calls.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / Windows on Go 1.18. This source records windows/arm and windows/arm64 gain non-cooperative preemption, completing support across Windows ports and improving behavior around long-blocking Win32 calls. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#windows).

<a id="rv10"></a>

## RV10: Ports / iOS

ios/arm64 and ios/amd64 simulator binaries require iOS 12 or newer.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / iOS on Go 1.18. This source records ios/arm64 and ios/amd64 simulator binaries require iOS 12 or newer. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#ios).

<a id="rv11"></a>

## RV11: Ports / FreeBSD

Go 1.18 is the final FreeBSD 11 release. The announced 1.19 baseline is FreeBSD 12.2+ or 13.0+, with COMPAT_FREEBSD12 on 13.0+ kernels.

Applicability: Applies when building or deploying to the named OS/architecture. Check the explicit minimum version, ABI and experimental status before upgrading.

Disposition: release-reference. Consult when using Ports / FreeBSD on Go 1.18. This source records Go 1.18 is the final FreeBSD 11 release. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#freebsd).

<a id="rv12"></a>

## RV12: Tools / Fuzzing

Built-in fuzzing explores inputs and stores coverage-expanding values in GOCACHE/fuzz. Budget memory and disk because the cache has no size limit in this release.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: [G255](../rules/testing.md#g255). The linked rules apply this source to Tools / Fuzzing. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.18#fuzzing).

<a id="rv13"></a>

## RV13: Tools / Go command / go get

In module mode, go get only edits dependencies and fails outside a module. Install executables using go install path@version, available since 1.16. GOPATH mode retains the older installation behavior.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: [G244](../rules/versions-and-tooling.md#g244). The linked rules apply this source to Tools / Go command / go get. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.18#go-get).

<a id="rv14"></a>

## RV14: Tools / Go command / Automatic go.mod and go.sum updates

go mod graph/vendor/verify/why stop implicitly editing go.mod and go.sum. Use get, tidy, or download when updates are intended.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: [G244](../rules/versions-and-tooling.md#g244). The linked rules apply this source to Tools / Go command / Automatic go.mod and go.sum updates. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.18#go-mod-updates).

<a id="rv15"></a>

## RV15: Tools / Go command / go version

Builds record VCS revision, time and dirty status when the main package/module and build directory belong to the same supported repository. -buildvcs=false disables VCS stamping. Build tags, tool flags and cgo configuration are also recorded. Read metadata with go version -m, runtime/debug.ReadBuildInfo or debug/buildinfo. Use 1.18+ readers for 1.18 binaries because the encoding can change.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Tools / Go command / go version on Go 1.18. This source records Builds record VCS revision, time and dirty status when the main package/module and build directory belong to the same supported repository. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#go-version).

<a id="rv16"></a>

## RV16: Tools / Go command / go mod download

For modules declaring go 1.17+, argument-free go mod download fetches explicitly required modules only. Use download all to include remaining transitive modules.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: [G244](../rules/versions-and-tooling.md#g244). The linked rules apply this source to Tools / Go command / go mod download. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.18#go-mod-download).

<a id="rv17"></a>

## RV17: Tools / Go command / go mod vendor

go mod vendor -o chooses an output directory for collectors. Normal -mod=vendor builds still read the module-root vendor directory.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Tools / Go command / go mod vendor on Go 1.18. This source records go mod vendor -o chooses an output directory for collectors. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#go-mod-vendor).

<a id="rv18"></a>

## RV18: Tools / Go command / go mod tidy

go mod tidy preserves checksums needed to detect ambiguous package providers. This applies regardless of the module's go directive.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: [G244](../rules/versions-and-tooling.md#g244). The linked rules apply this source to Tools / Go command / go mod tidy. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.18#go-mod-tidy).

<a id="rv19"></a>

## RV19: Tools / Go command / go work

go.work selects multiple main modules for workspace resolution. Discovery searches the current directory and parents, or follows GOWORK.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: [G245](../rules/versions-and-tooling.md#g245). The linked rules apply this source to Tools / Go command / go work. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.18#go-work).

<a id="rv20"></a>

## RV20: Tools / Go command / go build -asan

go build -asan enables interoperation with C/C++ code built with -fsanitize=address.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Tools / Go command / go build -asan on Go 1.18. This source records go build -asan enables interoperation with C/C++ code built with -fsanitize=address. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#go-build-asan).

<a id="rv21"></a>

## RV21: Tools / Go command / go test

go test adds -fuzz, -fuzztime and -fuzzminimizetime. go clean -fuzzcache removes accumulated fuzz inputs.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: [G255](../rules/testing.md#g255). The linked rules apply this source to Tools / Go command / go test. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.18#go-test).

<a id="rv22"></a>

## RV22: Tools / Go command / //go:build lines

With a go 1.18+ module directive, go fix removes obsolete // +build constraints. //go:build support and gofmt/vet synchronization originated in 1.17.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Tools / Go command / //go:build lines on Go 1.18. This source records With a go 1.18+ module directive, go fix removes obsolete // +build constraints. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#go-build-lines).

<a id="rv23"></a>

## RV23: Tools / Gofmt

gofmt processes files concurrently with a memory budget proportional to GOMAXPROCS. Formatting large file sets can become faster.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Tools / Gofmt on Go 1.18. This source records gofmt processes files concurrently with a memory budget proportional to GOMAXPROCS. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#gofmt).

<a id="rv24"></a>

## RV24: Tools / Vet / Updates for Generics

vet analyzes generic code for errors that arise from types allowed by its constraints, including invalid formatting operations.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Tools / Vet / Updates for Generics on Go 1.18. This source records vet analyzes generic code for errors that arise from types allowed by its constraints, including invalid formatting operations. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#vet-generics).

<a id="rv25"></a>

## RV25: Tools / Vet / Precision improvements for existing checkers

vet improves copylock, printf, sortslice, testinggoroutine and tests checks. Existing code can receive new diagnostics, including format strings assembled from constants.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Tools / Vet / Precision improvements for existing checkers on Go 1.18. This source records vet improves copylock, printf, sortslice, testinggoroutine and tests checks. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#vet-precision).

<a id="rv26"></a>

## RV26: Runtime

GC pacing counts stack and other non-heap scanning work, so memory and collection costs can shift and may need GOGC retuning. Scavenging returns memory more efficiently. Stack traces mark uncertain register argument values with ?. append uses a smoother growth formula, which remains an implementation detail.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: [G271](../rules/performance-and-diagnostics.md#g271). The linked rules apply this source to Runtime. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.18#runtime).

<a id="rv27"></a>

## RV27: Compiler

Register argument passing extends to arm64, ppc64/ppc64le and all amd64 operating systems without changing safe Go semantics. More range/labeled-loop functions can inline. Compiler -asan supports sanitized builds. The new generics type checker changes diagnostic wording and can slow compilation roughly 15%, without the same execution slowdown.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Compiler on Go 1.18. This source records Register argument passing extends to arm64, ppc64/ppc64le and all amd64 operating systems without changing safe Go semantics. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#compiler).

<a id="rv28"></a>

## RV28: Linker

Fewer linker relocations reduce linking cost and binary size. Binary tools should use 1.18 debug/gosym for old/new formats. Linker -asan supports sanitized builds.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Linker on Go 1.18. This source records Fewer linker relocations reduce linking cost and binary size. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#linker).

<a id="rv29"></a>

## RV29: Bootstrap

Bootstrap discovery checks ~/go1.17 and ~/sdk/go1.17 before ~/go1.4 when GOROOT_BOOTSTRAP is unset. The stated intention to require 1.17 for 1.19 is a historical plan, not proof of 1.19's actual requirement.

Applicability: Applies to the named build, analysis or diagnostic workflow. Update affected scripts/tool consumers and distinguish opt-in experiments from defaults.

Disposition: release-reference. Consult when using Bootstrap on Go 1.18. This source records Bootstrap discovery checks ~/go1.17 and ~/sdk/go1.17 before ~/go1.4 when GOROOT_BOOTSTRAP is unset. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#bootstrap).

<a id="rv30"></a>

## RV30: Standard library / New debug/buildinfo package

New debug/buildinfo reads module versions, VCS data and build flags from executables. ReadBuildInfo and go version -m expose corresponding metadata.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / New debug/buildinfo package on Go 1.18. This source records New debug/buildinfo reads module versions, VCS data and build flags from executables. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#debug_buildinfo).

<a id="rv31"></a>

## RV31: Standard library / New net/netip package

net/netip adds small immutable comparable Addr values, AddrPort endpoints and Prefix networks, plus constructors/parsers and predefined addresses. net adds LookupNetIP, allocation-free UDP AddrPort read/write methods, TCPAddrFromAddrPort/UDPAddrFromAddrPort and AddrPort conversions. These support value-based addresses and map keys without net.IP's slice semantics. Constructors and parsers include AddrFrom4/AddrFrom16/AddrFromSlice/AddrPortFrom/PrefixFrom, ParseAddr/ParseAddrPort/ParsePrefix and their MustParse variants, IPv4Unspecified/IPv6Unspecified/IPv6LinkLocalAllNodes. UDP methods are ReadFromUDPAddrPort/ReadMsgUDPAddrPort/WriteToUDPAddrPort/WriteMsgUDPAddrPort.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / New net/netip package on Go 1.18. This source records net/netip adds small immutable comparable Addr values, AddrPort endpoints and Prefix networks, plus constructors/parsers and predefined addresses. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#netip).

<a id="rv32"></a>

## RV32: Standard library / TLS 1.0 and 1.1 disabled by default client-side

TLS clients default to minimum TLS 1.2 when MinVersion is unset. Explicit VersionTLS10 still permits older protocols. Servers retain their TLS 1.0 default here. tls10default=1 temporarily restores the client default and is scheduled for removal in 1.19.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G275](../rules/security-and-compatibility.md#g275). The linked rules apply this source to Standard library / TLS 1.0 and 1.1 disabled by default client-side. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.18#tls10).

<a id="rv33"></a>

## RV33: Standard library / Rejecting SHA-1 certificates

x509 rejects SHA-1 certificate signatures except self-signed roots. x509sha1=1 is a temporary compatibility escape hatch, not a durable migration strategy.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G275](../rules/security-and-compatibility.md#g275). The linked rules apply this source to Standard library / Rejecting SHA-1 certificates. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.18#sha1).

<a id="rv34"></a>

## RV34: Standard library / Minor changes to the library / bufio

bufio.Writer.AvailableBuffer supports append-then-Write workflows with possible copy avoidance. Reset initializes nil buffers with the default size.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / bufio on Go 1.18. This source records bufio.Writer.AvailableBuffer supports append-then-Write workflows with possible copy avoidance. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#bufiopkgbufio).

<a id="rv35"></a>

## RV35: Standard library / Minor changes to the library / bytes

bytes.Cut separates around a delimiter. Trim/TrimLeft/TrimRight avoid allocation and accelerate small ASCII cutsets. Title is deprecated because Unicode/language casing needs x/text/cases.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / bytes on Go 1.18. This source records bytes.Cut separates around a delimiter. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#bytespkgbytes).

<a id="rv36"></a>

## RV36: Standard library / Minor changes to the library / crypto/elliptic

P224/P384/P521 use generated, constant-time curve implementations and complete formulas, with substantial P224/P384 speedups. Invalid points remain unsupported and can expose keys. These methods currently return a random point for invalid input, with possible future panic behavior.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/elliptic on Go 1.18. This source records P224/P384/P521 use generated, constant-time curve implementations and complete formulas, with substantial P224/P384 speedups. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#cryptoellipticpkgcryptoelliptic).

<a id="rv37"></a>

## RV37: Standard library / Minor changes to the library / crypto/tls

tls.Conn.NetConn exposes the wrapped network connection.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/tls on Go 1.18. This source records tls.Conn.NetConn exposes the wrapped network connection. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#cryptotlspkgcryptotls).

<a id="rv38"></a>

## RV38: Standard library / Minor changes to the library / crypto/x509

x509 verification uses platform policy for macOS/iOS system roots. Windows gains SystemCertPool. Augmented system pools on Windows/macOS/iOS try platform roots and Go verification of added roots, preferring platform chains. CertPool.Subjects is deprecated because system-root policy cannot be represented as a static list. MD5 certificate signing removal is announced as possible, not completed here.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / crypto/x509 on Go 1.18. This source records x509 verification uses platform policy for macOS/iOS system roots. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#cryptox509pkgcryptox509).

<a id="rv39"></a>

## RV39: Standard library / Minor changes to the library / debug/dwarf

dwarf.StructField and BasicType expose DW_AT_data_bit_offset through DataBitOffset for binary readers.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / debug/dwarf on Go 1.18. This source records dwarf.StructField and BasicType expose DW_AT_data_bit_offset through DataBitOffset for binary readers. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#debugdwarfpkgdebugdwarf).

<a id="rv40"></a>

## RV40: Standard library / Minor changes to the library / debug/elf

debug/elf exports R_PPC64_RELATIVE for relocation processing.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / debug/elf on Go 1.18. This source records debug/elf exports R_PPC64_RELATIVE for relocation processing. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#debugelfpkgdebugelf).

<a id="rv41"></a>

## RV41: Standard library / Minor changes to the library / debug/plan9obj

plan9obj.File.Symbols returns identifiable ErrNoSymbols when the symbol section is absent.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / debug/plan9obj on Go 1.18. This source records plan9obj.File.Symbols returns identifiable ErrNoSymbols when the symbol section is absent. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#debugplan9objpkgdebugplan9obj).

<a id="rv42"></a>

## RV42: Standard library / Minor changes to the library / embed

go:embed patterns prefixed with all: include dot- and underscore-prefixed names.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / embed on Go 1.18. This source records go:embed patterns prefixed with all: include dot- and underscore-prefixed names. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#embedpkgembed).

<a id="rv43"></a>

## RV43: Standard library / Minor changes to the library / go/ast

AST FuncType/TypeSpec gain TypeParams. IndexListExpr represents generic instantiations with multiple explicit arguments. Syntax tools must handle these nodes.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G277](../rules/versions-and-tooling.md#g277). The linked rules apply this source to Standard library / Minor changes to the library / go/ast. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.18#goastpkggoast).

<a id="rv44"></a>

## RV44: Standard library / Minor changes to the library / go/constant

constant.Kind.String provides a readable kind name.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / go/constant on Go 1.18. This source records constant.Kind.String provides a readable kind name. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#goconstantpkggoconstant).

<a id="rv45"></a>

## RV45: Standard library / Minor changes to the library / go/token

token.TILDE represents the new ~ token.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / go/token on Go 1.18. This source records token.TILDE represents the new ~ token. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#gotokenpkggotoken).

<a id="rv46"></a>

## RV46: Standard library / Minor changes to the library / go/types

go/types adds Config.GoVersion; TypeParam/NewTypeParam, TypeParamList and TypeList; generic NewSignatureType and signature parameter accessors; Named.Origin/TypeArgs/TypeParams/SetTypeParams; interface comparability/method-set/implicit-constraint queries; Union/Term constructors; Instantiate; Info.Instances/Instance; ArgumentError; and shared Context/NewContext/Config.Context. Existing type predicates accept generalized interfaces, but AssignableTo/ConvertibleTo/Implements/AssertableTo remain undefined for uninstantiated generics and AssertableTo also for a generalized-interface first argument. Generic signature accessors are RecvTypeParams and TypeParams; interface queries are IsComparable/IsMethodSet/MarkImplicit/IsImplicit.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G277](../rules/versions-and-tooling.md#g277). The linked rules apply this source to Standard library / Minor changes to the library / go/types. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.18#gotypespkggotypes).

<a id="rv47"></a>

## RV47: Standard library / Minor changes to the library / html/template

html/template ranges support break and continue. and/or short-circuit, so later function arguments may no longer execute.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / html/template on Go 1.18. This source records html/template ranges support break and continue. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#htmltemplatepkghtmltemplate).

<a id="rv48"></a>

## RV48: Standard library / Minor changes to the library / image/draw

draw.Draw/DrawMask fallback paths accelerate images implementing the optional RGBA64Image interfaces introduced in 1.17.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / image/draw on Go 1.18. This source records draw.Draw/DrawMask fallback paths accelerate images implementing the optional RGBA64Image interfaces introduced in 1.17. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#imagedrawpkgimagedraw).

<a id="rv49"></a>

## RV49: Standard library / Minor changes to the library / net

net.Error.Temporary is deprecated. Error recovery needs operation-specific decisions.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G266](../rules/resource-and-http-lifecycles.md#g266). The linked rules apply this source to Standard library / Minor changes to the library / net. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.18#netpkgnet).

<a id="rv50"></a>

## RV50: Standard library / Minor changes to the library / net/http

WebAssembly HTTP transports honor custom Dial/DialContext/DialTLS/DialTLSContext hooks. Cookie.Valid validates cookies and MaxBytesHandler bounds request reads. Domain conversion uses nontransitional IDNA, changing treatment of sharp-s, final sigma and the two joiner characters.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G263](../rules/resource-and-http-lifecycles.md#g263). The linked rules apply this source to Standard library / Minor changes to the library / net/http. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.18#nethttppkgnethttp).

<a id="rv51"></a>

## RV51: Standard library / Minor changes to the library / os/user

os/user.User.GroupIds has a native Go implementation without cgo.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / os/user on Go 1.18. This source records os/user.User.GroupIds has a native Go implementation without cgo. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#osuserpkgosuser).

<a id="rv52"></a>

## RV52: Standard library / Minor changes to the library / reflect

reflect adds SetIterKey/SetIterValue and reusable MapIter.Reset to reduce allocations, UnsafePointer to avoid caller-side uintptr conversions, CanInt/CanUint/CanFloat/CanComplex guards, and FieldByIndexErr for nil embedded pointers. Ptr/PtrTo become Pointer/PointerTo, retaining the old names.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / reflect on Go 1.18. This source records reflect adds SetIterKey/SetIterValue and reusable MapIter.Reset to reduce allocations, UnsafePointer to avoid caller-side uintptr conversions, CanInt/CanUint/CanFloat/CanComplex guards, and FieldByIndexErr for nil embedded pointers. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#reflectpkgreflect).

<a id="rv53"></a>

## RV53: Standard library / Minor changes to the library / regexp

regexp interprets each invalid UTF-8 byte separately as U+FFFD.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / regexp on Go 1.18. This source records regexp interprets each invalid UTF-8 byte separately as U+FFFD. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#regexppkgregexp).

<a id="rv54"></a>

## RV54: Standard library / Minor changes to the library / runtime/debug

debug.BuildInfo records GoVersion and Settings, with BuildSetting key/value entries describing the build.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / runtime/debug on Go 1.18. This source records debug.BuildInfo records GoVersion and Settings, with BuildSetting key/value entries describing the build. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#runtimedebugpkgruntimedebug).

<a id="rv55"></a>

## RV55: Standard library / Minor changes to the library / runtime/pprof

Linux CPU profiling uses per-thread timers, increasing observable CPU usage and reducing sampling biases.

Applicability: Applies to runtime behavior, diagnostics or performance on the named platform/configuration. Measurements are workload-dependent; compatibility switches and limits are stated in the explanation.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / runtime/pprof on Go 1.18. This source records Linux CPU profiling uses per-thread timers, increasing observable CPU usage and reducing sampling biases. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#runtimepprofpkgruntimepprof).

<a id="rv56"></a>

## RV56: Standard library / Minor changes to the library / strconv

strconv.Unquote rejects Unicode surrogate halves.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / strconv on Go 1.18. This source records strconv.Unquote rejects Unicode surrogate halves. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#strconvpkgstrconv).

<a id="rv57"></a>

## RV57: Standard library / Minor changes to the library / strings

strings.Cut splits around a separator and Clone makes independent backing storage. Trim variants avoid allocation and speed up small ASCII cutsets. Title is deprecated in favor of language-aware x/text/cases.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G83](../rules/text-and-bytes.md#g83). The linked rules apply this source to Standard library / Minor changes to the library / strings. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.18#stringspkgstrings).

<a id="rv58"></a>

## RV58: Standard library / Minor changes to the library / sync

Mutex.TryLock and RWMutex.TryLock/TryRLock attempt immediate acquisition. Their availability does not justify replacing blocking synchronization with polling.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G251](../rules/shared-state-and-synchronization.md#g251). The linked rules apply this source to Standard library / Minor changes to the library / sync. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.18#syncpkgsync).

<a id="rv59"></a>

## RV59: Standard library / Minor changes to the library / syscall

Windows SyscallN supports arbitrary argument counts and supersedes Syscall through Syscall18 variants. FreeBSD adds SysProcAttr.Pdeathsig.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / syscall on Go 1.18. This source records Windows SyscallN supports arbitrary argument counts and supersedes Syscall through Syscall18 variants. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#syscallpkgsyscall).

<a id="rv60"></a>

## RV60: Standard library / Minor changes to the library / syscall/js

syscall/js removes Wrapper. Consumers of this experimental interface must adapt.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / syscall/js on Go 1.18. This source records syscall/js removes Wrapper. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#syscalljspkgsyscalljs).

<a id="rv61"></a>

## RV61: Standard library / Minor changes to the library / testing

-run/-bench give / higher precedence: A/B|C/D means (A/B)|(C/D). With no selected tests, -count is ignored. testing.F and -test.fuzz/-test.fuzztime/-test.fuzzminimizetime support fuzz tests.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: [G255](../rules/testing.md#g255). The linked rules apply this source to Standard library / Minor changes to the library / testing. Other details remain in the release reference.

Sources: [source 1](https://go.dev/doc/go1.18#testingpkgtesting).

<a id="rv62"></a>

## RV62: Standard library / Minor changes to the library / text/template

text/template ranges support break/continue and and/or short-circuit, changing execution of side-effecting arguments.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / text/template on Go 1.18. This source records text/template ranges support break/continue and and/or short-circuit, changing execution of side-effecting arguments. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#texttemplatepkgtexttemplate).

<a id="rv63"></a>

## RV63: Standard library / Minor changes to the library / text/template/parse

template/parse represents control flow with NodeBreak/BreakNode and NodeContinue/ContinueNode.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / text/template/parse on Go 1.18. This source records template/parse represents control flow with NodeBreak/BreakNode and NodeContinue/ContinueNode. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#texttemplateparsepkgtexttemplateparse).

<a id="rv64"></a>

## RV64: Standard library / Minor changes to the library / unicode/utf8

utf8.AppendRune appends a rune's UTF-8 bytes to an existing byte slice.

Applicability: Applies to consumers of the named API/package. Use the stated release or patch gate and inspect later entries for changed defaults, experimental graduation or removal.

Disposition: release-reference. Consult when using Standard library / Minor changes to the library / unicode/utf8 on Go 1.18. This source records utf8.AppendRune appends a rune's UTF-8 bytes to an existing byte slice. It remains a versioned API, compatibility or implementation reference rather than a separate recurring rule.

Sources: [source 1](https://go.dev/doc/go1.18#unicodeutf8pkgunicodeutf8).
