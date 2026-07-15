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

> **Dev OS DEC-004:** Squad is the **execution layer** under Candidate A (minimal meta). Research → `@dev-os` / `dev-os-research`. Build/ship → Squad. New agents require DEC + emergence checklist.

Boss (**Opus 4.7**) orchestrates; **10 custom subagents** in `C:/Users/Asus/.cursor/agents/squad-*.md` — visible in Cursor **Subagents** panel.

| Resource | Path |
|----------|------|
| Agents | `C:/Users/Asus/.cursor/agents/squad-*.md` |
| Skill root | `C:/Users/Asus/.cursor/skills/project-squad/` |
| Roster | [reference/team-roster.md](reference/team-roster.md) |
| Models | [reference/model-map.md](reference/model-map.md) |
| Phases | [reference/workflow-phases.md](reference/workflow-phases.md) |

## Non-negotiable rules

1. **Boss never skips Phase 0** — goal, forbidden paths, commit/deploy gates. **Skill gap-check:** hub stack + `skills/find-skills` / skills.sh (Ask once before install).
2. **Spawn custom subagents first** — `Use the squad-<role> subagent to …` with model from model-map.
3. **Token economy** — graphify/markitdown; one web MCP (Exa); Haiku/Composer for scout/memory/cleanup.
4. **No commit / no deploy** unless user explicitly allowed.
5. **GitNexus** — impact before symbol edits; detect_changes before commit.
6. **Memory** — `user-memory` + `AGENTS.md` + `ai-tracking/` (see DEC-009 memory stack).
7. **Taxonomy** — classify via `SYSTEM-TAXONOMY.md`; agency personas via `AGENCY-PORTFOLIO-MAP.md` (≤2).
8. **Karpathy** — on refactor/review load `karpathy-guidelines.mdc`.
9. **Parallel** only per [team-roster.md](reference/team-roster.md).

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
| marketing / landing | growth → design → build → qa (humanizer on copy) |
| reels brief | growth + `templates/marketing/landing-brief.md` |
| refresh hub | squad-cleanup → cursor-system-refresh.cmd |
| foundation refresh | read `commands/foundation-refresh.md` → taxonomy update |
| pixel monitor | `commands/pixel-office.ps1` |

## Command

**`/project-squad`** → load this file → Boss Phase 0 immediately.

## Claude plugins bridge (Cursor hub)

Adapted from `claude-plugins-official` (runtime remains `claude` CLI; skills synced to hub):

| Plugin | Hub path | Squad / route |
|--------|----------|---------------|
| superpowers | `skills/brainstorming`, `writing-plans`, `systematic-debugging`, `subagent-driven-development`, `verification-before-completion` | Route `coding-discipline` → architect → build |
| frontend-design | `skills/frontend-design` | `squad-design` anti-slop gate; route `frontend-design-web` |
| code-review | `skills/pr-review` | `squad-review` PR mode; route `pr-review` |
| claude-code-setup | — | `squad-scout` automation audit; route `automation-audit` |

Refresh skills: `powershell -File commands/sync-claude-plugin-skills.ps1`  
Verify: `powershell -File commands/claude-plugins-bridge-test.ps1`

**Merge rule:** Superpowers = Phase 0–1 (spec/plan). Squad = Phase 2+ (design/growth/build/qa). Do not run both bosses in parallel.
