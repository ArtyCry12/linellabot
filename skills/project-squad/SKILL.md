---
name: project-squad
description: >-
  Universal multi-agent project team (Boss Opus 4.7 + 10 custom subagents in agents/squad-*.md)
  for any Cursor workspace. Token-optimized models per role. Invokes squad-scout, squad-build,
  etc. via Cursor Subagents UI or Task fallback. Use for @project-squad, /project-squad, full
  project cycle, SEO/GEO, design+build+QA+deploy. Triggers: project squad, studio team,
  squad-scout, 10 agents, multiagent project.
argument-hint: "[audit | fix | design | seo-geo | full cycle | refresh hub]"
user-invocable: true
---

# Project Squad v2 (Cursor)

Boss (**Opus 4.7**) orchestrates; **10 custom subagents** in `C:/Users/Asus/.cursor/agents/squad-*.md` — visible in Cursor **Subagents** panel.

| Resource | Path |
|----------|------|
| Agents | `C:/Users/Asus/.cursor/agents/squad-*.md` |
| Skill root | `C:/Users/Asus/.cursor/skills/project-squad/` |
| Roster | [reference/team-roster.md](reference/team-roster.md) |
| Models | [reference/model-map.md](reference/model-map.md) |
| Phases | [reference/workflow-phases.md](reference/workflow-phases.md) |

## Non-negotiable rules

1. **Boss never skips Phase 0** — goal, forbidden paths, commit/deploy gates.
2. **Spawn custom subagents first** — `Use the squad-<role> subagent to …` with model from model-map.
3. **Token economy** — graphify/markitdown; one web MCP (Exa); Haiku/Composer for scout/memory/cleanup.
4. **No commit / no deploy** unless user explicitly allowed.
5. **GitNexus** — impact before symbol edits; detect_changes before commit.
6. **Memory** — `user-memory` + `AGENTS.md` + `ai-tracking/`; Obsidian **optional only** (on-demand `obsidian-mcp` skill).
7. **Parallel** only per [team-roster.md](reference/team-roster.md).

## Boss checklist

```
1. Read team-roster.md + model-map.md
2. Squad Brief (agents, models, gates)
3. Invoke squad-* subagents per phase (skip out-of-scope)
4. Evidence-backed final summary
```

## How to spawn (preferred)

```
Use the squad-scout subagent to audit <workspace path>.
Model: composer-2.5-fast. No commits.
```

Fallback if custom agent unavailable: Task with `subagent_type` from roster + `model` from model-map.

## Quick routes

| User says | Agents |
|-----------|--------|
| audit | scout → architect → review |
| fix errors | scout → architect → build → review → qa |
| seo-geo | scout → growth → qa |
| full cycle | all phases (ship gated) |
| refresh hub | squad-cleanup → cursor-system-refresh.cmd `-SkipObsidian` |

## Command

**`/project-squad`** → load this file → Boss Phase 0 immediately.
