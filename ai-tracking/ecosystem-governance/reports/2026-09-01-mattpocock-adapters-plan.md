# Plan: Matt-inspired adapters (grill + context + wayfinder)

**Status:** READY_TO_COMMIT — 0 unresolved actionable findings (remediation 2026-09-01)  
**Date:** 2026-09-01  
**Upstream:** https://github.com/mattpocock/skills (MIT) — **не клонировать пакет**  
**Canon:** quarantine `skills/_quarantine/mattpocock-skills` **остаётся**  
**Block:** `blocks/dev-os/`  
**After ship:** `agents/adversarial-hub-auditor.md` (другой агент, не исполнитель)

## Решение (коротко)

Не ставим `mattpocock/skills` как плагин и не делаем `npx skills add` целиком.  
Берём **три дисциплины** и вписываем в хаб adapter'ами:

1. **Grill-rounds** — дерево решений, раунды до пустой границы, своя рекомендация в каждом вопросе. Только **до старта**. После «поняли друг друга» — работа без пауз.
2. **Project-context** — короткий `CONTEXT.md` в **клиентском/целевом репо**, не в хабе. Notion не меняем.
3. **Wayfinder** — карта решений для «с нуля», **перед** WBS. WBS (`task-decomposition`) не заменяем.

Пакет Мэтта в карантине. `ask-matt`, `setup-matt-pocock-skills`, TDD, Claude-plugin — **не трогать**.

## Почему так (не радикальная перестройка)

- С «с нуля» сейчас слабо: маршрут `clarify-first` ловит «с нуля», но грузит `prompt-engineering-coach` — это не сборка проекта.
- Superpowers `brainstorming` спрашивает **по одному** — хуже, чем у Мэтта (раунд фронтира) и хуже, чем AskQuestion.
- Карантинный `grill-me` — старая версия «по одному вопросу». Не восстанавливать.

## Не делать

- Clone git в `skills/`
- Claude Code plugin `mattpocock-skills`
- Второй роутер `ask-matt`
- Linear/GitHub как обязательный трекер
- Always-on правило с полным текстом grilling (раздует токены)
- Восстанавливать карантинные копии как CORE
- Wizard, TDD, prototype, implement, teach, writing-*

## Файлы (минимум)

| Path | Action |
|------|--------|
| `blocks/dev-os/skills/grill-rounds/SKILL.md` | NEW adapter, attribution upstream |
| `blocks/dev-os/skills/project-context/SKILL.md` | NEW, пишет CONTEXT.md только вне хаба |
| `blocks/dev-os/skills/wayfinder/SKILL.md` | NEW, карта решений → потом WBS |
| `blocks/dev-os/rules/grill-rounds.mdc` | on-demand, не alwaysApply |
| `lib/task-router/routes.json` | clarify-first → grill-rounds; новый route from-scratch |
| `rules/user-profile.mdc` | 3–5 строк: крупное/с нуля → grill-rounds; раунды только до старта |
| `skills/brainstorming/SKILL.md` | пометка: Boss large/from-scratch = grill-rounds, не one-at-a-time |
| `skills/task-decomposition/SKILL.md` | пометка: если есть wayfinder-карта — WBS после неё |
| `ai-tracking/ecosystem-governance/registry.json` | три адаптера SECONDARY в блоке dev-os |
| `SYSTEM-REGISTRY.md` | одна строка в секции dev-os |
| `commands/cursor-sync-workspace-rules.py` | прогнать после mdc |
| GitNexus | `node .gitnexus/run.cjs analyze` после файлов |

Не трогать: `skills/_quarantine/*`, MCP profiles, always-on hooks кроме router (routes.json уже подхватывается).

## Поведение grill-rounds

1. Факты (файлы, репо, что уже есть) — агент смотрит сам. Пользователя не спрашивать.
2. Решения — раундами. В раунде весь **фронтир**: вопросы, которые не зависят от ещё неотвеченных.
3. Каждый вопрос: заголовок, варианты, **рекомендация**. Предпочитать AskQuestion.
4. После ответов — новый фронтир. Пока фронтир не пуст.
5. Стоп: пользователь подтвердил общее понимание. Дальше код/сборка **без** «продолжать?».
6. Язык: простой русский.
7. Середина протокола: не гриллить. Исключения как в user-profile (commit/push/deploy/delete/secrets/mcp/WBS).

