---
name: Hub Deep Dive Fixes
overview: "S4 + P3 design-refs/Notion/models DONE. Open: deferred Boss refresh + budget (нет цифры)."
todos:
  - id: s4-reaudit
    content: "Старт сессии: короткий re-audit hub → ai-tracking/SESSION-4-REAUDIT.md"
    status: completed
  - id: canvas-full-sync
    content: "P0: полный sync canvas hub-deep-dive-audit"
    status: completed
  - id: stale-markers
    content: "P0: синхронизировать SESSION-3 markers"
    status: completed
  - id: index-dedupe
    content: "P1: _INDEX frontend-design dedupe"
    status: completed
  - id: gate-smoke
    content: "P1: gate-smoke checklist"
    status: completed
  - id: taxonomy-refresh
    content: "P1: taxonomy + MCP post-S3 notes"
    status: completed
  - id: s3-plan-close
    content: "P1: close 3_sessions plan todos"
    status: completed
  - id: deferred-boss
    content: "P1: Boss — закрыть Cursor → cursor-system-refresh-deferred.ps1"
    status: pending
  - id: design-refs
    content: "P3: 4 design-ref URL в canvas + design-refs-canon.md"
    status: completed
  - id: notion-publish
    content: "P3: Notion pages under Prompt Coach hub"
    status: completed
  - id: models-closed
    content: "P3: model-map unlock CLOSED — Boss настроил Settings сам"
    status: completed
  - id: budget
    content: "P3: budget $/mo — ждём цифру"
    status: pending
isProject: false
---

# Hub Deep Dive — план (S4 + P3 partial)

**Не трогать:** `hooks.json` · mcp secrets · markitdown · `agents/*.md` model lines (Boss закрыл unlock — не sync).

---

## Notion — куда пишем (канон)

| Уровень | Название | ID / URL |
|---------|----------|----------|
| Hub (parent) | 📚Мой promt-engineering… | [`3966689eb5b880f68f77dbfba5efeed2`](https://app.notion.com/p/3966689eb5b880f68f77dbfba5efeed2) |
| Config | `lib/prompt-coach/CoachConfig.json` → `notionHubPageId` | то же |
| Дерево | ⚒️Cursor – промты → ⚙️Cursor… → 📈 Разное… → **1** → hub | |
| Child 2026-07-16 | Design refs | [страница](https://app.notion.com/p/39f6689eb5b8812e99e4ffd26a45aad6) |
| Child 2026-07-16 | Урок план ≠ исполнение | [страница](https://app.notion.com/p/39f6689eb5b8812486aaeaaf9ae4792d) |

Новые уроки промптов / design-canon → **только под этот hub** (не в корень workspace).

---

## Design refs (DONE)

| Роль | URL |
|------|-----|
| Золотой стандарт | https://www.apple.com/ |
| Wow фаворит | https://antigravity.google/ |
| Продающий | https://framery.com/en/ |
| Красота + эффективность | https://www.palantir.com/platforms/aip/ |

Локально: `ai-tracking/design-refs-canon.md` · canvas v4.1

---

## Ещё открыто

1. **deferred-boss** — закрыть Cursor → `commands/cursor-system-refresh-deferred.ps1`  
2. **budget** — когда будет цифра $/mo  

Models unlock — **закрыт** (Boss сам в Settings).
