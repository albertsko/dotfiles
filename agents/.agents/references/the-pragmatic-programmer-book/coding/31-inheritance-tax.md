## 31. Inheritance Tax

Class inheritance couples subclasses and their clients to ancestor APIs and implementation details, so a parent change can break code that appears to depend only on a child. Deep hierarchies also expose unwanted methods, become brittle as changes ripple through their layers, and cannot cleanly model objects with several independent roles. Prefer interfaces or protocols for polymorphic contracts, delegation to compose focused services behind a controlled API, and mixins or traits to share reusable behavior.

### The Pragmatic Approach

- Challenge every proposed subclass: identify whether the actual need is a type contract, access to a service, or shared behavior.
- Express independent roles with small interfaces or protocols. For example, make a `Car` implement `Drivable` and `Locatable`, then accept `Locatable` wherever code only needs location behavior.
- Type consumers against the narrow interface they use so unrelated implementations remain interchangeable without sharing an ancestor.
- Delegate work to focused services and expose only the operations the domain object needs. For example, let an `Account` call a persister internally through `save` instead of inheriting the persister's entire API.
- Control access to framework services through the domain object's API so clients cannot bypass domain-specific operations and call the framework API directly.
- Separate responsibilities when delegation still burdens the domain object. Keep business rules in `Account` and wrap it with an `AccountRecord` that handles storage.
- Use focused mixins or traits to add reusable implementations, such as common record finders, to multiple classes without creating a class hierarchy, often without requiring access to each class's source.
- Compose context-specific capabilities instead of controlling a large class with flags. For example, combine common account validations with either customer or administrator validations so each object applies the correct rules automatically.
- Keep public APIs small and avoid deep type trees; model additional roles as separate interfaces, delegated services, or mixins rather than adding more ancestors.
