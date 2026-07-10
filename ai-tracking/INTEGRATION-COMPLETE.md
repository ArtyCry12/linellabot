# Integration Complete — Jul 2026

## Must-have: agency-agents ✅

| Item | Status |
|------|--------|
| Clone | `C:\Users\Asus\projects\agency-agents` |
| Convert | 233 → Cursor `.mdc` |
| Hub install | **66 rules** → `rules/agency/` (marketing, sales, design, product, paid-media) |
| Index | `rules/agency/_INDEX.md` |
| Skill | `skills/agency-agents/SKILL.md` |
| Rule pointer | `rules/agency-agents.mdc` |
| Command | `commands/install-agency-agents.ps1` |
| Squad hooks | `squad-growth.md`, `squad-design.md` updated |

**Use:** `@content-creator`, `@sales-engineer`, `@ui-designer`, etc.

## prompts.chat MCP ✅

- Added to `mcp.json`: `"url": "https://prompts.chat/api/mcp"`
- Descriptors: `projects/.../mcps/plugin-prompts-chat/`
- **Action:** Reload Window in Cursor

## bumblebee ⚠️ partial

- No Windows binary in v0.1.2 releases (linux/darwin only)
- `commands/bumblebee-scan.ps1` — downloads linux binary, runs via WSL if available
- Fallback: `commands/hub-supply-scan.ps1` → `ai-tracking/hub-supply-scan.json`

## FlowMetrics demo ✅

- Generated images → `docs/squad/demo-flowmetrics/site/assets/`
- Stitch hero v2 → `stitch-output/home-hero-v2-stitch.html` (22 KB)

## Refresh

Run: `commands/cursor-system-refresh-quick.cmd`
