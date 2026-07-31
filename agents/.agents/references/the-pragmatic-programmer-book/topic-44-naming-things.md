## Topic 44: Naming Things

Good names reveal the intent, role, and motivation behind every variable, function, module, and system. Clear naming forces developers to understand the domain and code structure deeply during design.

### The Pragmatic Approach

- **Name by role and intent**: Choose names that express why an element exists and what role it plays instead of using generic labels or raw implementation details.
- **Honor community culture**: Follow the naming conventions, casing rules, and idiomatic practices of the specific programming language environment.
- **Maintain team consistency**: Establish a shared project vocabulary and glossary so team members use domain terms consistently across the codebase.
- **Rename immediately**: Update names as soon as code changes or intent shifts to ensure names always reflect current behavior.

### Common Mistakes

- **Using generic or meaningless names**: Assigning vague names like `user` or `data` when domain-specific terms like `customer` or `payload` clarify intent.
- **Naming by mechanism instead of purpose**: Describing how a function operates rather than why it performs the action.
- **Ignoring language idioms**: Violating local community conventions, such as forcing camelCase in a snake_case ecosystem or misusing loop variables.
- **Tolerating misleading names**: Leaving outdated names in place after code refactoring, which misinforms future readers.
