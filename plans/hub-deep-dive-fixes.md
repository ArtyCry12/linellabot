---
name: Hub Deep Dive Fixes
overview: "Финальный план post S1–S3: design matrix, route-echo, cleanup, dual-review, taxonomy, agency, digest — DONE. Осталось optional canvas ACTION_ITEMS + P3 backlog. Не трогать agents model lines, hooks.json, mcp secrets."
todos:
  - id: design-matrix
    content: "P0: full design matrix in squad-design + routes + design-stack"
    status: completed
  - id: route-echo
    content: "P0: rule-only echo Подключил in rules/task-router.mdc"
    status: completed
  - id: cleanup-safe
    content: "P0: hub-safe-cleanup dry-run → Apply (markitdown sacred)"
    status: completed
  - id: dual-review
    content: "P1: optional dual fanout in pr-review + squad-review protocol"
    status: completed
  - id: boss-guide
    content: "P1: Boss/Auto checklist in this plan"
    status: completed
  - id: router-tests
    content: "P1: task-router-test + find-skills-test PASS"
    status: completed
  - id: taxonomy
    content: "P2: SYSTEM-TAXONOMY + skills-taxonomy-s2 ACTIVE/ON-DEMAND/ARCHIVE"
    status: completed
  - id: agency-ondemand
    content: "P2: agency rules alwaysApply false (66/66)"
    status: completed
  - id: chat-digest
    content: "P2: commands/chat-digest.ps1 without hooks.json"
    status: completed
  - id: deferred-checklist
    content: "P2: deferred refresh checklist in this plan"
    status: completed
  - id: canvas-action
    content: "Optional: refresh canvas ACTION_ITEMS statuses"
    status: pending
  - id: final-summary
    content: "SESSION 3 COMPLETE marker + chat summary"
    status: completed
isProject: false
---

# Hub Deep Dive Fixes — финальная версия (2026-07-16)

Единственный актуальный план. Дубликаты `hub_deep_dive_fixes_*.plan.md` и `2026-07-16-hub-deep-dive-fixes.md` удалены.

**Источники:** canvas `hub-deep-dive-audit` · S1–S3 commits · `ai-tracking/SESSION-3-REAUDIT.md` · `ai-tracking/SESSION-3-COMPLETE.md`

---

## Контекст после S1–S3

| Слой | Статус |
|------|--------|
| find-skills / skills.sh wire | **DONE** (S1 `e0548fc`) |
| Skills taxonomy + archive cleanup | **DONE** (S2) |
| MCP tiers (always / on-demand / archive) | **DONE** |
| Design skills install + routes | **DONE** (`127dd79`) |
| Other Complement installs + routes | **DONE** (`40e8c44`) |
| LVM image JSON | **DONE** |
| Agency alwaysApply off | **DONE** (66/66 false) |
| Route echo в `task-router.mdc` | **DONE** (S3) |
| Design matrix в `design-stack.mdc` + squad-design | **DONE** (S3) |
| hub-safe-cleanup Apply (markitdown sacred) | **DONE** (S3) |
| Dual-review protocol | **DONE** (S3, optional) |
| Chat digest | **DONE** (`commands/chat-digest.ps1`) |
| Router fixes (shadcn / secret-scanning minScore) | **DONE** (`0f9d098`, `319be5c`) |
| Canvas ACTION_ITEMS refresh | **OPEN** (optional) |
| P3 design-ref / budget / Notion / model-map | **BACKLOG** |

---

## Не трогать

- `hooks.json`
- `mcp.json` secrets
- markitdown venv / `.cache/markitdown` (кроме `-IncludeMarkitdownCache`)
- `agents/*.md` **model** lines / `model-map.md` lock
- Клиентские репо вне hub

---

## Design matrix (авторитетная)

См. `rules/design-stack.mdc` + `agents/squad-design.md` (только routing, model не менять).

| Слой | Что | Когда |
|------|-----|--------|
| Mock primary | Stitch MCP + `stitch-shadcn-ui` | Быстрые UI mockups |
| Компоненты | `shadcn` CLI first; fallback `21st-design` | Web app / blocks |
| Figma | Figma MCP | D2C / create file |
| Anti-slop web | `frontend-design` (**required gate**) | Любой web UI |
| Taste / polish / a11y | `design-taste-frontend` · `impeccable` · `web-design-guidelines` | По задаче |
| Deck / HTML / PPTX | `huashu-design` | Не React |
| Clone / UX / DESIGN.md | `clone-website` · `ui-ux-pro-max` · `awesome-design-md` | По задаче |
| Video / LVM | `production-studio` (+ remotion optional) | Motion / Reels |
| Copy / personas | humanizer · agency max 1 | Клиентский RU |

Handoff: `Applied: [skills…]` + anti-slop checklist.

---

## Status board

| Priority | Item | Status |
|----------|------|--------|
| P0 | Design matrix | **DONE** |
| P0 | Route echo «Подключил: …» | **DONE** |
| P0 | Safe cleanup Apply (markitdown KEEP) | **DONE** |
| P1 | Dual review optional | **DONE** |
| P1 | Boss / Auto guide | **DONE** |
| P1 | Router tests | **PASS** |
| P2 | Taxonomy | **DONE** |
| P2 | Agency on-demand | **DONE** |
| P2 | Chat digest | **DONE** |
| P2 | Deferred refresh checklist | **DONE** |
| Optional | Canvas ACTION_ITEMS | **OPEN** |
| P3 | Design refs / budget / Notion / model-map unlock | **BACKLOG** |

---

## Boss / Auto checklist

| Тип задачи | Mode |
|------------|------|
| Plan / architecture / risky refactor | Opus thinking xhigh (вручную) |
| Routine build / docs | Auto / Sonnet |
| Explore codebase | Composer 2.5 (UI Explore) |
| Избегать | Два High на одних и тех же файлах |

---

## Deferred refresh (после сессии)

1. Закрыть Cursor  
2. `powershell -File commands/cursor-system-refresh-deferred.ps1`  
3. Reload Window, если меняли hooks (S3 **не** трогал `hooks.json`)

---

## Осталось (optional / P3)

1. Обновить canvas ACTION_ITEMS под post-S2 реальность  
2. P3: 3 design-ref сайта · budget $/mo · Notion publish · снять `trust_manual` / sync model-map  

---

## Готово когда

1. Этот файл — единственный план deep-dive fixes  
2. P0–P2 закрыты или зафиксированы  
3. Тесты зелёные (`task-router-test`, `find-skills-test`)  
4. Маркер `SESSION 3 COMPLETE` в `ai-tracking/SESSION-3-COMPLETE.md`
