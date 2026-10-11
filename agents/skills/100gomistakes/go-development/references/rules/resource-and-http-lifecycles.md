# Resources, HTTP and subprocesses

Load when: files, durability, HTTP bodies/timeouts/routes, proxies, filesystem confinement or subprocesses

<a id="g160"></a>

- **G160** When an HTTP client call succeeds. Then Close the response body even when its contents are ignored. Check the request error first. A non-nil response returned with an error need not be closed under the documented client contract. The non-nil response with a client redirect error has an already closed body under the described contract. Server-owned request bodies have a separate ownership rule. Server request bodies are closed by the server rather than owned like client response bodies. Because An unclosed body retains resources and can prevent connection reuse.

  Sources: `BP160`.

<a id="g161"></a>

- **G161** When only status matters and connection reuse is desired. Then Choose a bounded time/resource policy before draining an ignored body to io.Discard, and always close a successful client response body. Reading to EOF can permit reuse without storing the body. Go 1.27 HTTP/1 Close attempts only bounded draining, so unread arbitrary bodies do not guarantee reuse. Server request bodies remain server-owned. Because Reading to completion permits reuse without allocating the whole body.

  Sources: `BP161`, `RV540`.

<a id="g162"></a>

- **G162** When a database query returns Rows. Then Arrange Rows.Close after successful acquisition, commonly with defer. sql.DB itself is intended to be long-lived and shared, with closure owned by its lifecycle. Because Returns the connection to the pool on early exits.

  Sources: `BP162`.

<a id="g163"></a>

- **G163** When opening files. Then Close them explicitly and handle meaningful close errors. Propagate a close error if the primary write succeeded. Preserve prior failures. For a writable file, report Close failure when the primary write succeeded and preserve a preexisting write failure. Because Relying on garbage collection delays release and hides errors from pending writes.

  Sources: `BP163`.

<a id="g164"></a>

- **G164** When file durability is required before return. Then Call Sync and handle its error. Sync costs performance. The source's suggestion to ignore Close after Sync deserves contract-specific review. Because A successful Write or Close does not ensure data reached durable storage.

  Sources: `BP164`.

<a id="g165"></a>

- **G165** When an HTTP error response should terminate a handler. Then Return immediately after http.Error. Test failing paths. Assert status and body on failure paths so repeated status writes, mixed success/error bodies and nil dereferences are detected. Because Writing a response does not stop execution and later code can append success data or dereference invalid values.

  Sources: `BP165`.

<a id="g166"></a>

- **G166** When configuring a production HTTP client. Then Set request and relevant dial, TLS handshake, and response-header timeouts. Choose values for the workload, especially long-running responses. Client.Timeout includes reading the response body. The source's one/five-second examples are not universal values. Because Unbounded waits can exhaust resources.

  Sources: `BP166`.

<a id="g167"></a>

- **G167** When an HTTP client makes many concurrent calls. Then Tune idle timeout, global idle count, and per-host idle count, and reuse connections. Distinguish idle limits from total active connection limits. Avoid losing useful transport defaults when customizing. Keep-alives should not be disabled casually. Preserve useful transport defaults and distinguish idle-pool limits from active-connection limits. Because Default per-host idle limits can force repeated reconnects.

  Sources: `BP167`.

<a id="g168"></a>

- **G168** When serving untrusted or production HTTP traffic. Then Set ReadHeaderTimeout and appropriate request/body limits, then choose a handler-duration policy for the protocol. TimeoutHandler sends 503 and cancels its context, but does not stop arbitrary work and is unsuitable for streaming that needs its unsupported interfaces. Evaluate WriteTimeout and per-request ResponseController deadlines (Go 1.20+) for the actual response protocol. Avoid copying the book's blanket dismissal of WriteTimeout. Because Slow or never-ending requests otherwise retain server resources.

  Sources: `BP168`, `RV131`.

<a id="g169"></a>

- **G169** When keeping HTTP server connections alive. Then Configure IdleTimeout deliberately. Choose a value that balances reuse and resource limits. Because Otherwise ReadTimeout is used, or connections may have no idle bound.

  Sources: `BP169`.

<a id="g261"></a>

- **G261** When using ReverseProxy hooks. Then On Go 1.20+, use Rewrite with deliberate outbound URL/Host and forwarding-header policy. SetXForwarded is explicit. Director is deprecated in Go 1.26 because hostile hop-by-hop headers can remove headers it adds. Test attacker-controlled Connection headers and the trusted proxy boundary. Because Inbound and outbound handling must be separated before security-relevant headers are added.

  Sources: `RV132`, `RV485`.

<a id="g262"></a>

- **G262** When changing ServeMux routes or upgrading routing behavior. Then For Go 1.22 routing, review method-qualified patterns, GET matching HEAD, wildcards, PathValue, escaping and conflicting overlaps. httpmuxgo121 restores older routing only where supported. Go 1.26 slash redirects use 307 instead of 301, preserving method/body. Test route selection and redirects with the application's methods and paths. Because Routing syntax and redirects can alter which handler receives a request.

  Sources: `RV252`, `RV270`, `RV309`, `RV483`.

<a id="g263"></a>

- **G263** When handling untrusted HTTP bodies, headers or browser-origin requests. Then Choose request-body limits such as MaxBytesReader/MaxBytesHandler and inspect errors at the limit. Configure header/time limits independently. Go 1.27 Server.MaxHeaderValueCount bounds value counts. Go 1.25 CrossOriginProtection addresses unsafe cross-origin browser requests using Fetch metadata, with deliberate bypasses. It does not provide authentication or general request validation. Because Distinct input dimensions and browser threats require distinct controls.

  Sources: `RV50`, `RV101`, `RV429`, `RV540`.

<a id="g264"></a>

- **G264** When accessing filesystem paths supplied outside the trusted boundary. Then Use lexical checks only for lexical validation. filepath.IsLocal (Go 1.20) and Localize (Go 1.23) do not resolve symlink escape races. Go 1.24 os.Root supports confined operations, with more methods in Go 1.25. Choose an available Root operation and inspect platform limits before relying on confinement. Because A path that looks local can still escape through filesystem resolution.

  Sources: `RV165`, `RV313`, `RV342`, `RV430`.

<a id="g265"></a>

- **G265** When launching subprocesses. Then Use explicit paths when current-directory execution is intended. From Go 1.19, exec.Command/LookPath reject relative PATH resolutions. Derive cancellation from the operation and, on Go 1.20+, consider Cmd.Cancel/WaitDelay for custom termination and inherited pipes. Wait and close owned resources even after cancellation. Because Executable lookup and descendant-held pipes can violate intended trust and lifetime boundaries.

  Sources: `RV78`, `RV103`, `RV164`, `RV274`.

<a id="g266"></a>

- **G266** When constructing network endpoints or retrying network failures. Then Use net.JoinHostPort for host/port construction, especially IPv6. Evaluate retryability for the specific operation rather than deprecated net.Error.Temporary. Go 1.26 URL parsing rejects malformed colon-containing hosts. Use errors.Is/As when documented wrapped cancellation errors are relevant. Because Address formatting and failure categories have protocol-specific contracts.

  Sources: `RV49`, `RV100`, `RV308`, `RV395`, `RV487`.
