---
name: llm-council
description: >-
  Use when discussing tasks, architecture, or hard decisions and multiple LLM
  perspectives help. Adapts karpathy/llm-council 3-stage flow (opinions →
  anonymized review → chairman synthesis) via Cursor Task subagents — no
  OpenRouter app required. Triggers: council, несколько мнений, обсудим задачу,
  trade-offs, llm-council.
version: "1.0.0"
license: MIT
compatibility: cursor
metadata:
  author: hub
  version: "1.0.0"
  source: https://github.com/karpathy/llm-council
when_to_use: task_discussion, architecture_decision, multi_perspective_review
argument-hint: "[question or task to council]"
---

# LLM Council (Cursor adaptation)

Паттерн из [karpathy/llm-council](https://github.com/karpathy/llm-council): не один ответ, а **совет моделей** с cross-review.

## Когда включать

- Обсуждение задачи, архитектуры, «как лучше сделать»
- Спорные trade-offs (скорость vs качество, monolith vs micro)
- Пользователь просит «несколько мнений», «council», «совет»

**Не** поднимать для мелких правок, typo, single-file fix.

## 3 стадии (обязательно)

### Stage 1 — First opinions

Запусти **2–3 параллельных** `Task` subagent (`generalPurpose` или доменный: `squad-architect`, `plugin-architect`):

| Seat | Роль | Фокус |
|------|------|-------|
| A | Pragmatist | минимальный diff, ship fast |
| B | Architect | структура, границы, maintainability |
| C | Skeptic | риски, edge cases, что сломается |

Каждый получает **один и тот же** вопрос пользователя. Сохрани ответы как Opinion-A/B/C (без имён моделей в Stage 2).

### Stage 2 — Anonymized review

Один subagent (reviewer) получает все мнения **без привязки к seat**. Задача:

1. Ранжировать по точности и insight (1–3)
2. Кратко: сильные/слабые стороны каждого
3. Где мнения расходятся

### Stage 3 — Chairman synthesis

Ты (или `squad-architect` как chairman) выдаёшь **один финальный ответ**:

- Рекомендация
- Что взять из каждого мнения
- Явные риски и «если !auto — делай так»

## Формат выдачи пользователю

```markdown
## Council: [тема]

### Мнения (кратко)
- **A (Pragmatist):** …
- **B (Architect):** …
- **C (Skeptic):** …

### Cross-review
…

### Решение chairman
…
```

## Ограничения hub

- DEC-004: max 10 squad agents / session — council = 3–4 subagent calls max
- Не требует OpenRouter / локального FastAPI из оригинального репо
- Для **!auto A** на repo-intake: skill + rule + route, не клон всего приложения

## Связи

- `rules/llm-council.mdc` — триггер
- `lib/task-router/routes.json` — id `llm-council`
- `docs/knowledge-base/FOUNDATION-REPOS.md` — запись karpathy/llm-council
