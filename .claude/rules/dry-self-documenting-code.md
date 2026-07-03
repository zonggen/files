---
description: Enforce DRY and self-documenting code; avoid verbose comments
alwaysApply: true
---

# DRY & Self-Documenting Code

Applies to code you write or modify. Don't refactor untouched code unless asked — note pre-existing violations in one line instead. Skip generated files, migrations, vendored code. In code reviews, flag duplication only when it carries real drift/bug risk; never nit comment style.

## DRY

- Reuse existing helpers/utils before writing new logic.
- Same logic 3+ times → extract. Twice is fine; don't abstract prematurely.
- Duplicated knowledge counts: magic numbers, validation rules, config values repeated across files belong in one place.
- Fixing a bug in copied logic → consolidate the copies.
- Extraction boundary is judgment, but confirm with the user before any cross-repo extraction.
- Tests lean DAMP: duplicated setup is fine when extraction would hide test intent. Constants and data builders are still extractable.

```python
# ❌ user.age >= 18 and user.verified   (repeated in 3 files)
# ✅ def is_eligible(user): return user.age >= 18 and user.verified
```

## Comments: let the code speak

- Never narrate what code does — rename or extract until it reads clearly without comments.
- Comments explain WHY only: trade-offs, workarounds, external constraints (tickets, API quirks, perf).
- Delete commented-out code; no section-banner comments (`# ---- helpers ----`).
- Docstrings: one-line purpose on public API when non-obvious or repo convention requires; never restate params/signature. Repo lint config wins.

```python
# ❌ # loop through users and keep active ones
# ✅ active_users = [u for u in users if u.active]
# ✅ # Retry once: vendor API 503s on cold start (VENDOR-1234)
```
