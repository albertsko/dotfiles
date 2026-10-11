# Database access

Load when: database readiness, sql.DB pools, parameterization, NULL or Rows lifecycle

<a id="g154"></a>

- **G154** When startup readiness requires a reachable database. Then After sql.Open, call Ping or PingContext and handle failure. Behavior varies by driver. A context bounds the readiness check. Because Open can validate configuration without establishing any connection.

  Sources: `BP154`.

<a id="g155"></a>

- **G155** When operating a database client in production. Then Reuse sql.DB as the connection pool and configure maximum open connections to match database capacity. Multiple pools may be appropriate for distinct workloads. Do not build a redundant manual pool around sql.DB or close the pool after every query. Because sql.DB is not a single connection and unlimited growth can overload the database.

  Sources: `BP155`.

<a id="g156"></a>

- **G156** When tuning database connection reuse. Then Set idle count, idle time, and maximum lifetime for request concurrency, bursts, and load balancing. Select values for the actual workload. Tune idle count for concurrency, idle age to release post-burst capacity, and lifetime for rotation or balanced use of connections. Because Too few idle connections cause reconnects, while stale idle or long-lived connections consume resources or concentrate load.

  Sources: `BP156`.

<a id="g157"></a>

- **G157** When repeating SQL or handling untrusted values. Then Use parameterized prepared statements where appropriate and keep values separate from SQL text. The book emphasizes Prepare, but parameterization and explicit preparation are separate concerns for later review. Statements must be closed. Stmt is reusable and safe for concurrent calls in the source API. Use context variants when cancellation matters and account for driver behavior. Explicit Prepare is not required merely to separate bound parameters from SQL text. Because Avoids repeated compilation and reduces injection risk.

  Sources: `BP157`.

<a id="g158"></a>

- **G158** When scanning nullable database columns. Then Use pointer destinations or sql.NullXXX and check nil or Valid before using the value. Go 1.22+ also provides sql.Null[T]. Handle Scan errors separately from a valid SQL NULL. Because Scanning NULL into a plain scalar can fail.

  Sources: `BP158`, `RV259`.

<a id="g159"></a>

- **G159** When finishing a rows.Next loop. Then Check rows.Err after iteration. Also handle query and Scan errors and close Rows. Handle query, Scan and meaningful Close errors as well as the iteration error. Because Next returning false means either exhaustion or failure.

  Sources: `BP159`.
