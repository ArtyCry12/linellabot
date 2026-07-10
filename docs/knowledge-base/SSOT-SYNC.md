# Single source of truth (REQ-080)

## Canonical files

| Topic | SSOT | Mirrors (sync via script) |
|-------|------|---------------------------|
| Agent instructions | `AGENTS.md` | `CLAUDE.md` (gitnexus block) |
| MCP routing compact | `rules/00-agent-orchestrator.mdc` | — |
| MCP routing detail | `rules/mcp-routing.mdc` | — |
| Task routing tree | `rules/auto-orchestrator.mdc` | `projects/.cursor/rules/` via huashu-sync |
| Registry | `SYSTEM-REGISTRY.md` | Update when adding rules/skills/MCP |
| Taxonomy | `SYSTEM-TAXONOMY.md` | — |
| REQ tracking | `ai-tracking/REQ-REGISTRY-NOTION.md` | — |
| Execution status | `ai-tracking/NOTION-EXECUTION-STATUS.md` | — |
| P1/P2 completion | `ai-tracking/P1-MCP-COMPLETE.md`, `P2-MCP-COMPLETE.md` | — |

## Sync command

```bash
python commands/huashu-sync-workspace-rules.py
# or
commands/cursor-system-refresh.cmd
```

## Do not duplicate without sync

- Squad roster in multiple READMEs
- MCP server lists in random markdown
- SEO instructions outside seo-geo pack + SEO-STACK.md

## When editing

1. Change SSOT file
2. Run huashu-sync if rule mirrors exist
3. Bump SYSTEM-REGISTRY if new entry

*P2 · 2026-07-10*
