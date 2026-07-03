---
description: Conventional commit message format for all git commits
alwaysApply: true
---

# Conventional Commits

Format: `<type>[optional scope]: <description>`

**Types:** `feat` | `fix` | `docs` | `style` | `refactor` | `perf` | `test` | `build` | `ci` | `chore` | `revert`

- `feat`: new feature → MINOR version bump
- `fix`: bug fix → PATCH version bump
- Append `!` or add `BREAKING CHANGE:` footer → MAJOR version bump

**Rules:**
- Description is lowercase, no trailing period
- Scope is optional: `feat(auth): add login`
- Body and footers are optional, separated by blank lines

**Examples:**
```
feat(auth): add OAuth2 login
fix: prevent racing of requests
docs: update README
refactor(parser): simplify token logic
feat!: drop Node 6 support
```

**Breaking change (footer form):**
```
feat: new config format

BREAKING CHANGE: `extends` key now used for config inheritance
```
