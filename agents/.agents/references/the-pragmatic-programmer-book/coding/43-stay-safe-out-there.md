## 43. Stay Safe Out There

Treat code that passes functional tests as unfinished until you have analyzed it for accidental failure and deliberate abuse. Secure software minimizes every path that can accept input, reveal data, or execute behavior; grants only necessary privileges; starts with secure settings; protects sensitive data; and stays current with security fixes. Assume every connected system will be discovered and attacked because obscurity provides no protection.

### The Pragmatic Approach

- Extend the test suite beyond expected behavior. Cover bad parameters, unavailable resources, data leaks, malicious input, and deliberate service abuse.
- Keep code small and simple, and remove unused endpoints, services, accounts, and administrative facilities. Every extra access point and interaction creates another opportunity for an attacker.
- Treat all external data as hostile. Validate and sanitize it before database access, view rendering, command execution, or other processing; for example, never interpolate an untrusted filename into a shell command.
- Require authentication for services that expose data or behavior. Constrain intentionally public services to reduce denial-of-service risk, and verify that cloud data stores are not publicly readable.
- Minimize authorized users and services. Delete stale accounts, replace default passwords, disable unused administrative access, and protect deployment credentials as keys to the entire product.
- Reveal only the data each user is authorized to see. Use non-disclosing error messages, truncate or obfuscate sensitive identifiers, and keep stack traces, test windows, and runtime diagnostics away from users.
- Grant each program and user the least privilege required for the current operation. Elevate privileges only when necessary, perform the smallest possible task, and relinquish them immediately; prefer fine-grained resource permissions over broad administrator roles.
- Make the safest behavior the default and require an explicit choice to weaken it. Mask password input by default, for example, while allowing a user to reveal it when accessibility or context makes that trade-off reasonable.
- Encrypt personally identifiable information, financial data, and other sensitive values stored in databases or files. Never commit secrets, application programming interface keys, Secure Shell keys, encryption passwords, or other credentials to version control; manage them separately through deployment configuration or environment variables.
- Encourage long, random, high-entropy passwords. Accept at least 64 characters without truncation, allow printable characters, spaces, and Unicode, and preserve browser paste support; avoid composition rules, public hints, security questions, and scheduled password changes without evidence of compromise.
- Apply security patches quickly to developer machines, build systems, servers, cloud images, and every other connected device. Resolve compatibility problems without leaving a known exploit exposed.
- Never invent cryptographic algorithms or implement authentication casually. Use well-vetted, thoroughly examined, actively maintained, frequently updated libraries, and prefer a specialist authentication provider when its operating model fits the application.
