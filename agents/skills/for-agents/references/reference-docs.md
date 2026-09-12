# Reference Documents

Use this reference for focused documentation reached through conditional links from agent instructions or skills.

## Choose The Boundary

Extract detail when only some tasks need it: subsystem constraints, decision tables, failure modes, or operational procedures. Define the topic and relevant tasks in the opening sentence. Keep prerequisites, exceptions, and failure handling with the rule or procedure they qualify.

A reference may contain steps. Choose a skill when a reusable workflow needs its own invocation; choose a reference when an existing entrypoint can route to the material.

Use the repository's established location for agent references. If none exists, choose a tool-neutral directory such as `.agents/references/` or `docs/agents/`. For skill-specific detail, use the skill's `references/` directory. Name each file after its topic.

## Connect The Reference

Replace extracted text with a link in the entrypoint the agent already receives. State the triggering task and what the linked document covers. Use a Markdown link or backticked path for conditional reading. Check runtime behavior before using syntax that may import a file eagerly.

For example, when the document covers both changes and review:

```markdown
Before creating, changing, or reviewing migrations, read [migration guidance](migration-guidance.md) for pairing, verification, and reversal constraints.
```

That example's filename is illustrative; use the actual target path. Enumerate distinct actions from the document's scope instead of relying on a broad synonym such as "working with."

Prefer a direct link from the relevant entrypoint. Add another reference level only when navigation benefits justify the extra lookup. Keep frequently needed decisions near the step that uses them.

## Verify Extraction And Maintenance

Compare the source and destination. Confirm that all moved requirements, commands, exceptions, and recovery limits survive with their original force. Check that the entrypoint retains broadly applicable rules and routes conditional cases to their details.

Resolve links relative to the containing file. Exercise each triggering task, including review when the reference supports it, and a nearby task that should skip the reference. Verify both retrieval and correct application.

When behavior changes, update its authoritative document and affected pointers together. If a needed reference is missed, repair its trigger before moving the entire document inline. Remove an unused document only after checking its callers and remaining purpose.
