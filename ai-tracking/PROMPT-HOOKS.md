# Prompt hooks — фразы которые система понимает чётко (REQ-071)

**Авто-роутинг (DEC-057):** на **каждый** промпт `hooks/task-router.ps1` подставляет `[TASK ROUTE]` — skill/MCP/subagent. Ручные фразы ниже усиливают или дублируют маршрут.

Используйте в запросах для однозначного роутинга.

## Фазы и статус

| Фраза | Действие агента |
|-------|-----------------|
| «залогинен» | Продолжить live browser audit (okara и т.д.) |
| «P2» / «фаза 2» | Skills, repos KB, SEO stack, guardrails |
| «P3» / «фаза 3» | Production Studio, system test |
| «обнови статус в Notion» | MCP → комментарий/страница статуса |

## Squad & агенты

| Фраза | Route |
|-------|-------|
| `/project-squad` | 10 agents, DEC-004 |
| «squad-build» | Реализация кода |
| «squad-qa» | lint/typecheck/build |
| «только scout» | Аудит без правок |

## MCP & инструменты

| Фраза | Route |
|-------|-------|
| `@seo-geo` | SEO/GEO pack |
| `@huashu` | HTML/deck/motion |
| `@21st` | shadcn registry |
| `@clone-website` | Клон сайта |
| «PageSpeed» | `pagespeed-audit.ps1` |
| «seo audit» | `seo-audit.ps1` + seo-geo |
| **`/autopilot`** | Slash: полная автоматизация + задача |
| **`!auto`** / **`!авто`** | Hook: тот же режим |
| **«P3 test»** | `p3-system-test.ps1` |
| **«P3 ready»** | `p3-ready-check.ps1` → playbook |
| **«post reload»** | `POST-RELOAD-GUIDE.md` + `p3-final-audit.ps1` |
| **`/route`** | Preview task-router classification |

## Авто (без фраз)

Любой запрос с ключевыми словами (seo, клон, storyboard, notion, …) → см. `lib/task-router/routes.json`

## Prompt coach (DEC-058)

| Фраза | Route |
|-------|-------|
| «урок промта» | prompt-engineering-coach → brief в `prompt-lessons/` |
| `/prompt-lesson` | То же + skill |
| `prompt-coach-status` | Готовность следующего урока |
| `prompt-hooks-cheatsheet` | Топ-5 твоих хуков за месяц |
| `Deliverables / Не трогать / Готово когда` | Контракт для !auto mega-задач |

## Память

| Фраза | Route |
|-------|-------|
| «запомни» | user-memory + squad-memory |
| «handoff» | шаблон `templates/squad-handoff.md` |

## Анти-паттерны (размытые запросы)

- «сделай лучше» → уточнить метрику
- «настрой всё» → указать фазу P1/P2/P3
- «как в okara» → patterns only, не копировать продукт

*P2 · 2026-07-10*
