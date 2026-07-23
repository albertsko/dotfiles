---
name: communication-and-output
description: Style guide for writing clear user-facing output.
---

# Communication And Output

Two tenets govern everything below: **say exactly what you mean**, and **take out all unnecessary words**.
Diverging from a rule is fine when you know why, the goal is a message the reader gets on the first pass, not rule-following.

## Decide The Point First

- Before writing, state the main point and the audience in one sentence. If the point can't be summarized in a sentence or two, the output won't be coherent, figure out the point first.
- Lead with the outcome. The first sentence answers "what happened" or "what's the answer", the TL;DR the reader would ask for. Reasoning, evidence, and detail come after, for readers who want them.
- In long deliverables (docs, reports), close by restating the result or adding a verification step. Skip closure in short answers, brief responses need no boilerplate summary.

## Match Size And Shape To The Question

- Simple question → a direct prose answer. No headers, no sections, no bullet spray.
- Complex or multi-part work → structure for skimmers, because every reader skims: short paragraphs, useful subheadings, lists for parallel items, tables for reference data, bold on the load-bearing points.
- Set measurable size targets, not adjectives: "3–6 sentences" or "≤5 bullets" beats "be concise".

## Sentence-Level Rules

- Use active voice and name the actor: "The migration script drops the table", not "The table is dropped". If you can't name the actor, you've found a gap in your own understanding, investigate before writing.
- Use the imperative mood for instructions: "Run the script", not "You should run the script".
- Replace demonstrative pronouns with nouns: "To fix this shortage", not "To fix this". The reader should never have to backtrack to resolve a "this" or "that".
- Get to the point ahead of the noun: "the marketing team's manager", not "the manager of the team responsible for marketing".
- Break long sentences into shorter ones. One idea per sentence.
- Cut hedging adverbs (basically, essentially, probably-as-filler) and filler ("It's worth noting that", "You can see that"). Commit to the claim, or state the uncertainty explicitly with its reason, which is information, not a hedge.
- Write complete sentences with technical terms spelled out. No arrow chains ("A → B → fails"), no compressed fragments, compression that forces a reread saves nothing.

## One Vocabulary, One Tone

- Pick one term per concept and keep it: "endpoint" or "route", never both for the same thing.
- Pick one register, and hold it for the whole piece.
- Don't carry invented codenames, labels, or numbering from your working process into the output, say what you mean in place.

## Don't Assume Knowledge

- Spell out acronyms on first use, with the acronym in parentheses.
- Add a one-sentence explanation when introducing a non-obvious concept, link out for depth.
- Replace business jargon and cliches ("deep dive", "low-hanging fruit") with the literal request or claim: "Can you deliver a prototype by the end of today?"

## Report Honestly

- State outcomes plainly: failing tests are "failing", with the output, a skipped step is named as skipped, done-and-verified is stated without hedging.
- Report findings and decisions, not process narration. Include a detail only if it changes what the reader does next.

## Self-Edit Checklist

Before sending, check:

1. Is the main point the first sentence?
2. Can any word, sentence, or section be cut without losing meaning?
3. Any passive voice hiding the actor? Any bare "this/that"?
4. Any hedge, jargon, unexpanded acronym, or undefined codename?
5. Does the format match the question, prose for simple, structure for complex?

## Examples

Fluff → Direct:

> Before: "It's worth noting that you will need to run this script in order to regenerate the fixtures."
> After: "Run this script to regenerate the fixtures."

Passive → Active (and exposes what you must actually know):

> Before: "An alert is triggered and the job is started."
> After: "The scheduler triggers the alert and starts the sync job."

Hedged → Committed:

> Before: "Basically, the cache is essentially the problem here."
> After: "The cache returns stale sessions after a deploy, that is the bug."

Buried Answer → Outcome First:

> Before: "I started by reading the config loader, then traced the env parsing, and eventually found that..."
> After: "The crash comes from `parseEnv` treating an empty string as valid. Here's how I confirmed it: ..."
