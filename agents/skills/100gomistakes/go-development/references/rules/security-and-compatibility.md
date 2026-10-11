# Security and compatibility

Load when: randomness, reproducible simulations/sampling/replay, crypto/TLS/trust policy, external compatibility or exact implementation-output assertions

<a id="g254"></a>

- **G254** When code needs reproducible noncryptographic randomness, including production simulations, sampling, replay or tests. Then Own a local seeded generator instead of relying on package-global state. math/rand autoseeds from Go 1.20 and top-level Seed becomes a no-op by default in Go 1.24. math/rand/v2 is available from Go 1.22 with different sources and names. A fixed seed does not control goroutine scheduling. Because Global defaults and algorithms change across versions and shared state breaks isolation.

  Sources: `RV157`, `RV250`, `RV375`, `RV538`.

<a id="g273"></a>

- **G273** When generating security-sensitive randomness. Then Use crypto/rand rather than math/rand or rand/v2. From Go 1.24 crypto/rand.Read returns nil error on success and fatally terminates on reader failure. Go 1.26 several key-generation/signing APIs ignore supplied randomness by default. Use testing/cryptotest.SetGlobalRandom only within its global-state restrictions for deterministic tests. Preserve ECDSA PrivateKey.Sign(nil, ...) deterministic signing and Ed25519's explicit non-nil-reader distinction. Because Reproducible simulation randomness and cryptographic entropy have different guarantees.

  Sources: `RV81`, `RV157`, `RV250`, `RV356`, `RV460`, `RV461`, `RV462`, `RV463`, `RV467`, `RV468`, `RV493`.

<a id="g274"></a>

- **G274** When maintaining cryptographic protocol or primitive choices. Then Prefer maintained high-level crypto APIs and authenticated encryption. Use crypto/ecdh for key exchange instead of deprecated elliptic arithmetic, and review OFB/CFB and RSA PKCS1v15 encryption deprecations before extending old designs. Faster hashes do not make MD5 or SHA1 secure. Verify algorithm and compliance requirements against the exact deployed module and version rather than inferring approval from package availability. Because Low-level arithmetic, deprecated encryption modes and historical compliance claims are not safe defaults.

  Sources: `RV129`, `RV156`, `RV197`, `RV353`, `RV355`, `RV358`, `RV348`, `RV464`, `RV468`.

<a id="g275"></a>

- **G275** When upgrading TLS or certificate handling. Then Review negotiated protocols, cipher/group defaults, trust roots, certificate validation and temporary switches across every crossed release. Go 1.24 removes SHA1 verification escape x509sha1 and draft Kyber. Go 1.27 removes legacy TLS default switches and always populates key-pair Leaf. Explicit supported configuration differs from restoring removed defaults. Test real peers and root-store behavior, including Go 1.27 SSL_CERT_FILE/DIR overrides on Windows/Darwin. Because Defaults and platform verification policy can change interoperability and trust decisions.

  Sources: `RV32`, `RV33`, `RV82`, `RV257`, `RV300`, `RV362`, `RV363`, `RV416`, `RV471`, `RV527`, `RV528`.

<a id="g276"></a>

- **G276** When tests or integrations compare exact standard-library output. Then Decide whether bytes, parsed values or documented error identities are the contract. Keep byte assertions only where required. Recheck JSON escapes/errors, JPEG bytes/pixels, DEFLATE-dependent outputs, Unicode tables and wrapping changes after upgrades. For UnixConn EOF on Go 1.27, tolerate the direct io.EOF sentinel. Because Equivalent or corrected output can change without violating a promised semantic contract.

  Sources: `RV112`, `RV262`, `RV479`, `RV518`, `RV524`, `RV539`, `RV547`.
