# Dev OS — Memory Stack (DEC-009)

**Status:** Canonical  
**Decision:** DEC-009  
**Supersedes:** Obsidian MCP integration (removed)

## Primary stack (only)

| Tier | Tool | Use |
|------|------|-----|
| 1 | `user-memory` MCP | Session facts, validated LTM |
| 2 | `AGENTS.md` | Durable per-repo agent instructions |
| 3 | `ai-tracking/` | Hub audit, Dev OS corpus, evolution reports |

## Routing

- **Dev OS meta:** `skills/dev-os/memory/SKILL.md`
- **Execution:** `squad-memory` (Haiku) after validation
- **Promotion:** high confidence → LTM; medium → `proposed-insights.md`

## Removed

- MCP `obsidian`, `rules/obsidian-mcp.mdc`, `skills/obsidian-mcp/`, `ensure-obsidian.ps1`

## Portability (minor)

Corpus and skills remain markdown — platform-agnostic where practical. Cursor-specific: `.mdc`, `agents/*.md`, MCP descriptors.
