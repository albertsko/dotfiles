## 43. Stay Safe Out There

Working code is not finished until developers analyze both accidental failures and deliberate abuse, add corresponding tests, and treat every internet-connected system as exposed because obscurity offers no protection. Security starts with reducing the attack surface: keep code simple; validate and sanitize all external input; authenticate services; limit authorized accounts; reveal only appropriately authorized output; and hide debugging data. Grant each program and user the least privilege needed for the shortest time, partition access finely, and make default settings the most secure while allowing users to make explicit convenience tradeoffs. Encrypt personally identifiable information, financial data, passwords, and credentials, and keep secrets and keys out of version control by managing them separately in deployment configuration. Encourage long, random passwords without truncation, restrictive composition rules, disabled paste, unauthenticated hints, or arbitrary forced rotation, and apply security patches quickly to every connected device and system despite compatibility costs. Never invent cryptography or casually implement authentication; use well-vetted, maintained, frequently updated libraries and consider specialized authentication providers that can shoulder the security and legal burden.

### The Pragmatic Approach

- Analyze how code can fail accidentally or through deliberate abuse, then add those cases to the test suite.
- Keep code and services small, simple, and limited to the access points the system needs.
- Treat all external input as hostile, and validate and sanitize it before storage, rendering, execution, or other processing.
- Authenticate services, restrict public endpoints, and remove unused or outdated users, accounts, and services.
- Return only data appropriate to each user's authorization, obscure sensitive identifiers, and protect stack traces and debugging facilities.
- Grant the least privilege required, hold elevated access for the shortest possible time, and divide sensitive resources into fine-grained permission categories.
- Choose the most secure defaults, then let users explicitly accept convenience tradeoffs.
- Encrypt sensitive data at rest, and manage secrets, keys, and credentials outside version control through deployment configuration or environment variables.
- Accept long, high-entropy passwords without truncation, composition rules, paste restrictions, public hints, or scheduled rotation without evidence of compromise.
- Apply security patches quickly to every connected device, development system, build system, server, and deployed image.
- Use well-vetted, maintained, frequently updated cryptographic libraries, and delegate authentication to a specialized provider when appropriate.
