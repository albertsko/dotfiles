## 3. Software Entropy

Software entropy is the accelerating disorder that appears when a team tolerates bad designs, wrong decisions, and poor code. A single neglected defect signals that quality no longer matters, making further degradation feel acceptable and spreading hopelessness across the team. Protect a healthy codebase by repairing each problem quickly, containing problems that cannot yet be fixed, and avoiding collateral damage even under deadline or incident pressure.

### The Pragmatic Approach

- Fix each bad design, wrong decision, or piece of poor code as soon as you discover it, before surrounding work copies or depends on the flaw.
- Contain any problem you cannot fix properly now. Disable the offending code path, return an explicit `Not Implemented` response, or substitute controlled dummy data so the problem cannot spread unnoticed.
- Refuse to normalize decay. Treat existing poor code as a problem to improve, not as permission to add more poor code.
- Protect nearby code during emergencies. Assess the situation, resolve the immediate failure, and avoid changes that create unrelated defects or unnecessary cleanup.
- Survey the codebase with your team, choose two or three visible quality problems, and agree on a concrete repair or containment action for each one.
- Raise harmful decisions early, including decisions outside your control. Explain their technical impact and propose a specific fix or temporary containment measure.
