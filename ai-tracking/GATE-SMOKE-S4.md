# Gate smoke — route echo + design Applied (S4)

**Date:** 2026-07-16  
**No hooks.json changes.** Rules already contain the gates; this file = checklist + static proof.

## 1. Route echo

**Rule:** `rules/task-router.mdc`  
When prompt has `[TASK ROUTE]` or `[TASK ROUTE - auto-detected]`, first reply block:

```
Подключил: <skill> · <MCP если есть> · <subagent если есть>
```

**Static proof:** clause present (grep `Подключил` in `rules/task-router.mdc` → hit).  
**Live proof (this session):** opening turn used echo form for plan start.

**Router regression:** `powershell -File commands/task-router-test.ps1` → 0/10 no route (S4).

## 2. Design gate handoff

**Rules/agents:** `rules/design-stack.mdc`, `agents/squad-design.md`  
Before Build handoff, deliverable must include:

1. Line `Applied: [skill1, skill2, …]` (min: `frontend-design` for any web UI)
2. Aesthetic direction (one sentence)
3. Typography (display + body; not Inter/Roboto/Arial default)
4. Palette (CSS variables; no purple-gradient-on-white default)
5. Motion (one hero moment)
6. Differentiation (one memorable element)

**Static proof:** matrix + «Echo: Applied» in `design-stack.mdc`; anti-slop section in `squad-design.md`.

## 3. Pass criteria

| Check | Pass if |
|-------|---------|
| Echo rule on disk | `Подключил` in task-router.mdc |
| Design matrix on disk | Stitch + frontend-design + Applied in design-stack.mdc |
| Router tests | PASS |
| Agent behavior | First line of routed answers matches echo (spot-check in chat) |

## Marker
`GATE-SMOKE S4 OK` (static + router tests; live echo demonstrated at session open)
