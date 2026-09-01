---
name: task-decomposition
description: "Builds a proportional 5-level WBS (project, epic, story, task, atomic work package) for Plan/mega-task/new project/!auto+Deliverables. Skip empty levels. L5 needs verify. Triggers: WBS, epics, user stories, декомпозиция, иерархия задач, разложи задачу, work packages. Not one-line fixes. Do not restore writing-plans."
---

# Task decomposition (WBS)

Hub canon for plan trees. SECONDARY. Not always-on. Not a Jira clone.

> **Note (2026-09-01):** Для «с нуля» / нового проекта — если в целевом репо уже есть wayfinder-карта (`docs/wayfinder.md` от `blocks/dev-os/skills/wayfinder/SKILL.md`), WBS строится **после** неё. Wayfinder закрывает решения, WBS — пакует реализацию.

Read `templates/wbs/WBS-TEMPLATE.md` once, then write **one** file in the **project repo**.

## When

Full or partial tree if **any**:

- Cursor Plan mode on a feature / architecture / new project
- Mega-task or `!auto` with `Deliverables / Не трогать / Готово когда`
- User says WBS, эпик, user story, декомпозиция, разложи, иерархия, `@wbs`

## When not

- One-line fix, «просто ответь», already approved WBS this session, `skip-wbs`
- Single run of an existing skill that **is** the work (one SEO audit, one n8n node) → shallow **L1 + L4 + L5** only

## Levels

| Id | Entity | Required | Skip if |
|----|--------|----------|---------|
| L1 | Project | Outcome, out-of-scope, DoD | Never on qualifying work |
| L2 | Epic | IN/OUT, independently shippable | Fewer than 2 value slices |
| L3 | Story / module | Acceptance criteria | Work is one story under L1 |
| L4 | Task | Files/symbols, deps, risk | — |
| L5 | Work package | **One change + one `verify:`** | — |

Do **not** invent dummy epics/stories to fill five floors.

**Caps:** ≤7 epics in the file. Detail the **current** epic. Others may stay as titles until you reach them.

## File

Prefer `{project}/docs/wbs/{slug}.md`.

If Cursor already wrote `.cursor/plans/*.plan.md` for this work — put the WBS **in that file**, do not duplicate.

IDs: `P` → `E2` → `E2.S1` → `E2.S1.T3` → `E2.S1.T3.W1`. Every node has `parent`. Status: `pending | in_progress | done | blocked`.

## Approval

After writing the file, **stop** and ask: «Утвердить дерево?»

Exception: `!auto` **and** the prompt already has Deliverables / Не трогать / Готово когда → contract counts as L1 yes. Write the WBS, then execute **only the first epic**.

Do not start L4/L5 work before that yes (or the !auto exception).

## Execution window

TodoWrite is **not** the tree. Put only the current **1–3 L5** packages (or L4 if this slice is not yet split).

Closed a package → mark `done` in the WBS file → take the next. One status source.

## L5 `verify:` by domain

| Domain | Evidence |
|--------|----------|
| Code | Test, lint, browser flow, or `detect_changes` |
| SEO/GEO | Audit output or checklist result |
| Design | Browser snapshot vs contract |
| n8n | Valid JSON + dry-run |
| Governance | Boss report format; no silent critical edits |

A package without `verify:` is incomplete. Do not fake a command — name the real check.

## Parallel

Ephemeral Task subagents only if L2 share **no** files/state and Boss did not forbid. No Squad restore.

## Do not

- Always-on 5 levels
- Restore `skills/_quarantine/writing-plans`
- New MCP, new permanent agent, auto-`CreateGoal`
- Second todo list that diverges from the WBS file
