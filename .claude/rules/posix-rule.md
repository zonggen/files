# CLI Tool Preferences

Use these fast alternatives instead of slow defaults:

| Instead of | Use | Key flags |
| --- | --- | --- |
| `find` | `fd` | `-e ext`, `-t f/d`, `-d depth`, `--max-results N` |
| `grep -r` | `rg` | `--type py`, `--json`, `-m N` (max per file), `-C N` (context) |
| `cat` | `bat --plain` | `-r START:END` (line range), `-n` (line numbers) |
| `ls -R` / `tree` | `eza --tree` | `-L depth`, `--git-ignore` |
| `wc -l` (code stats) | `tokei` | `--output json` |
| `sed 's/old/new/'` | `sd 'old' 'new'` | Simpler regex, no escaping delimiters |
| `jq` | `jaq` | Same syntax, 2-3x faster |
| `du` | `dust` | `-d depth` |

Rules:
- Always type-filter: `rg --type py`, `fd -e ts` — skip irrelevant files
- Prefer JSON output: `rg --json`, `tokei --output json` — structured > free text
- Budget output: `fd --max-results 50`, `rg -m 5` — prevent context flooding
- Targeted reads: use `bat -r START:END` when you have line numbers, never read entire large files
- Chain search then read: search gives line numbers, read uses them

## When a preferred tool behaves unexpectedly

If a preferred tool (rg, fd, bat, eza, etc.) produces wrong output, empty results, or unexpected exit codes:

1. **Diagnose before moving on** — re-run without `2>/dev/null`, check the actual error message, isolate the failing flag with a minimal test case
2. **Capture to global memory** — once the root cause is understood, persist it using `sa-ds-memory-manager` so the same mistake is not repeated in future sessions:
   ```bash
   python3 ~/.claude/skills/sa-ds-memory-manager/scripts/memory_capture.py \
     --type semantic --domain automation --scope global \
     --title "<tool>: <what went wrong>" \
     --summary "<what the bug was, what the correct usage is>" \
     --rationale "<how it was discovered>" \
     --rationale-source stated \
     --tag <tool> --confidence 0.95 \
     --global-db ~/.agents/memory/global.sqlite
   ```
3. **Fall back gracefully** — if the tool is genuinely broken in this environment, use the built-in Claude Code tools (`Grep`, `Glob`, `Read`) which run outside the shell sandbox
