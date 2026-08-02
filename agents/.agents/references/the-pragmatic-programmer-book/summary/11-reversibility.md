## 11. Reversibility

Software projects operate in a changing world: requirements, users, hardware, available skills, vendors, technologies, architectures, and deployment models can shift after critical choices are made. Treating a database, vendor, architectural pattern, interface, or deployment model as permanent steadily narrows the project's options and can make later change prohibitively expensive. Preserve reversibility by decoupling components, moving changeable choices into external configuration, and hiding persistence and third-party products behind abstractions so implementations, interfaces, and deployment arrangements can be replaced with limited impact.

### The Pragmatic Approach

- Treat every technical and vendor decision as provisional.
- Avoid unnecessary irreversible commitments.
- Identify plausible alternatives and estimate the cost of switching to each one.
- Apply the Don't Repeat Yourself principle so a changed decision does not require updates in multiple places.
- Hide third-party application programming interfaces behind abstractions that the project controls.
- Expose persistence as a service instead of scattering database-specific calls through the code.
- Separate client rendering from server behavior so a browser interface can give way to an application programming interface or mobile client.
- Divide the system into decoupled components, even when deploying them together.
- Place changeable choices in external configuration.
- Reject architectural fads that do not serve the project's needs or preserve its options.
- Revisit critical decisions as requirements, constraints, and available technology change.
