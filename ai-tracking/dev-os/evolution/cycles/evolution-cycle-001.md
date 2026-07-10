# Evolution Cycle 001

**Date:** 2026-07-03  
**Trigger:** DEC-008 encoded; user confirmed first DEC-007 cycle  
**Scope:** MCP health · doc QA · proposed-insights triage

## Summary

| Track | Result |
|-------|--------|
| Ecosystem (MCP) | 2 servers errored; 30+ healthy |
| QA (docs) | 4 safe fixes applied |
| Knowledge (insights) | PI-001 held (1 source) |
| Performance | dev-os-status OK; no routing change needed |

## MCP health

**Descriptor scan:** `projects/c-Users-Asus-cursor/mcps/` — 32 server folders.

| Server | Tools | Status | Action |
|--------|-------|--------|--------|
| `user-fetch` | 0 | **errored** | Check `mcp.json` fetch server; restart MCP in Cursor Settings |
| `user-obsidian` | 0 | **errored** | Start Obsidian Desktop + Local REST API (`ensure-obsidian.ps1`) |
| `plugin-exa-exa` | 2 | OK | Primary web research — keep |
| `user-memory` | 9 | OK | LTM primary |
| `user-gitnexus` | 13 | OK | Code graph |
| `user-n8n-mcp` | 33 | OK | Instance workflows |
| `user-stitch` | 14 | OK | Via proxy per mcp-routing |
| `plugin-zapier-zapier` | 1 | OK | Agentic meta-tools mode |

**Routing:** No duplicate web providers in active policy. Exa primary unchanged.

**Note:** Many plugin MCPs enabled (HeyGen, Higgsfield, Postman, Resend, etc.) — on-demand only per orchestrator; no action unless task-specific.

## Doc QA

| Issue | Fix |
|-------|-----|
| `understanding.md` missing `phase_4_closed` | Set `true` |
| BOOTSTRAP hub boundary stale | Note research_complete + EXECUTIVE charter |
| `proposed-insights.md` missing | Created from LTM pending |
| decision/memory skills DEC-008 drift | Patched autonomy sections |

**Verified refs:** EXECUTIVE.md linked from skill, command, registry, rule, autonomy, execution — all resolve.

## Proposed insights triage

- **PI-001 (Acon NL compression):** remain proposed — needs second source before layer/LTM promotion.

## Backlog updates

- Next ecosystem check: on registry/MCP config change or monthly
- Next QA spot-check: after next major hub edit batch

## Hub system audit (2026-07-03)

Full report: [`ai-tracking/system-audit-2026-07-03.md`](../../../system-audit-2026-07-03.md)

| Signal | Value |
|--------|-------|
| Hub size | ~449 MB top-level |
| Obsidian | not OK (matches MCP errored) |
| GitNexus | stale (>7d); `npx gitnexus analyze` crashed on design_system.py |
| Deferred cleanup | pending since 2026-06-12 |

## ASM

### ASM-2026-07-03-001 — Evolution cycle 001

- **Assumption:** fetch/obsidian errors are runtime (server down) not descriptor corruption
- **Rationale:** STATUS.md shows MCP server errored; tools folder empty
- **Revisit:** after user restarts Obsidian / fixes fetch MCP
