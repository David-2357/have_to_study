# Git Commit Guidelines

Use **Gitmoji** for every Git commit. Follow these rules strictly.

## Commit rules

- Write all commit messages in English.
- Always use the present simple tense with imperative verbs (e.g., `add`, `fix`, `update`, `remove`, `improve`).
- Keep messages clear, concise, and descriptive.
- Always start commit messages with the most appropriate Gitmoji.
- Create separate commits for each independent logical change or task.
- Never group unrelated changes into a single commit.
- Group files together only when they belong to the same logical task.
- Avoid unnecessary commits and vague descriptions.
- Review changes before committing and ensure each commit has a single, clear purpose.
- Never commit unrelated user changes.

## Gitmoji reference

| Emoji | Purpose | Example |
|---|---|---|
| ✨ | Add new features | `✨ add user authentication` |
| 🐛 | Fix bugs | `🐛 fix login validation` |
| 💄 | Improve UI and styles | `💄 update navbar styles` |
| ♻️ | Refactor code | `♻️ refactor API services` |
| ⚡ | Improve performance | `⚡ optimize database queries` |
| 🔥 | Remove code or files | `🔥 remove unused components` |
| 📝 | Update documentation | `📝 update API documentation` |
| ✅ | Add or update tests | `✅ add authentication tests` |
| 🔒 | Fix security issues | `🔒 secure authentication routes` |
| 🚀 | Deploy or release | `🚀 deploy application` |
| 🔧 | Update configuration | `🔧 update ESLint configuration` |
| 📦 | Manage dependencies | `📦 update project dependencies` |
| 🚚 | Move or rename files | `🚚 move shared components` |
| 🏗️ | Change project architecture | `🏗️ restructure application modules` |
| 🧑💻 | Improve developer experience | `🧑💻 improve development workflow` |

## Commit format

`<gitmoji> <imperative description>`

## Examples of correct commits

```text
✨ add user registration endpoint
✅ add registration validation tests
🐛 fix duplicate email handling
♻️ refactor authentication service
📝 update authentication documentation
```

## Important

Before creating commits:
1. Inspect all modified files.
2. Identify independent logical changes.
3. Separate changes into focused commits.
4. Select the most appropriate Gitmoji for each commit.
5. Write concise descriptions using imperative verbs in the present tense.
6. Verify that each commit contains only related changes.

**Goal:** Maintain a clean, consistent, readable Git history with small, atomic, and meaningful commits.

## Documentation Guidelines

- Keep the README.md clear, concise, and useful.
- Update the README whenever changes affect setup, configuration, features, usage, or project structure.
- Avoid unnecessary emojis. Use them sparingly, only when they improve readability.
- Do not add filler, redundant explanations, or marketing language.
- Prioritize practical information, clear instructions, and relevant examples.
- Keep documentation accurate and aligned with the current implementation.
- Remove outdated or irrelevant information.
- Use clear headings and a logical structure.
- Every section must provide useful information to the reader.

