---
description: Auto-recall relevant memories at the start of every conversation
alwaysApply: true
---

# Memory Recall (Session Start)

At the start of a new conversation, run the recall script to load relevant
prior context. This should be your FIRST tool call.

**IMPORTANT**: This is a single shell command. Run it immediately — do not
plan or deliberate. If the command fails, proceed without recalled context.

## How to recall

```bash
python3 <skill_path>/scripts/memory_session_init.py \
  --task "<user's first message or task description>" \
  --rerank --separate-fts5 --preference-boost 1.5
```

Where `<skill_path>` is the path to the `sa-ds-memory-manager` skill directory
(look under installed skills or plugin directories for `sa-ds-memory-manager/`).

If the ML venv (`~/.agents/memory/.venv/`) is missing, the script falls back to
FTS5-only search. On first use, suggest the user run the setup in
`<skill_path>/references/setup-ml-env.md` to enable reranking and embeddings.

## After recall

- If results are non-empty, present them under `## Recalled Context` before
  proceeding with the user's request.
- If a recalled memory shows a "Stale context" caveat, confirm with the user
  before relying on it.
- If results are empty or the command fails, proceed normally.

## Skip conditions

Skip ONLY if the user explicitly says "don't recall", "fresh start", or
"no memory".
