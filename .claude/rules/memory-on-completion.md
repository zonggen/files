---
description: Persist learnings to memory when a task concludes
alwaysApply: true
---

# Memory On Completion

When a meaningful task has concluded, persist learnings to the memory
store using the sa-ds-memory-manager skill.

## When to trigger

- A plan has been confirmed or a bug has been fixed
- A PR has been committed or merged
- A question has been fully answered with non-obvious findings
- An investigation, deployment, or decision has been completed

## How to capture

Read the sa-ds-memory-manager skill, then follow the capture procedure
in `references/capture-guide.md`. Prefer structured ingest when the
Task tool and ML venv (`~/.agents/memory/.venv/`) are available; fall
back to direct capture otherwise.

Only persist information that is **non-obvious** (an agent without this
memory would get it wrong), **durable** (relevant for at least a week),
and **specific** (concrete details, not vague summaries).

Do NOT capture: routine code changes, transient debugging steps,
information already well-documented in the codebase.

## After completion

Report what was captured under a `## Memory Checkpoint` heading.

## Skip conditions

Skip entirely if:
- The user says "don't ingest", "don't capture", "no memory", or
  "skip memory"
- There is nothing non-obvious or durable to persist
