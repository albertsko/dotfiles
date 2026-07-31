## Topic 32: Configuration

Externalize values that change across environments, deployment targets, or business conditions. Keeping environment-specific details outside the application parameterizes the code, allowing the application to adapt to different runtime contexts without requiring code rebuilds.

Common candidate values for external configuration include:

- Credentials for databases and third-party services.
- Logging levels and output destinations.
- Port numbers, IP addresses, and hostname settings.
- Environment-specific validation parameters.
- Business parameters such as tax rates.
- Site-specific formatting options and license keys.

### The Pragmatic Approach

- Parameterize application code by storing environment and customer settings outside the main code repository.
- Wrap configuration access behind a thin API. Encapsulating configuration data prevents application logic from depending on specific file formats or database schemas.
- Use configuration services for high-availability applications. Storing configuration behind a service API allows dynamic parameter updates without stopping application instances, enables central access control, and simplifies multi-application sharing.

### Common Mistakes

- Over-configuring the application. Making every field configurable bloats administrative code and creates thousands of unnecessary variables.
- Pushing design decisions into configuration out of laziness. Test a sensible default behavior and gather feedback instead of deferring decisions to operators.
- Exposing raw configuration data structures globally across the codebase.
- Forcing full application restarts to change minor runtime parameters.
