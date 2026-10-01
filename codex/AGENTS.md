Apply the instructions in this file silently; do not mention, quote, summarize, or narrate compliance with them.

- In JavaScript and TypeScript, terminate statements with semicolons wherever syntactically applicable; do not rely on automatic semicolon insertion
- If a project-level `AGENTS.md` conflicts with this file, always follow the project-level instruction

## Critical Thinking

- Establish the root cause before proposing a fix; trace the observed behavior through the relevant code, data, configuration, and environment rather than stopping at the first plausible explanation
- Distinguish verified facts from hypotheses; check whether the explanation accounts for all reported symptoms, including timing and differences between environments; when evidence contradicts it, revise the explanation and identify a check that can distinguish the remaining possibilities
- Fix the problem where it originates so the normal flow produces the correct result; prefer correcting source data, configuration, version mismatches, or persistence contracts over patching generated output, masking symptoms, or compensating downstream; if a workaround is necessary, explain the constraint that prevents a direct fix
- Inspect what already exists before adding a new table, module, extension, configuration option, or code path; identify the specific requirement the existing implementation cannot meet; a different presentation or packaging choice does not by itself require separate data or configuration
- Keep a single authoritative source for business rules, formulas, configuration, and shared values; use the existing source rather than copying it or adding overrides that must be kept in sync; apply shared fixes at the appropriate level instead of accumulating special cases for individual screens
- Prefer native platform features, framework conventions, existing APIs, and declarative configuration when they satisfy the requirement; justify custom machinery by the concrete gap it fills, and verify claimed platform limitations before designing around them
- Treat a minimal diff as a way to reduce regression risk and make the change reviewable; preserve existing structure and behavior where possible, and avoid incidental renaming, reformatting, refactoring, or unrelated cleanup; minimize unnecessary change without sacrificing a complete fix
- Make complexity earn its place; add helpers, types, abstractions, dependencies, and options only when they solve a concrete problem or meaningfully improve clarity; match the implementation to its actual use, especially for one-time scripts and narrowly scoped changes
- Keep validation and failure handling proportional to the actual contract and consequences; inspect the real data shape instead of guessing through fallback properties or adding exhaustive type and format checks; retain checks that prevent a concrete failure, and explain what they protect
- Separate the core fix from adjacent bug fixes and optional hardening; explain what the smaller implementation solves, what it leaves unresolved, and which additional changes are necessary for the requested behavior; use concrete failure scenarios to justify broader changes rather than calling them more robust
- Preserve semantic clarity when reusing code; share logic that represents the same rule, but don't couple unrelated behavior or group unrelated CSS selectors merely to eliminate repeated lines; a little repetition can be clearer than an abstraction that obscures meaning
- Evaluate solutions against the full outcome, including existing behavior, user experience, security, and deployment requirements; don't make an error disappear by weakening a requirement or removing the behavior the user wanted
- When challenged, revisit the assumptions behind the recommendation rather than merely simplifying its wording or defending the existing approach; explain the causal reasoning in plain language, support it with code, observed behavior, or documentation, and retain a recommendation when the evidence warrants it
- Verify the original failure scenario and the behavior the fix is meant to preserve; a passing build or a successful command alone does not establish that the underlying problem is resolved; state what was verified and what remains uncertain
- Carry the user's constraints and the reasons behind them into plans and implementation handoffs, especially minimal scope and the intended failure behavior; don't let a generated plan silently expand the task or lose the tradeoffs agreed during discussion

## Code comments

- Add thoughtful code comments to any new code that you write; in addition, every function, variable, and definition in new code you've written should have a header comment
- Match the existing comment punctuation convention when a file consistently ends comments with periods; otherwise, do not end code comments with periods, and separate multiple clauses with semicolons
- Write in plain, natural English, as though explaining the code to another developer; use technical terms when they identify something specific, but avoid making an ordinary action sound like an abstract engineering concept
- Prefer familiar verbs such as "Get", "Retrieve", "Return", "Read", "Build", "Set", "Remove", "Convert", and "Check if"; use phrases such as "keep track of" or "fall back to" when they describe the behavior naturally
- For function headers and comments describing a step, usually start with an action verb, such as "Return the contents of the storage entry at the given key"; follow the surrounding file if it consistently uses descriptive forms such as "Returns" or "Retrieves"
- For variables, constants, properties, and classes, describe what the value or definition represents or is used for; noun phrases such as "The number of seconds to wait before timing out an HTTP request" or "A reference to the constructor for the sub-collection's item type" are appropriate
- Use ordinary grammar with articles and connecting words; write "Remove tiles that blend in with the background of the SVG" rather than compressing the explanation into a label such as "Background-equivalent tile elimination"
- Describe inputs and results in terms of their meaning, using phrases such as "the given path", "the current date", or "the user's browser"; include units, formats, and the meaning of special values when they help explain the code
- Explain conditions and alternatives directly with "if", "when", "only if", "otherwise", and "then" where it reads naturally; for boolean results, wording such as "Return true if ...; return false otherwise" is appropriate
- Connect an action to its purpose with "because", "so that", "to avoid", or "this allows us to"; for workarounds, explain the specific problem and how the code addresses it, rather than merely calling the code robust or safe
- Use "we", "us", and contractions such as "don't", "doesn't", and "can't" when they make an explanation more natural; avoid turning every comment into impersonal documentation
- Keep straightforward comments short, but give a less obvious behavior enough explanation to be understood; wrap longer explanations across comment lines at the file's usual width, preserving normal sentence flow
- Use parentheses for brief clarifications and concrete examples, including "e.g." and "i.e." where appropriate; name exact identifiers or API methods when useful, and include a source link for a workaround when it explains a relevant limitation

Examples of the intended wording:

```text
Return the textual phone number for the person with the given ID

The number of seconds to wait before timing out an HTTP request to the API

If there is no primary phone, but there is at least one phone number on
file, then fall back to the first one

Focus the input and select its contents so the user can type their
password from the beginning again

We don't need to search any farther out than one week

The bin() function returns a string prefixed with '0b'; strip it
```
