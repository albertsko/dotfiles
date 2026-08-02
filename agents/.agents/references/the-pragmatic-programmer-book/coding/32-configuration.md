## 32. Configuration

External configuration lets an application adapt after deployment by keeping changeable, environment-specific, and customer-specific values outside the code, so changing runtime behavior does not require a rebuild. Store configuration in formats suited to its ownership and use, access it through a thin application programming interface (API) instead of a global data structure, and use an authenticated configuration service when applications must share values or receive changes without restarting.

### The Pragmatic Approach

- Externalize values that can change after deployment, such as service credentials, logging levels and destinations, network addresses, validation parameters, tax rates, formatting rules, and license keys.
- Choose storage based on how the configuration changes: use a plain-text format such as YAML or JSON for static settings, and use a database table for structured values that customers edit. Split configuration across both when their uses differ.
- Read static configuration into a data structure at startup, but expose it through a thin API. Keep callers independent of the storage format and representation.
- Put shared or runtime-changeable configuration behind a service API. Centralize shared values so one change can take effect across applications, apply authentication and access control so each application can read only the values it needs, and provide a specialized user interface when operators or customers maintain those values.
- Subscribe components to updates for the parameters they use, and apply new values when the configuration service sends notifications. Avoid rebuilds and restarts for parameter-only changes.
- Configure only genuine sources of variation. Do not make every field configurable, because each option adds implementation and administration work.
- Resolve uncertain feature behavior in code first and gather feedback. Move the decision into configuration only when users or environments genuinely need different behavior.
