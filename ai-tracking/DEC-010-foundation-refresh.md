# DEC-010 — Foundation Refresh (Knowledge Base & Taxonomy)

**Status:** Accepted  
**Date:** 2026-07-05  
**Scope:** Hub meta-layer — no Squad roster change (DEC-004 preserved)

## Context

User supplied 5 foundation repos + 22 category resource lists to refresh the Cursor hub without bloating always-on context or breaking Dev OS / Squad architecture.

## Decision

1. Add **`SYSTEM-TAXONOMY.md`** — 22-domain routing matrix (on-demand load).
2. Add **`docs/knowledge-base/`** — FOUNDATION-REPOS, EXTERNAL-CATALOG, AGENCY-PORTFOLIO-MAP, TOKEN-MEMORY-POLICY, AI-AGENCY-STARTUP.
3. Add on-demand rules: `karpathy-guidelines.mdc`, `system-taxonomy.mdc` (not always-on).
4. Add **`tools/pixel-office/`** — opt-in lightweight squad visualization.
5. Extend cybersecurity doc path with bumblebee supply-chain scanning.
6. Optional MCP: prompts.chat in `mcp.json.example` only.

## What we did NOT do

- Bulk-install 232 agency-agents into hub git
- Clone full ECC hooks into Cursor (Claude Code–specific)
- Change 10-agent Squad roster
- Add always-on rules (token cost)

## Foundation repo roles

| Repo | Hub artifact |
|------|----------------|
| agency-agents | AGENCY-PORTFOLIO-MAP.md |
| andrej-karpathy-skills | karpathy-guidelines.mdc |
| ECC | TOKEN-MEMORY-POLICY.md patterns |
| prompts.chat | mcp.json.example entry |
| bumblebee | cybersecurity + refresh optional scan |

## Verification

- [x] `cursor-system-refresh-quick.cmd` completes
- [x] auto-orchestrator references taxonomy + agency
- [x] SYSTEM-REGISTRY lists new artifacts
- [x] 66 agency rules in `rules/agency/`
- [x] prompts.chat in `mcp.json`
- [x] `skills/agency-agents/SKILL.md` created

## References

- `SYSTEM-TAXONOMY.md`
- `docs/knowledge-base/README.md`
- [agency-agents](https://github.com/msitarzewski/agency-agents)
- [andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills)
- [ECC](https://github.com/affaan-m/ECC)
- [prompts.chat](https://github.com/f/prompts.chat)
- [bumblebee](https://github.com/perplexityai/bumblebee)
