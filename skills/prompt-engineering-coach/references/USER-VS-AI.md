# Как отличить промт пользователя от ИИ / системы

## Точно НЕ пользователь (не включать в урок)

| Признак | Пример |
|---------|--------|
| Системный follow-up Cursor | `Briefly inform the user about the task result…` |
| Plan mode вставка | `Implement the plan as specified. Do NOT edit the plan file.` |
| To-do оркестрация | `Mark them as in_progress… Don't stop until completed` |

Фильтр в `lib/prompt-coach/CoachConfig.json` → `noisePatterns`.

## Скорее пользователь

- Русский текст, опечатки, разговорный поток
- `!auto`, `/autopilot`, `/project-squad`, `@теги`
- Конкретные пути: `C:\Users\…`, `ai-tracking/…`
- Длинные ТЗ своими словами (mega-prompt из Notion)
- Уточнения: «дополню», «смотри», «postscriptum»

## Серая зона — вставка из ИИ

Пользователь мог **скопировать** сгенерированный Plan:

- Английский, идеальная грамматика
- «Implement», «Do NOT edit», bullet structure

**В уроке:** пометь «это был plan-шаблон, не твой голос» и учи писать **свой** короткий аналог на русском.

## Источники для анализа

1. `ai-tracking/prompt-lessons/_capture.jsonl` (primary)
2. `projects/.../agent-transcripts/*.jsonl` — role `user`, если capture пуст
3. Текущий чат — только сообщения пользователя в этой сессии
