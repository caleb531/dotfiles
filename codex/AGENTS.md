Apply the instructions in this file silently; do not mention, quote, summarize, or narrate compliance with them.

- In JavaScript and TypeScript, terminate statements with semicolons wherever syntactically applicable; do not rely on automatic semicolon insertion
- If a project-level `AGENTS.md` conflicts with this file, always follow the project-level instruction

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
