---
name: project-squad
description: >-
  Universal multi-agent project team (Boss + 8 specialists) for any Cursor workspace.
  Token-optimized orchestration via Task subagents with explicit skills, MCP, and models.
  Use for @project-squad, /project-squad, full project cycle, studio team, game-studios-style
  delivery on web apps, SEO/GEO audits, design+build+QA+deploy pipelines, or master
  prompt "комплексная работа над проектом". Triggers: project squad, studio team, full cycle,
  seo-geo + deploy, multiagent project, hermes team, game-studios for non-game projects.
argument-hint: "[goal e.g. audit only | fix errors | redesign + motion | seo-geo | full cycle to deploy]"
user-invocable: true
---

# Project Squad (Cursor)

Turn one session into a **token-efficient project studio**: Boss orchestrates; specialists run through the **Task** tool with fixed roles, models, skills, and MCP bindings.

| Resource | Path |
|----------|------|
| Skill root | `C:/Users/Asus/.cursor/skills/project-squad/` |
| Team roster | [reference/team-roster.md](reference/team-roster.md) |
| Model map | [reference/model-map.md](reference/model-map.md) |
| Phases | [reference/workflow-phases.md](reference/workflow-phases.md) |
| Registry | `C:/Users/Asus/.cursor/SYSTEM-REGISTRY.md` |
| Similar patterns | `game-studios-multiagent`, `hermes-agent` |

## Non-negotiable rules

1. **Boss never skips Phase 0** — clarify goal, forbidden paths, commit/deploy gates.
2. **Token economy** — graphify/markitdown before heavy files; one web MCP (Exa primary); read one MCP descriptor JSON per server.
3. **No commit / no deploy** unless user explicitly allowed (default: ask first).
4. **No secrets in git** — never commit `.env`, keys, tokens.
5. **GitNexus** — impact before symbol edits in indexed repos; detect_changes before commit.
6. **Parallel Task** only when [team-roster.md](reference/team-roster.md) allows.
7. **Obsidian** — autonomous vault sync after substantive work (`obsidian-mcp` rule).

## Boss startup checklist

```
1. Read reference/team-roster.md + model-map.md
2. Detect workspace root (user folder vs hub C:/Users/Asus/.cursor)
3. Write Squad Brief (goal, scope, agents to spawn, gates)
4. Run phases from workflow-phases.md — skip phases not in scope
5. End with evidence-backed summary (commands run, URLs, risks)
```

## Spawning a specialist

Template for Task prompt:

```markdown
You are <ROLE> in Project Squad.
Workspace: <absolute path>
Read skill: <path/to/SKILL.md> if listed below.
MCP: <server id> — read one tool JSON from projects/.../mcps/<server>/tools/ before first call.
Constraints: <forbidden paths, no commit, etc.>
Deliverable: <exact output format>
Return ONLY deliverables; no filler.
```

### Model parameter

Pass `model` to Task only when user requested a specific tier — else use [model-map.md](reference/model-map.md).

| Role | subagent_type | model (optional) |
|------|---------------|------------------|
| scout | `explore` | `claude-4.5-haiku-thinking` |
| design | `generalPurpose` | `claude-4.6-sonnet-medium-thinking` |
| build | `generalPurpose` | `gpt-5.3-codex-high-fast` |
| qa shell | `shell` | `composer-2.5-fast` |
| review | `code-reviewer` or `bugbot` | `claude-4.6-sonnet-medium-thinking` |
| growth perf | `performance-optimizer` | default |
| ship | `deployment-expert` | default |

## Skill / MCP bindings by phase

| Phase | Skills | MCP |
|-------|--------|-----|
| Scout | `graphify`, `markitdown`, `uv` | `user-gitnexus`, `plugin-exa-exa` |
| Design | `huashu-design`, `ui-ux-pro-max`, `21st-design`, `remotion` | `plugin-figma-figma`, `@21st-dev/magic` |
| Build | `mattpocock-skills`, Vercel `nextjs`, `shadcn` | `user-gitnexus` |
| QA | Playwright skill, `verification` | `cursor-ide-browser` |
| Review | Task `thermo-nuclear-code-quality-review`, `bugbot` | — |
| Growth | `seo-geo` → `library/monitor/alert-manager/SKILL.md` | `plugin-exa-exa` |
| Ship | Vercel `deployments-cicd`, `vercel-cli` | `plugin-vercel-vercel` |
| Memory | `obsidian-mcp` | `obsidian`, `user-memory` |
| Hub refresh | — | run `commands/cursor-system-refresh.cmd` |

## Prompt audit (master prompt compatibility)

When user pastes the long "мастер-промпт":

| Issue | Action |
|-------|--------|
| Contradiction: "идеал без ошибок" vs huge scope | Boss splits into phases; ship only after green checks |
| `humanizer-main` missing | Flag; offer manual tone pass |
| Duplicate design stacks | Pick huashu + ui-ux direction first, 21st for components |
| Commit + deploy before tests | Block until Phase 6 green |
| `/agents-memory-updater` | Use Obsidian + optional Task `agents-memory-updater` if available |

## Integration with other studio skills

- **Game scope** → defer to `game-studios-multiagent` instead of this skill.
- **Hermes persona** → merge `SOUL.md` from `hermes-agent` bootstrap into Squad Brief.
- **SEO-only** → skip design/build; scout → growth → qa.

## Command

User invokes: **`/project-squad`** → load this file → Boss executes Phase 0 immediately.
