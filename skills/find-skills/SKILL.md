---
name: find-skills
description: >-
  Hub wrapper for skills.sh / vercel-labs find-skills. Gap-check on Plan and
  Phase 0: hub stack + candidates from npx skills find → Ask once → install.
  Prefer high installs; Design/UI topic allowed below threshold. Triggers:
  find skill, skills.sh, npx skills, skill catalog, @find-skills.
version: "1.0.0"
license: MIT
compatibility: cursor
metadata:
  author: hub
  version: "1.0.0"
  source: https://github.com/vercel-labs/skills
  catalog: https://www.skills.sh/
when_to_use: skill_gap_on_plan, find_skill_catalog, skills_sh_search
argument-hint: "[query]"
---

# Find Skills (hub wrapper)

Upstream (do not fork/edit): `.agents/skills/find-skills/SKILL.md`  
(Installer path: `C:\Users\Asus\.cursor\.agents\skills\find-skills\`)

Catalog: [skills.sh](https://www.skills.sh/) · CLI: `npx skills`

## Read first

1. This file (hub protocol)
2. Upstream SKILL at `.agents/skills/find-skills/SKILL.md` (discovery/install detail)

## When (hub)

| Situation | Action |
|-----------|--------|
| User says find skill / skills.sh / npx skills | Full find flow |
| **Plan mode** or **Phase 0** / large brief | **Mandatory gap-check** (below) |
| Casual short chat | Skip unless explicit ask |

## Gap-check protocol (Plan / Phase 0)

1. List hub skills/MCP already relevant (task-router + known paths).
2. Name gaps: «чего не хватает для этой задачи».
3. Run search (prefer liquid installs; Design/UI may be lower):

```powershell
powershell -File commands/find-skills.ps1 -Query "<domain keywords>"
# or: npx.cmd skills find "<query>"
```

4. Build short candidate list (name, installs, source, why).
5. **Ask once** (AskQuestion / one confirm): install this set? **Да / Нет**.
6. On Да → `npx.cmd skills add <owner/repo@skill> -g -y` (or per upstream flags).
7. Wire new skill into hub only if needed (route/registry) — Session 2+ for bulk; S1 wire-only skips mass install.

## Liquidity rules

- Prefer top installs on [skills.sh leaderboard](https://www.skills.sh/).
- Treat **Design / UI** topics as eligible even if below general install threshold.
- Prefer owners: `vercel-labs`, `anthropics`, `microsoft`, known hub sources.

## Commands

| Task | Command |
|------|---------|
| Search | `powershell -File commands/find-skills.ps1 -Query "..."` |
| Smoke test | `powershell -File commands/find-skills-test.ps1` |
| Install (after user OK) | `npx.cmd skills add <owner/repo@skill> -g -y` |
| Update catalog skills | `npx.cmd skills update` |

## Do not

- Mass-install from catalog without Ask once
- Edit upstream `.agents/skills/find-skills/` (re-install via npx)
- Put copies in `skills-cursor/`
- Touch `hooks.json` for this skill
