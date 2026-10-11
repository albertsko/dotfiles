# Versions and tooling

Load when: any Go build/review/upgrade, baseline selection, modules/workspaces, platforms, experiments or developer tools

<a id="g241"></a>

- **G241** When building, reviewing or upgrading a Go module. Then Record the supported minimum Go version, go.mod/go.work directives, per-file build constraints, actual selected toolchain, GOTOOLCHAIN and target platforms. From Go 1.21 the go directive is a strict minimum and toolchain selection may download another compiler. A newer compiler alone does not enable newer language semantics in an older module. Validate the minimum with an actual baseline toolchain when compatibility is claimed. Because Language permission, library availability and runtime compatibility defaults are separate inputs.

  Sources: `RV180`, `RV239`, `RV289`, `RV506`.

<a id="g242"></a>

- **G242** When upgrading a runtime or changing GODEBUG settings. Then Inspect relevant release entries for all crossed versions and their patch, module and experiment gates. On Go 1.27, asynctimerchan, gotypesalias, tlsunsafeekm, tlsrsakex, tls3des, tls10server and x509keypairleaf are removed. Removed keys in module/source declarations only accept their final values. Test behavior instead of prescribing a removed workaround. Because Compatibility switches can expire and source-era advice can become invalid.

  Sources: `RV505`, `RV513`, `RV527`, `RV535`.

<a id="g243"></a>

- **G243** When modernizing Go source or verification tooling. Then Run the target toolchain's go fix and vet checks as appropriate, then review the diff and relevant behavioral tests. Go 1.26 rebuilds go fix around modernizers, and Go 1.27 changes modernizer names and defaults stdversion into go test. Account for output/JSON changes in tool consumers. Because Automated migration and diagnostics help locate changes but do not establish application semantics.

  Sources: `RV446`, `RV506`, `RV508`, `RV511`.

<a id="g244"></a>

- **G244** When installing tools or updating module dependencies. Then In module mode on Go 1.18+, use go install path@version for executables and go get for dependencies. Use deliberate tidy/download updates, and review go.mod/go.sum changes. Go 1.24+ tool directives and go tool can track executable dependencies. A go1.27+ module may have require blocks consolidated by tidy. Because Tool installation, dependency changes and reproducible build inputs have different ownership.

  Sources: `RV13`, `RV14`, `RV16`, `RV18`, `RV333`, `RV509`.

<a id="g245"></a>

- **G245** When working in a multi-module checkout. Then Inspect go env GOWORK and the discovered go.work before interpreting dependency resolution. Go 1.18 workspaces select multiple main modules. Go 1.22 adds workspace vendor trees. Verify intended module-only behavior with GOWORK=off when publishing or testing a module independently. Because An enclosing workspace or its vendor tree can hide a missing module requirement.

  Sources: `RV19`, `RV240`.

<a id="g246"></a>

- **G246** When building for different operating systems, CPU levels or cgo environments. Then Consult the platform entries for the selected release and verify GOOS, GOARCH, architecture feature levels, OS minimums, C compiler/linker and external library ABI. Higher GOAMD64/GOARM64/GORISCV64 settings constrain deployment hardware. Go 1.27 requires macOS 13+, and linux/ppc64 uses ELFv2 with compatible libc/libraries for cgo. Because A successful host build does not prove deployment compatibility.

  Sources: `RV6`, `RV329`, `RV330`, `RV548`, `RV549`, `RV121`.

<a id="g247"></a>

- **G247** When using experimental Go features. Then Record the exact toolchain and GOEXPERIMENT settings and isolate unstable APIs. Go 1.24 synctest.Run and Go 1.25 JSON v2 are historical experiments, not their later stable APIs. Go 1.27 simd/archsimd and runtime/secret remain experimental. Review later release entries before carrying experiment switches forward. Because An experiment is outside the ordinary stable API contract, even when a later feature shares its name.

  Sources: `RV349`, `RV405`, `RV406`, `RV518`, `RV456`, `RV457`, `RV521`, `RV522`, `RV543`.

<a id="g277"></a>

- **G277** When maintaining Go syntax/type/binary inspection tools. Then Use version-compatible go/ast, go/types and debug readers. Handle generics and file language versions, replace deprecated AST identifier resolution with type checking, and handle Alias nodes unconditionally on Go 1.27. Recheck executable layouts and JSON event schemas against the target toolchain rather than parsing undocumented text. Because Language and binary representation evolve independently of the application being inspected.

  Sources: `RV43`, `RV46`, `RV209`, `RV263`, `RV264`, `RV306`, `RV419`, `RV420`, `RV453`, `RV476`, `RV506`, `RV535`.
