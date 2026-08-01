## 31. Inheritance Tax

Inheritance grew from Simula’s prefix classes, which combined linked-list behavior with different objects to provide polymorphism, and Smalltalk’s dynamic reuse of behavior for objects that were alike except for specific differences. Developers now commonly use inheritance either to share implementation or to model “is-a” types, but both uses create coupling: subclasses and their clients depend on ancestor application programming interfaces and internal state, inherited methods weaken control over a class’s interface, and deep or multiple classification hierarchies become brittle or cannot accurately represent overlapping roles. Interfaces and protocols provide polymorphism by defining required behavior without inherited implementation, delegation lets a class expose only the operations it needs from a service, and mixins or traits add named sets of reusable functionality to existing classes or objects. Choose the alternative that directly expresses the need: type compatibility, service use, or shared methods.

### The Pragmatic Approach

- Pause before subclassing and identify whether the goal is polymorphism, service use, or code reuse.
- Define narrow interfaces or protocols when unrelated classes need to support the same operations.
- Delegate work to contained services and expose only the operations that clients need.
- Separate domain rules from persistence and other infrastructure when an object does not need to manage those concerns itself.
- Add reusable behavior with focused mixins or traits, including context-specific capabilities such as validation.
- Keep class interfaces small and avoid coupling clients to ancestor APIs or internal state.
