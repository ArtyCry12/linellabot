---
name: full-repo-quality-release
overview: Провести полный quality-first аудит всего репозитория, устранить найденные дефекты до strict+tests гейта, затем выполнить поэтапные коммиты по структурам и детальный деплой с финальной Playwright-проверкой.
todos:
  - id: baseline-audit
    content: Провести полный quality-first baseline аудит (thermo/code-review + runtime/env/webhook + playwright + supabase checks)
    status: completed
  - id: issue-backlog
    content: Собрать и приоритизировать backlog дефектов P0-P3 с трассировкой по файлам
    status: completed
  - id: iterative-fixes
    content: Итеративно устранить все дефекты до strict_plus_tests гейта с промежуточной валидацией
    status: completed
  - id: perf-seo-pass
    content: Сделать performance + SEO/GEO проход и подтвердить отсутствие регрессий
    status: completed
  - id: final-gate-and-release
    content: Финальный аудит, phased commits, deploy и post-deploy Playwright сводка
    status: completed
isProject: false
---

# Full Repo Audit → Fix → Release

## Цели и гейт
- Охват: **весь репозиторий** (`frontend`, `scripts`, `telegram-bot`, `docs`, env/webhook-цепочка).
- Подход: **quality-first**.
- Definition of done: `strict_plus_tests`:
  - 0 build/type errors,
  - 0 lint errors в изменённых файлах,
  - 0 критичных runtime/API ошибок,
  - webhook smoke pass,
  - Playwright ключевых флоу pass,
  - обязательный прогон доступных тестов/аудитов.
- Релиз: **phased commits** по структурам, затем deploy.

## Фаза 1 — Базовый аудит (без правок)
- Запустить глубокий обзор кода и архитектуры:
  - `/thermo-nuclear-code-quality-review` по текущему diff и ключевым зонам,
  - `/code-review` по критичным файлам (`frontend/app/api/**`, `frontend/lib/referral/**`, `scripts/**`, `telegram-bot/**`).
- Параллельно собрать диагностику выполнения:
  - build/lint/test inventory,
  - env/secret wiring inventory,
  - webhook path validation (`Alchemy -> /api/webhooks/purchase -> Supabase`),
  - `/playwright` сценарии для главной страницы, referral-блока и критичных API-индикаторов.
- Использовать `@plugin-supabase-supabase` для проверки доступности и схемы таблиц referral.

## Фаза 2 — Декомпозиция проблем и приоритизация
- Сгруппировать находки в backlog по уровням:
  - `P0`: блокеры релиза и безопасности,
  - `P1`: функциональные дефекты,
  - `P2`: техдолг/структурные улучшения,
  - `P3`: косметика и не-критичный шум.
- Зафиксировать трассировку: проблема -> файл -> причина -> критерий проверки.

## Фаза 3 — Исправления (итерации до clean state)
- Итеративно закрывать backlog пакетами:
  - API/webhook/env first (надежность и корректность событий),
  - frontend runtime и UX/SEO-perf улучшения,
  - telegram-bot и scripts automation hardening,
  - чистка мусора/кеша без удаления рабочих артефактов.
- После каждого пакета: локальный re-check (build/lint/unit/integration/Playwright smoke).
- Параллельно включать `agents-memory-updater` для фиксации решений и предотвращения повторных ошибок.

## Фаза 4 — Performance + SEO/GEO hardening
- Через `performance-optimizer` провести оптимизацию загрузки/рендера/кеша (без функциональных регрессий).
- Пройти `/seo-geo` профиль на техническую и on-page часть (robots/sitemap/meta/структурные проблемы, если применимо).
- Подтвердить, что улучшения не ломают referral и sale flow.

## Фаза 5 — Финальный аудит перед релизом
- Повторно прогнать:
  - `/thermo-nuclear-code-quality-review`,
  - `/code-review`,
  - полный test matrix,
  - `/playwright` финальный E2E набор.
- Если любой пункт fail — возврат в Фазу 3 до полного green.

## Фаза 6 — Поэтапные коммиты + deploy
- Выполнить **пошаговые коммиты по структурам**:
  - `api/lib`,
  - `scripts/automation`,
  - `frontend/ui/runtime`,
  - `docs/config`.
- Затем детальный deploy с `deployment-expert` (preflight, deploy, post-deploy checks).
- После деплоя: финальный `/playwright` на проде + итоговая сводка по системе.

## Оркестрация инструментов
- Основные: `/thermo-nuclear-code-quality-review`, `/code-review`, `/playwright`, `performance-optimizer`, `deployment-expert`, `agents-memory-updater`.
- MCP/плагины: `@plugin-supabase-supabase` для БД/схемы и валидации интеграции.
- Параллельность: аудит и сбор артефактов — параллельно; правки и фиксация — последовательно по приоритету, затем параллельная валидация там, где безопасно.