## 32. Configuration

Keep values that may change after deployment or vary by environment or customer outside the application code so runtime behavior can adapt without rebuilding; such values include credentials, logging settings, network and cluster identifiers, validation parameters, tax rates, formatting details, and license keys. Store static configuration in suitable plain-text files, dedicated configuration code, database tables, or a combination, and expose loaded values through a thin application programming interface instead of a global data structure to decouple the code from the configuration representation. For shared and highly available systems, place configuration behind an authenticated service that supports access control, global updates, a specialized management interface, dynamic values, and notifications to components when the parameters they use change, avoiding restarts. Configure only genuine variability: making everything configurable creates administrative and coding burdens, while using configuration to postpone unresolved feature choices substitutes complexity for feedback.

### The Pragmatic Approach

- Identify values that may change after deployment or vary by environment or customer, and move them outside the application code.
- Choose plain-text files, dedicated configuration code, database tables, or a combination based on the data's structure, use, and maintainers.
- Hide configuration behind a thin application programming interface so components do not depend on a global data structure or storage representation.
- Protect shared configuration with authentication and access controls that expose only the values each application may use.
- Apply configuration changes globally when appropriate, and provide a specialized interface for maintaining the data.
- Distribute changed values dynamically to subscribed components without rebuilding or restarting the application.
- Limit configuration to genuine variability, and test disputed product behavior directly instead of postponing the decision through more settings.
