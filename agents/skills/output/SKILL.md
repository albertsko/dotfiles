---
name: output
description: "Plain-language style guide for concise, accurate human-facing text."
---

# Output

Write for a busy, non-native reader who reads once.

## Priorities

Use this order: accuracy, coverage, clarity, brevity. A lower priority never weakens a higher one. Treat the remaining rules as defaults that serve these priorities.

## Draft

1. Name the main point and the audience in one sentence before writing. If you cannot, find the point first.
2. Open with the outcome, answer, or recommendation. Put reasoning and detail after it.
3. Account for every requested fact, prerequisite, caveat, action, and decision before shortening the draft.
4. Remove repetition, irrelevant background, and structure that does not help the audience.
5. End a long deliverable with the result, next action, or verification. End a short answer when the answer is complete.

Before finishing, check that the draft addresses the user's main requests, follows applicable Grounding rules, and helps the reader understand or act.

## Grounding

- For a rewrite or summary, preserve every material source fact and add no unsupported facts.
- For an answer or explanation, use established knowledge, but do not invent local facts, causes, mechanisms, guarantees, commands, or results. State a material assumption or uncertainty and its reason.
- Preserve the source's certainty, permission, timing, and scope. Do not turn a possibility into a fact or advice into a requirement.
- Keep code, identifiers, quoted errors, names, dates, and numbers exact.
- State a changed value as old then new, once: "retries: 5 → 6".
- Report outcomes plainly. Call a failure "failing" with its output, and name any skipped step.

## Structure

- A simple question or chat reply gets direct prose. Add light structure when it exposes a useful contrast or action.
- Complex work gets short paragraphs, useful headings, and lists for parallel items.
- Use a table only when comparison or lookup is faster in rows and columns than in prose.
- Nest a list only when the hierarchy matters. Number only ordered steps.
- State each fact in the section where the reader needs it. A later section adds detail instead of repeating the summary.
- Keep one topic per paragraph and at most six sentences per paragraph.
- Give size limits as numbers ("at most 5 bullets"), not adjectives ("be concise").

## Sentences

- Keep one idea per sentence. Aim for at most 20 words in an instruction and 25 in an explanation, but keep a cause and its effect together.
- Use the active voice and name the actor when the source identifies one.
- Use the imperative for instructions: "Run the script."
- Put a condition before its command: "If the build fails, read the log."
- Lead a warning with the command, then state the risk: "Do not run the production migration. It drops the table."
- Prefer simple tenses: "The migration completed."
- Replace a semicolon or an em dash with two sentences, a comma, a colon, or parentheses.
- Use straight ASCII quotation marks: double quotes (`"`) and apostrophes (`'`).
- End a list's lead-in with a colon.

## Words

- Describe an action with a verb: "compress the file", not "perform compression of the file".
- Pick one term per concept. Choose a tone and register for the audience and purpose, then keep them consistent.
- Choose modal verbs that preserve the claim. Use `must` for requirements, `can` for ability or permission, and `may`, `might`, or `could` for real uncertainty or possibility. Prefer an imperative to `should` for an instruction.
- Pick the plain word: however → but, therefore → so, e.g. → for example, i.e. → that is, ensure → make sure that, utilize → use, in order to → to, prior to → before.
- Delete an adverb only when it carries no fact. Keep words that express manner, timing, degree, or uncertainty.
- Delete empty words and phrases: basically, essentially, simply, just, robust, seamlessly, "it is worth noting".
- Give a bare "this" or "that" its noun: "this timeout".
- Spell out an acronym on first use, and explain a non-obvious concept in one sentence.
- Break a noun chain longer than three words with prepositions: "the timeout value for the connection pool".

## Guides And Procedures

- Put the key facts in the title or first line: date, time, duration, and scope. Resolve a relative date only when the source supplies a base date.
- Give each concern its own labeled line or section. Keep the failure path separate from the normal path.
- State a gotcha as cause, then effect: "A local Postgres on port 5432 makes `docker compose up` fail."
- Name a prerequisite before the step that needs it, and explain an unfamiliar tool in one clause.
- For each command-line action, give an exact command when the source or verified documentation supports it. Fill known values and explain how to obtain any missing value instead of guessing.
- Give each operational step an observable success signal. End with a supported recovery path or a clear escalation condition.
