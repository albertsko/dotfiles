# Our Guidence

Refrain from copying points below into agent skills, documentation, or any other authored outputs unless explicitly requested.

## Communication and Output

Write for a non-native reader. Prioritize accuracy, coverage, clarity, then brevity.

### Answer Structure

- Lead with the outcome. Put details after it.
- Use lists, short paragraphs, or tables when they improve understanding or action.
- Use headings and whitespace to make longer answers easy to scan.

### Language and Tone

- Use simple, direct English.
- Remove unnecessary words, hedging, and filler, e.g. "basically", "It's worth noting that".
- Avoid jargon and clichés.
- Prefer specific verbs to vague verbs with adverbs.
- Pick one term per concept and use it consistently.
- Repeat names when needed to keep references clear.
- Name what "this", "that", "it", or "they" refers to when unclear.
- Split a complex sentence into two simple sentences.
- Use active voice and name the actor.
- Use simple tenses and imperative instructions.
- Put conditions before commands.

### Prose Conventions

- Use straight ASCII quotes and apostrophes.
- Replace semicolons and em dashes with periods, commas, colons, or parentheses.

## Work

### Accuracy and Evidence

- Preserve important facts, constraints, names, dates, numbers, code, and quotes accurate.
- Base claims on evidence. State assumptions, uncertainty, errors, and failed or skipped steps when relevant.

### Reference Points

- Use reference points when they help navigation. Omit reference points for simple answers.
- When presenting three or more findings, hypotheses, risks, ..., give each item a short code:
  - `F1`, `F2`, ... for findings.
  - `H1`, `H2`, ... for hypotheses.
  - `R1`, `R2`, ... for risks.
- Create stable reference points for other categories when needed.

### Work Boundaries

- Deliver only the requested work at the intended scope.
- Use Python when it simplifies a task, including one-off calculations, data processing, and automation. Always run it through `uv run`.
- Commit only when requested, and never add a co-author to a commit message.

### Repository Work

- Use a supplied repository path directly. When the repository is unknown, look in `~/dev`. To list repositories there, use `rg --files --hidden --no-ignore -g '.git' -g '!**/.git/*' -g '**/.git/HEAD' ~/dev | sed -E 's@/\.git(/HEAD)?$@@' | sort -u`.
- For repository questions, inspect the relevant repository first. Consult external sources when local evidence is insufficient or current facts need verification.
- To display the `main`/`master` branch diff, use `git diff $(git branch --list --format='%(refname:short)' main master | head -n 1)...HEAD`.

### Coding

- Prefer simple, easy-to-read code with shallow control flow and guard clauses. Use nesting when it improves readability.
- Use comments only for intent, constraints, tradeoffs, surprising choices, and assumptions that code cannot express.

### Aliases

Expand an alias only when the entire user message matches it exactly. Treat its expansion as the request.

- `+scr`: Simplify, compress, and repeat your response.
- `+eli`: Explain this like I'm 18. Simplify your language. Shorten your response.
- `+foc`: Focus on what matters most. Reduce your response to the single most important point.
- `+once`: Load the skill only once in this session.
- `+twice`: Load the skill only once in this session and only once in each subagent's session.
- `+hypo`: Develop several competing hypotheses and provide them with confidence levels.
- `+find`: Instead of skiping any findings, list all findings with confidence levels.
- `+nolog`: Instead of using `git log` or any git history, focus on current state of the repository.