## Поведение project-context

- Только если workspace **не** хаб `C:\Users\artyo\.cursor`.
- Файл: `CONTEXT.md` в корне целевого репо (или `docs/CONTEXT.md` если корень уже шумный).
- Короткий глоссарий: термины проекта → одно слово/фраза. Не эссе.
- Не заменяет `AGENTS.md` хаба. Не создаёт Linear.

## Поведение wayfinder

- Когда: новый проект / с нуля / кусок больше одной сессии.
- Результат: карта решений (локальный MD в целевом репо), по одному решению за раз **до** старта реализации.
- После карты: вызвать существующий `task-decomposition` (WBS).
- Не тикет-машина GitHub.

## Маршруты

### A. Править `clarify-first`

- `skill`: `blocks/dev-os/skills/grill-rounds/SKILL.md`
- `rule`: `rules/user-profile.mdc` + `blocks/dev-os/rules/grill-rounds.mdc`
- keywords добавить: `grill`, `допрос`, `согласовать план`
- note: не coach; coach остаётся на route `prompt-coach`

### B. Новый `from-scratch`

- id: `from-scratch`
- keywords: новый проект, с нуля, greenfield, wayfinder, карта решений
- skill: `blocks/dev-os/skills/wayfinder/SKILL.md`
- secondary в note: после карты — grill если ещё не было, затем WBS
- mode: plan
- Не дублировать `project-squad` (архив)

`maxRoutes: 2` — пара `clarify-first` + `from-scratch` допустима.

## WBS этой поставки (для исполнителя)

- L1: Adapter'ы Мэтта в блоке dev-os + роутер, без пакета.
- L2a: Три SKILL.md + on-demand rule.
- L2b: routes + user-profile pointer + registry + SYSTEM-REGISTRY.
- L2c: sync rules + GitNexus analyze.
- L5 verify: `powershell -File commands/task-router-test.ps1`; ручная проверка что `rg grill-rounds lib/task-router/routes.json` находит skill path; карантин mattpocock не в routes.

## Исполнитель / аудитор

1. Исполнитель: ephemeral Task `generalPurpose`, не Squad, не этот чат-архитектор.
2. После зелёного verify — **другой** агент `adversarial-hub-auditor` (read-only).
3. Коммит только если Boss отдельно скажет да.

## Источники текста (читать, не копировать репо)

- https://raw.githubusercontent.com/mattpocock/skills/main/skills/productivity/grilling/SKILL.md
- https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/wayfinder/SKILL.md
- https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/domain-modeling/SKILL.md  
Адаптировать под хаб (русский, AskQuestion, Notion, запрет CONTEXT.md в хабе). Не вставлять slash-commands Claude `/grill-me`.

## Remediation closeout (2026-09-01)

Auditor `PASS-WITH-RESIDUALS` → all **actionable** items closed.

| Finding | Close |
|---------|--------|
| 1 ERROR phrases vs minScore | phrases + UTF-8 probes in `commands/task-router-utf8-check.py` |
| 2 ERROR wayfinder ticket machine | one `docs/wayfinder.md` then WBS |
| 3 GitNexus stale / FTS | reindex 2026-09-01; ignore hang files + quarantine + old clone. Gate: `commands/gitnexus-test.ps1` → plan `ai-tracking/ecosystem-governance/reports/2026-09-01-gitnexus-fixes-pipeplan.md` + incident `2026-09-01-gitnexus-reindex-incident.md` |
| 4 tests miss new routes | samples + UTF-8 check; test 0/16 |
| 5 `_INDEX.md` | `generate-skill-index.mjs` includes three adapters |
| 6 maxRoutes dual load | by design; sequence in `from-scratch` note |
| 7 from-scratch re-injects user-profile | rule removed |
| 8 project-context not routed | route `project-context` |
| 9 quarantine discoverable + npx | `.cursorignore` + stub SKILL, no install commands |
| 10 registry `updatedAt` | bumped |

Actionable findings: **0**. Commit only if Boss says да. No push.

