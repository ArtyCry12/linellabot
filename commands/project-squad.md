# Project Squad

Load and follow: `C:/Users/Asus/.cursor/skills/project-squad/SKILL.md`

User goal (arguments): **$ARGUMENTS**

If empty, Boss runs Phase 0: ask **one** focused question (goal type: audit | fix | design | seo-geo | full-cycle) then proceed.

## Boss instructions

1. Read `skills/project-squad/reference/team-roster.md`, `model-map.md`, `workflow-phases.md`.
2. Detect workspace root (current project folder).
3. Emit Squad Brief; spawn Task subagents per roster with explicit skills/MCP/models.
4. Default gates: **no commit**, **no deploy** unless user explicitly allows in this chat.
5. Use `/graphify` and `/markitdown` for heavy docs; `/uv` for Python ops; `/seo-geo` + alert-manager when SEO in scope.
6. End with evidence-backed summary.

## Quick routes

| User says | Phases |
|-----------|--------|
| audit | 0 → 1 → 3 → summary |
| fix errors | 0 → 1 → 3 → 4 → 5 → 6 |
| seo-geo | 0 → 1 → 7 → 6 |
| full cycle | 0–10 (ship gated) |
| refresh hub | `commands/cursor-system-refresh.cmd` |

Related: `@hermes-agent`, `@game-studios-multiagent`, `SYSTEM-REGISTRY.md`.
