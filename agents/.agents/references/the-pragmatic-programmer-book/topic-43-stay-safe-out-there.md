## Topic 43: Stay Safe Out There

Developers must maintain constant security awareness because external actors actively target connected systems. Functioning code represents only a portion of the software development lifecycle. Developers must defend against internal errors and deliberate external attacks. Relying on security through obscurity does not protect systems.

Effective security relies on five foundational principles:

- Minimize attack surface area: Simplify code to reduce attack vectors. Treat external inputs, unauthenticated services, authenticated services, output data, and debugging information as potential attack vectors. Sanitize all incoming external data before processing.
- Principle of Least Privilege: Assign the minimum required privilege level for the shortest duration necessary. Relinquish elevated privileges immediately after completing privileged operations.
- Secure Defaults: Set default application configurations to the most secure settings, allowing users to choose convenience trade-offs explicitly.
- Encrypt Sensitive Data: Encrypt personally identifiable information, financial data, and credentials at rest and in transit. Keep Application Programming Interface (API) keys, Secure Shell (SSH) keys, and secrets out of version control by managing secret values in environment variables or configuration files.
- Maintain Security Updates: Apply security patches quickly across all servers, developer machines, and deployment images to prevent exploits against known vulnerabilities.

### The Pragmatic Approach

- Maintain a mindset of healthy paranoia throughout system design, implementation, and deployment.
- Reduce code complexity to shrink the system attack surface area and simplify auditing.
- Sanitize all external inputs and obscure sensitive output data to prevent information leaks.
- Enforce granular, role-based access controls and drop administrative privileges immediately after completing privileged tasks.
- Keep secrets and credentials outside source code repositories, using environment variables or dedicated secret management systems.
- Utilize established, open-source cryptographic libraries and third-party authentication services instead of building custom authentication or encryption logic.
- Install security patches promptly across all environments to eliminate known vulnerabilities.

### Common Mistakes

- Assuming external attackers will ignore small, obscure, or internal systems.
- Treating software as complete once features work, while ignoring edge cases, resource leaks, and malicious inputs.
- Exposing sensitive debugging information, detailed stack traces, or unauthenticated data stores to external users.
- Operating applications with root or administrator privileges continuously.
- Hardcoding secrets, API keys, or private keys directly inside version control repositories.
- Implementing counterproductive password rules, such as restricting password length below 64 characters, disabling paste functionality, forcing frequent arbitrary password resets, or requiring security questions.
- Writing custom cryptography algorithms or custom authentication mechanisms rather than relying on vetted, peer-reviewed implementations.
- Deferring security patch installation to avoid minor software breakage.
