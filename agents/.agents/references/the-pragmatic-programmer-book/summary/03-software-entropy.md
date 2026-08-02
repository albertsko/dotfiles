## 3. Software Entropy

Software entropy is the growing disorder often called software rot or technical debt. The promise implied by technical debt that it will be repaid later is unreliable. A project’s culture, even on a one-person project, is the most important factor in whether disorder spreads, and neglect accelerates decay faster than any other factor. A bad design, wrong decision, or poor piece of code left unrepaired acts like a broken window: it signals that no one cares, makes further damage seem acceptable, and spreads hopelessness through the team. Fix each defect promptly or visibly contain it when a complete repair is not yet possible. Even during a crisis, avoid collateral damage because one tolerated flaw can start a rapid decline while a clean system encourages continued care.

### The Pragmatic Approach

- Fix bad designs, wrong decisions, and poor code as soon as you discover them.
- Contain any defect you cannot fix immediately by disabling the offending code, displaying a clear “Not Implemented” message, or substituting controlled dummy data. Make the containment explicit so it prevents further damage and shows that the defect is being managed.
- Protect unaffected code and design choices when responding to deadlines, releases, demonstrations, or other crises.
- Refuse to imitate existing poor practices; improve the project instead of adding more damage.
- Survey the project for two or three neglected problems, discuss their impact with the team, and agree on concrete repairs.
- Identify the first sign of decay, raise the concern, and propose a practical response even when the problem comes from someone else’s decision or a management directive.
