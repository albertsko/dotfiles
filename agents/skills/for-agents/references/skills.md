# Skills

Use this reference for skill descriptions, invocation, workflow design, and validation.

## Package And Route

Create a skill for a reusable task that benefits from non-obvious guidance. Keep related branches together when they share an invocation; split when they need independent discovery or execution.

Put `SKILL.md` in a folder matching its frontmatter `name`. Use lowercase letters, digits, and hyphens for the name. Check the target format's current field constraints.

Use this package layout, creating optional files only when the task needs them:

```text
skill-name/
  SKILL.md             # Required: YAML frontmatter and Markdown instructions
  agents/openai.yaml   # Optional: UI metadata and invocation policy
  references/          # Optional: documentation read on demand
  scripts/             # Optional: executable helpers
  assets/              # Optional: files used in generated output
```

## SKILL.md Structure

Start with YAML frontmatter between `---` delimiters. Both `name` and `description` are required. Follow it with a Markdown title and task-specific instructions.

This minimal `review-config/SKILL.md` example shows purpose, inputs, actions, and completion. Adapt the body to the task; these headings are not required fields.

```markdown
---
name: review-config
description: "Use when reviewing configuration changes against a schema or documented requirements."
---

# Review Config

Find configuration changes that violate verified requirements.

## Inputs

Use the supplied configuration changes and their schema or documented requirements. Identify missing requirements before judging a value.

## Review

1. Read the changed configuration and its applicable requirements.
2. Compare each changed value with its constraints. Record each mismatch's location, violated rule, and consequence.

## Completion

Return the findings, or state that no mismatches were found. Identify any changes that could not be checked and why.
```

For a reference or router skill, replace the sequence with decision rules or conditional reference links. Keep guidance needed by every branch in the body.

## Description And Invocation

Write a `description` with concrete triggering conditions, such as "Use when ..." for automatic discovery or "Use only on explicit ..." for explicit invocation. Keep workflow instructions in the body. Include a boundary only when it prevents a plausible wrong selection.

Preserve the existing invocation policy unless the user requests a change. For a new skill, choose automatic discovery when agents need to select it themselves; choose explicit invocation when requested by the user. Check the target runtime's supported policy fields.

For the local explicit-only convention, pair frontmatter such as `pragmatic-code/SKILL.md`:

```markdown
---
name: pragmatic-code
description: "Use only on explicit pragmatic-code request for architecture or implementation guidance."
disable-model-invocation: true
---
```

With the corresponding policy in `pragmatic-code/agents/openai.yaml`:

```yaml
policy:
  allow_implicit_invocation: false
```

For a new automatically discoverable skill, omit `disable-model-invocation`, as in the minimal example. Leave `allow_implicit_invocation` absent or set it to `true`. Describing an explicit trigger does not replace policy configuration.

Keep UI metadata consistent with the skill. A router can direct agents to bundled references without relying on another skill's invocation policy.

## Shape The Workflow

Identify inputs, output, prerequisites, and the evidence that marks each step complete. Use an ordered sequence only when actions depend on earlier results. Give flexible decisions observable criteria; reserve exact commands and fixed order for fragile operations.

Use a focused example when it resolves ambiguity. Bundle scripts when repeated execution benefits from deterministic behavior, and distinguish running a script from reading it. Document required dependencies and verify execution. Add assets only when the produced artifact needs them.

If a step is repeatedly rushed, sharpen its completion criterion first. Split the sequence only when testing shows that separation helps.

## Test Before Finalizing

For behavior-shaping changes, run a realistic scenario without the proposed guidance first. Record the produced artifact and observed failure. Draft the smallest guidance that addresses that failure.

Run the same scenario in fresh contexts with the skill. Repeat controls and guided runs when assessing variable behavior. Keep task facts and scoring criteria constant. Inspect decisions and artifacts, including every apparent failure.

Test reference retrieval and application for each affected branch. Include a near-miss request that uses similar terms but needs different work. Check selection separately from output quality.

Validate metadata, directory/name agreement, invocation fields, relative links, and any scripts. Report unresolved failures and skipped checks. Finalize when the demonstrated failure is corrected, required facts remain intact, and branch tests show no material regression.
