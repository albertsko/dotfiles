## Topic 12: Tracer Bullets

**Tracer bullet development** creates an end-to-end architectural skeleton that connects every layer of a system early in development. Developers use tracer code to achieve immediate, real-time feedback in complex projects with vague requirements, unfamiliar technologies, or changing environments.

Unlike disposable prototypes, **tracer code is production code written for keeps**. It includes complete error checking, documentation, and testing structure, but implements only minimal end-to-end functionality.

| Technique       | Purpose                                         | Code Lifecycle                              | Focus                                |
| :-------------- | :---------------------------------------------- | :------------------------------------------ | :----------------------------------- |
| **Tracer Code** | Exercises the end-to-end system architecture    | Production code kept as the system skeleton | System integration and workflow      |
| **Prototyping** | Explores specific isolated risks or UI concepts | Disposable code thrown away after learning  | Specific algorithm or interface risk |

### The Pragmatic Approach

- **Build an early project skeleton**: Start with a simple end-to-end build, such as a basic application pass-through, to verify compilation and deployment across all architectural layers.
- **Select representative features**: Pick core features that traverse the entire system stack, connecting UI, business logic, and database components.
- **Write production-grade code**: Construct tracer code with full error handling, proper documentation, and testing frameworks so the code remains part of the final application.
- **Integrate continuously**: Use the connected tracer skeleton as an integration platform to add and test new functionality daily.
- **Demonstrate working software early**: Present real, working software to users frequently to gather actionable feedback and clarify vague requirements.
- **Adjust aim based on feedback**: Refine and adapt the lean tracer codebase quickly whenever user testing or performance metrics reveal a missed target.

### Common Mistakes

- **Confusing tracer code with prototyping**: Writing low-quality, disposable code under the guise of tracer development instead of building a production-ready skeleton.
- **Relying on big up-front design**: Attempting to specify every requirement and edge case upfront using dead reckoning instead of seeking real-time feedback.
- **Deferring system integration**: Developing individual modules in isolation and attempting a risky big-bang integration late in the project.
- **Overbuilding the initial pass**: Implementing full business logic in the first tracer round instead of establishing a minimal end-to-end slice.
- **Ignoring user feedback**: Continuing down an incorrect path without adjusting aim when early tracer demos reveal mismatched requirements.
