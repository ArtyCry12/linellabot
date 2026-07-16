---
name: Hub Deep Dive Fixes
overview: "S4 in progress/complete P0–P1. P3 backlog. Не трогать hooks.json, mcp secrets, markitdown, agents model lines."
todos:
  - id: s4-reaudit
    content: "Старт сессии: короткий re-audit hub → ai-tracking/SESSION-4-REAUDIT.md (skills/rules/MCP/routes/canvas/tests)"
    status: completed
  - id: canvas-full-sync
    content: "P0: полный sync canvas hub-deep-dive-audit (версия, секции, drift, ACTION_ITEMS vs post-S3 reality)"
    status: completed
  - id: stale-markers
    content: "P0: синхронизировать SESSION-3-REAUDIT + SESSION-3-COMPLETE (убрать ложные TODO на уже сделанное)"
    status: completed
  - id: index-dedupe
    content: "P1: убрать дубль frontend-design в skills/_INDEX.md + regenerate index"
    status: completed
  - id: gate-smoke
    content: "P1: smoke design-gate Applied + route-echo «Подключил» (чеклист/мини-тест, без hooks.json)"
    status: completed
  - id: taxonomy-refresh
    content: "P1: освежить skills-taxonomy-s2 + mcp-plugin-tiers-s2 даты/дрифт после S3"
    status: completed
  - id: s3-plan-close
    content: "P1: закрыть todos в plans/3_sessions_hub_refactor_*.plan.md (S1–S3 completed)"
    status: completed
  - id: deferred-boss
    content: "P1: Boss checklist — закрыть Cursor → cursor-system-refresh-deferred.ps1"
    status: pending
  - id: design-refs
    content: "P3: 3 design-ref сайта в canvas (когда будут URL)"
    status: pending
  - id: budget-notion-models
    content: "P3: budget $/mo · Notion publish уроков · model-map unlock (только после снятия trust_manual)"
    status: pending
isProject: false
---

# Hub Deep Dive — план (S4 executed P0–P1)

**Роль:** канон deep-dive. S4 закрыл P0–P1; **P3** и **deferred-boss** открыты.

**Не трогать:** `hooks.json` · mcp secrets · markitdown · `agents/*.md` model lines / model-map (`trust_manual`).

```mermaid
flowchart TD
  s4done[S4 P0-P1 DONE]
  deferred[Boss deferred refresh]
  p3[P3 backlog]
  s4done --> deferred
  s4done --> p3
```

---

## S4 deliverables (DONE)

| Todo | Artifact |
|------|----------|
| `s4-reaudit` | `ai-tracking/SESSION-4-REAUDIT.md` |
| `canvas-full-sync` | canvas `v4.0 · 16.07.2026 S4` |
| `stale-markers` | SESSION-3 SUPERSEDED banner + COMPLETE updated |
| `index-dedupe` | `generate-skill-index.mjs` skip nested; `_INDEX` 1× frontend-design (118) |
| `gate-smoke` | `ai-tracking/GATE-SMOKE-S4.md` |
| `taxonomy-refresh` | post-S3 notes in taxonomy + mcp tiers |
| `s3-plan-close` | `3_sessions_hub_refactor_*.plan.md` todos completed |

Tests: `task-router-test` PASS · `find-skills-test` PASS.

---

## Справка S1–S3 (не чинить)

find-skills · taxonomy · MCP tiers · design matrix · route echo · cleanup · dual review · digest · agency off · LVM JSON.

---

## Ещё открыто

### P1 — Boss

**`deferred-boss`** (только ты):

1. Закрыть Cursor  
2. `powershell -File commands/cursor-system-refresh-deferred.ps1`  
3. Reload Window — только если меняли hooks (**не меняли**)

### P3 backlog

- **`design-refs`** — 3 URL в canvas  
- **`budget-notion-models`** — budget · Notion · model-map unlock после снятия lock  

---

## Design matrix (канон)

`rules/design-stack.mdc` + `agents/squad-design.md` — без переписи в S4.

---

## Готово когда (S4)

1. SESSION-4-REAUDIT — **есть**  
2. Canvas ≥ v4.0 — **есть**  
3. Stale markers — **есть**  
4. `_INDEX` без дубля frontend-design — **есть**  
5. P0–P1 completed; P3 + deferred pending — **да**  
6. Boss reminder deferred — **ниже в чате**
