# SKILL.md

Package reusable, on-demand guidance as a skill with a clear job and predictable entrypoint.
A skill can provide a procedure, reference rules, or both. Related branches can share one router.

## Package only what the task needs

```text
skill-name/
|-- SKILL.md              Required frontmatter and instructions
|-- agents/openai.yaml    Optional Codex interface and invocation policy
|-- references/           Conditional guidance
|-- scripts/              Executable helpers
`-- assets/               Files used in generated output
```

Create optional files only when they have a concrete use.
Split a skill when a distinct task needs independent invocation or a separate sequence improves execution.
Keep related branches together when shared guidance and precise pointers make the choice clear.

## Frontmatter and invocation

- Match `name` to the folder name. Use lowercase letters, digits, and hyphens, with at most 64 characters.
- Include a nonempty `description` of at most 1024 characters. Preserve supported optional metadata.
- Preserve the current invocation policy unless the user asks to change it.
- For automatic discovery, describe the actual task and distinct triggers using the words users use. Include exclusions only for likely misrouting.
- When explicit-only invocation is requested, use a concise human-facing description and set `disable-model-invocation: true` where supported.
- Verify optional fields against the target tool's supported schema before adding them. Shared packaging does not guarantee identical behavior across tools.

For Codex metadata in `agents/openai.yaml`:

- Quote string values and leave keys unquoted.
- Keep `interface.display_name` aligned with the skill and `interface.short_description` between 25 and 64 characters.
- When explicit-only invocation is requested, set `policy.allow_implicit_invocation: false`. Preserve this policy for existing explicitly invoked skills.
- Preserve unrelated policy, interface, and dependency fields when editing metadata.
- Add optional interface fields only when requested. If a `default_prompt` is supplied, include `$skill-name` in its short example prompt.

## Instructions and resources

Keep shared purpose, essential constraints, and branch pointers in `SKILL.md`.
Link each reference directly from the entrypoint and state the exact condition for reading it.
Load only the references needed for the current task, with each meaning maintained in one file.

For procedures, state inputs, actions, outputs, and completion criteria where they affect execution.
Give a preferred approach and the condition that warrants another approach.
Use exact sequences for fragile operations and decision criteria for open-ended work.
Include examples when they resolve ambiguity, rather than requiring a fixed example count.

Bundle a script when repeated code or deterministic execution justifies it.
Distinguish "run this script" from "read this script" and give the working directory, arguments, dependencies, and expected result.
Make failure behavior clear enough for the agent to recover or stop at the appropriate boundary.
Keep templates and other output materials in assets, inspecting them when the task requires it.

## Validate and iterate

- Check frontmatter, folder naming, metadata, and referenced paths against the target setup.
- Use an available skill validator within its supported schema. Report unsupported fields instead of removing an intentional policy to pass validation.
- For automatic discovery, evaluate representative trigger prompts and nearby prompts that need a different skill.
- Evaluate output quality separately from discovery. Use a fresh session or independent review when complexity warrants it and delegation is authorized.
- Run new or changed executable helpers with meaningful inputs. Review text changes against the requested behavior without adding tests that only mirror wording.
- If a reference is missed, improve its trigger. If every branch needs it, reconsider its placement. Revise from observed failures and prune obsolete guidance.
