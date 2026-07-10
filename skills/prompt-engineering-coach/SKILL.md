---
name: prompt-engineering-coach
description: >-
  Параллельное обучение prompt engineering: захват промтов, mini-score 7/10,
  brief-уроки, Notion publish (с approval), monthly cheatsheet, autopilot contract.
  Notion: 📚Мой promt-engineering. Триггеры: урок промта, /prompt-lesson.
argument-hint: "[status | write lesson | notion | cheatsheet]"
user-invocable: true
---

# Prompt Engineering Coach (DEC-058 + DEC-059)

**Notion:** [📚Мой promt-engineering](https://app.notion.com/p/3966689eb5b880f68f77dbfba5efeed2)  
**Уроки:** `ai-tracking/prompt-lessons/`  
**Тест:** `commands/prompt-coach-test.ps1`

## 4 функции обучения

| # | Функция | Как |
|---|---------|-----|
| 1 | **Mini-score** | Конец сессии: `Промт X/10` + `Register-MiniScore` |
| 2 | **Brief-урок** | Когда READY или «урок промта» |
| 3 | **Notion** | После урока спросить «да» → `prompt-lesson-notion.ps1` → MCP |
| 4 | **Cheatsheet** | `prompt-hooks-cheatsheet.ps1` раз в 30 дней |

Плюс: **контракт** в `!auto` — `Deliverables / Не трогать / Готово когда` (hook подсказывает агенту).

## Автоматика

| Компонент | Роль |
|-----------|------|
| `hooks/prompt-coach-capture.ps1` | Копит промты |
| `hooks/prompt-coach-stop.ps1` | Напоминание mini-score |
| `hooks/autopilot.ps1` | Контракт mega-задач |
| `lib/prompt-coach/PromptCoach.ps1` | State, scores, cheatsheet, Notion payload |

## Урок — когда и как

См. `references/GATING.md`. Шаблон: `templates/prompt-lesson/LESSON-TEMPLATE.md`.

После урока:

```powershell
. lib/prompt-coach/PromptCoach.ps1
Complete-CoachLesson -Slug "YYYY-MM-DD-slug"
```

Спросить: **«Опубликовать урок в Notion?»** → `references/NOTION-PUBLISH.md`

## Mini-score

Формат: `**Промт 7/10** — одна причина.`  
Не путать с полным уроком. Лог: `_scores.jsonl`.

## Cheatsheet

```powershell
powershell -File commands/prompt-hooks-cheatsheet.ps1
```

Файл: `ai-tracking/prompt-lessons/cheatsheet-YYYY-MM.md`

## Пользователь vs ИИ

`references/USER-VS-AI.md` · `references/STYLE.md`

## Команды

| Команда | Действие |
|---------|----------|
| `prompt-coach-status.ps1` | Готовность урока |
| `prompt-coach-test.ps1` | Прогон системы |
| `prompt-lesson-notion.ps1 -LessonPath …` | Пакет для Notion |
| `prompt-hooks-cheatsheet.ps1` | Топ-5 хуков |
