# Project Squad v2

Load and follow: `C:/Users/Asus/.cursor/skills/project-squad/SKILL.md`

User goal (arguments): **$ARGUMENTS**

Boss model: **Opus 4.7**. Spawn **custom subagents** from `agents/squad-*.md` (visible in Subagents UI).

## Boss instructions

1. Read `reference/team-roster.md`, `model-map.md`, `workflow-phases.md`.
2. Squad Brief → invoke `squad-*` agents with models from model-map.
3. Memory: `user-memory` + `AGENTS.md` first; Obsidian only if online + requested.
4. Default: **no commit**, **no deploy**.
5. Hub refresh: `cursor-system-refresh.cmd` with `-SkipObsidian` if vault offline.

## Quick routes

| Args | Phases |
|------|--------|
| audit | scout → architect → review |
| fix errors | scout → architect → build → review → qa |
| seo-geo | scout → growth → qa |
| full cycle | 0–10 (ship gated) |
| refresh hub | squad-cleanup |
