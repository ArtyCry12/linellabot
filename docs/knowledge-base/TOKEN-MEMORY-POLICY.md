# Token & Memory Policy — Cursor Hub

Adapted from [ECC](https://github.com/affaan-m/ECC) harness controls + hub DEC-009 memory stack.  
**Goal:** minimize device RAM and LLM context without losing durable facts.

## Context tiers

| Tier | Location | Inject when | Cap |
|------|----------|-------------|-----|
| **HOT** | `user-memory` MCP | Every substantive session | ≤15 observations; prune stale |
| **WARM** | `AGENTS.md`, `ai-tracking/*.md`, Obsidian | Task needs project history | Load **one** file per turn |
| **COLD** | GitHub, `docs/knowledge-base/`, external repos | Research / refresh only | Never auto-load |

## Session rules (always)

1. **One** web MCP per research task (Exa primary).
2. **One** SKILL.md before execution — not a directory listing.
3. **One** MCP descriptor JSON before first call on a server.
4. Subagents: parallel only per `team-roster.md` safe table.
5. Karpathy: surgical diffs — no drive-by refactors.

## ECC-inspired caps (Cursor adaptation)

| Control | Default | Env override (optional) |
|---------|---------|-------------------------|
| SessionStart extra context | ≤8 KB summarized | — |
| Instincts / learned patterns injected | ≤6 items, confidence ≥0.7 | store in `ai-tracking/instincts/` |
| Deferred cleanup | queue on refresh | `cursor-system-refresh-deferred.ps1` |
| Agent data home (Cursor) | `C:\Users\Asus\.cursor\ai-tracking\` | avoid `~/.claude` collision |

## Model routing (token $)

| Tier | Models | Roles |
|------|--------|-------|
| Heavy | Opus 4.7 | Boss orchestration |
| Standard | Sonnet 4.6 | design, qa, growth, ship, architect |
| Fast | Composer 2.5, Haiku 4.5 | scout, memory, cleanup |
| Code | Codex 5.3 High | squad-build |

## Memory write triggers (squad-memory)

Write to `user-memory` when:
- User preference stated explicitly
- DEC decision finalized
- Repeated project constraint (2+ sessions)

Do **not** write:
- Transient tool output
- Full file contents
- Entire repo scans

## Digital hygiene (don't clog disk)

| Do | Don't |
|----|-------|
| Store reports in `ai-tracking/` or Obsidian | Duplicate large repos inside hub |
| `cursor-system-refresh` deferred cleanup | Keep `node_modules` in hub |
| Client repos in `C:\Users\Asus\projects\` | Git-track generated caches |
| bumblebee NDJSON → `ai-tracking/` | Commit `mcp.json` secrets |

## Verification loop (goal-driven)

```
1. Classify task → auto-orchestrator → verify: correct skill/MCP chosen
2. Execute minimal scope → verify: diff matches request (karpathy)
3. Durable fact? → verify: memory tier assigned
4. Hub change? → verify: SYSTEM-REGISTRY + taxonomy if routing affected
```
