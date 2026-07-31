## Topic 31: Inheritance Tax

Object-oriented inheritance introduces tight coupling and unnecessary complexity into software systems. Developers often use inheritance either to share code across classes or to construct domain type hierarchies. Both usages create hidden dependencies: parent class implementation changes can break child classes and caller code, while deep type hierarchies turn into rigid, unmaintainable structures. Pragmatic programmers avoid class inheritance and favor flexible, decoupled alternatives.

### The Pragmatic Approach

Pragmatic programmers replace class inheritance with three effective design techniques:

- **Interfaces and Protocols**: Define method contracts without providing implementation code. Interfaces enable polymorphism across unrelated classes without coupling them to a shared base implementation.
- **Delegation**: Forward work to internal service objects rather than inheriting from base classes. Using composition ("Has-A") instead of inheritance ("Is-A") isolates class interfaces and breaks tight framework coupling.
- **Mixins and Traits**: Extend classes with reusable sets of methods without building class hierarchies. Mixins combine shared functionality across domain objects cleanly while maintaining modularity.

### Common Mistakes

- **Inheriting to share code**: Subclassing a base class solely to reuse implementation details couples child classes and callers to internal parent state and methods.
- **Building deep type hierarchies**: Modeling domain concepts using complex inheritance trees makes software brittle and hard to extend when domain roles overlap.
- **Subclassing framework classes**: Inheriting directly from persistence or UI base classes exposes unwanted framework methods on business domain objects.
