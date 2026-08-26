# Карта видимости Cursor Hub

**Дата:** 2026-08-15 · **Скан:** `ai-tracking/hub-load-inventory.json`  
**Баги:** [`ai-tracking/hub-load-audit.md`](ai-tracking/hub-load-audit.md)  
**Канон слоёв:** [`SYSTEM-REGISTRY.md`](SYSTEM-REGISTRY.md)

Это навигация «что где и что стартует всегда». Файлы скиллов **не удалять** — снимать с автозапуска.

## Как читать за 30 секунд

1. После Reload Window в профиле **core** стартуют только `memory` + `gitnexus`. Остальное — `mcp-profile.ps1`.
2. GitNexus: heap **1536 МБ**. GitHub repo **cursor-hub-artyom** (папка `.cursor` не переименовывать). Индекс пересобирается после rename 2026-08-25. `query()` пустой: FTS LadybugDB **unavailable**. Repair отдельно: `gitnexus analyze --repair-fts`.
3. Always-on хаба: **8** правил в `rules/` (`alwaysApply: true`). `.cursor/rules/` — только **8 stubs** (`alwaysApply: false`). Плагины GitLab/Harness/Zapier не инжектятся. Живые plugin always-on зависят от Cursor UI (Exa, Aikido, team-kit).
4. `.cursorignore` закрывает OD repo, `_archive`, `plugins/cache`, `lib/ecc-src/`, `projects/`. После правки ignore нужен **Reload**.
5. Closeout 2026-08-15: Asus в 5 `rules/*.mdc` → artyo; magnific/figma/prompts.chat parked (note); `prompt-lesson-notion.ps1 -Json` ASCII. Роутер 14/14, health 0 fail, hooks-token PASS, coach 0 FAIL.

### Профили MCP (включены)

| Профиль | Состав |
|---------|--------|
| `core` (сейчас) | `memory`, `gitnexus` |
| `design` | core + `open-design`, `stitch`, `21st`, `context7` |
| `qa` | core + `playwright` |
| `docs` | core + `markitdown-mcp` |
| `ops` | core + `notion`, `n8n-mcp`, `google-workspace` |
| `full` | все из `mcp.json.store`, heap всё равно 1536 |

```text
User prompt
    → hooks (6× PowerShell) → [TASK ROUTE]
    → always-on rules (7 файлов)
    → MCP core (memory + gitnexus) + включённые плагины
    → skill по маршруту (читать SKILL.md)
    → Ecosystem Architect / ephemeral Task по нужде (Squad в архиве)
```

---

## 1. Слои (приоритет)

| # | Слой | Где | Когда грузится сейчас |
|---|------|-----|------------------------|
| 1 | User Rules | настройки Cursor | всегда |
| 2 | Always-on hub rules | `rules/*.mdc` `alwaysApply: true` | каждый чат |
| 3 | On-demand hub rules | остальные `rules/*.mdc` + `rules/agency/` | по задаче / `@` |
| 4 | Stubs rules | `.cursor/rules/` (8 always-on stubs) | не дублировать канон |
| 5 | Skills | `skills/` + `blocks/<id>/skills/` | `_INDEX.md` + LIBRARY-INDEX |
| 6 | MCP user | `mcp.json` (gitignored) | **core:** `memory` + `gitnexus` |
| 7 | MCP plugins | Cursor Plugins + `plugins/cache/` | зависят от включённых плагинов |
| 8 | Subagents | `agents/*.md` | Task tool по имени |
| 9 | GitNexus | `.gitnexus/` + MCP `gitnexus` | процесс + индекс хаба как `cursor-hub-artyom` |
| 10 | Трекинг | `ai-tracking/` | не MCP; диск |

---

## 2. MCP — живой `mcp.json` (профиль **core**)

Документ-тир (`lib/mcp-router/McpTier.ps1`): always-on только `memory`, `gitnexus`.  
Живой файл: **2 сервера**. Полный каталог (21) — в `mcp.json.store`. Остальное — `mcp-profile.ps1`.

### Локальные stdio (CPU / RAM) — 13

| ID | Команда | Нагрузка | Нужен на каждый старт? |
|----|---------|----------|------------------------|
| `gitnexus` | gitnexus.cmd | **высокая** (живой heap **1536**; 4096 только в `gitnexus-reindex.ps1`) | да, в ядре |
| `open-design` | Open Design.exe | **очень высокая** (Electron) | нет → профиль `design` |
| `playwright` | npx @playwright/mcp | **высокая** (браузер) | нет → профиль `qa` |
| `chrome-devtools` | npx chrome-devtools-mcp | **высокая** | нет (дефолт — IDE-browser) |
| `fetch` | python `mcp_server_fetch` | средняя | нет (один URL → Exa / hook) |
| `markitdown-mcp` | markitdown-mcp.exe | средняя | нет; **hook уже always-on** |
| `memory` | npx memory | средняя | да, ядро |
| `stitch` | node stitch-mcp-proxy | средняя | нет → `design` |
| `context7` | npx context7 | средняя | нет → `design` |
| `gemini` | npx gemini | средняя | нет (редко) |
| `iconify` | npx iconify | низкая–средняя | нет |
| `google-workspace` | node wrapper | средняя | нет → `ops` |
| `google-maps` | npx maps mcp | средняя | нет |

### Удалённые HTTP (мало CPU, много схем инструментов в чате) — 8

| ID | Хост | Комментарий |
|----|------|-------------|
| `21st` | 21st.dev | еженедельно → `design`. Дескриптор: `user-21st` |
| `figma` | mcp.figma.com | редко; дубль с plugin-figma |
| `n8n-mcp` | nlmediadev.app.n8n.cloud | не еженедельно → `ops` |
| `prompts.chat` | prompts.chat | редко |
| `notion` | mcp.notion.com | не еженедельно, но «второй мозг» → `ops` |
| `apify` | mcp.apify.com | дубль с plugin-apify |
| `magnific` | mcp.magnific.com | редко |
| `braintrust` | api.braintrust.dev | в store; не в core |

### Профили (команда `mcp-profile.ps1`)

| Профиль | Состав |
|---------|--------|
| `core` | `memory` + `gitnexus` |
| `design` | core + `open-design`, `stitch`, `21st`, `context7` |
| `qa` | core + `playwright` |
| `docs` | core + `markitdown-mcp` (hook остаётся отдельно) |
| `ops` | core + `notion`, `n8n-mcp`, `google-workspace` |
| `full` | текущие 21, откат |

Plugin MCP **не в mcp.json** (включаются плагином): `plugin-exa-exa` (оставить), `cursor-ide-browser` (дефолтный браузер), `plugin-vercel-vercel`, `plugin-supabase-supabase`. Выключить по решению: Zapier, GitLab, Harness.

---

## 3. Rules

### Always-on (`alwaysApply: true`) — 7 файлов в `rules/`

Не выкидывать в оптимизации (мозг системы):

- `00-agent-orchestrator.mdc`
- `task-router.mdc`
- `user-profile.mdc`
- `markitdown.mdc`
- `prompt-engineering-coach.mdc`
- `rtk-token-economy.mdc`
- `ponytail.mdc`

В `SYSTEM-REGISTRY.md` секция Always-on = эти же 7 (включая ponytail и RTK).

### Plugin always-on vs `mcp.json`

Плагинные `.mdc` **не** из живого `mcp.json`. Кэш на диске, инжект только если плагин Enabled.

| Плагин | Правило | В этом чате (2026-08-15) |
|--------|---------|--------------------------|
| Exa | `exa-awareness.mdc` | грузится — оставить |
| Aikido | `auto-scan.mdc` | грузится — оставить |
| cursor-team-kit | `no-inline-imports`, `typescript-exhaustive-switch` | грузится — оставить |
| create-plugin | `plugin-quality-gates.mdc` | грузится — оставить |
| GitLab / Harness / Zapier | workflow / harness / zapier-lifecycle | **не** грузятся (UI off) |

`mcp.json` ядро = `memory` + `gitnexus`. Plugin MCP (Exa, browser, Vercel, …) отдельно.

### On-demand hub — 28 `.mdc` в `rules/` (без agency)

Триггер / `@` / роутер. Agency: **66** файлов, у всех `alwaysApply: false` — так и должно быть.

### Дубль

`rules/` (**25** `.mdc`) и хаб `.cursor/rules/` (**11** stubs, `alwaysApply: false`). Always-on канон лежит в `rules/`. `cursor-sync-workspace-rules.py` (legacy shim: `huashu-sync-workspace-rules.py`) **пропускает** hub root (не плющит stubs) и копирует полный набор `.mdc` в другие workspace.

---

## 4. Skills

| Метрика | Число | Смысл |
|---------|-------|--------|
| `skills/**/SKILL.md` (глубокий обход) | 1246 | все копии, library, repo |
| Open Design vendored `blocks/design/skills/open-design/repo` | 277 | каталог OD, не хаб-скиллы |
| `skills/_archive` | 76 | архив, не грузить в индекс |
| `skills/_INDEX.md` Total | **112** | hub-only; OD repo / archive / library / template не в списке |
| Верхний уровень `skills/<name>/SKILL.md` в индексе | 85 | полка хаба |
| `skills-cursor/` | 20 | встроенные Cursor skills |
| `.cursorignore` | да | фаза 3; нужен Reload Window |

Генератор индекса: [`commands/generate-skill-index.mjs`](commands/generate-skill-index.mjs) пропускает `_archive`, `library`, `template`, `open-design/repo`, `skills-main-top-coding`.

Канонические входы: `skills/_INDEX.md` (после сужения), `SYSTEM-REGISTRY.md` → Top personal skills, `lib/task-router/routes.json` → поле `skill`.

---

## 5. Task Router

Файл: [`lib/task-router/routes.json`](lib/task-router/routes.json)  
Hook: [`hooks/task-router.ps1`](hooks/task-router.ps1) каждый промпт.

- Версия манифеста: 1
- Маршрутов: **72** (в аудите июля 2026 было ~35)
- Проверка 2026-08-15: **0 битых `skill:`, `rule:`, `commands:`** — файлы на диске есть

### Кластеры маршрутов (дубли по смыслу, не дырки)

| Тема | ID | Как дальше |
|------|-----|------------|
| SEO | `seo-geo`, `opc-seo-geo`, `seo-audit-ms`, `programmatic-seo`, `ai-search-optimization`, `entity-seo`, `pagespeed`, `core-web-vitals` | оставить; в фазе 4 уточнить primary |
| n8n | `n8n-automation`, `n8n-workflow-automation`, `n8n-workflow-architect` | complementary, не удалять |
| Браузер | `browser-e2e` (IDE), `playwright-e2e`, `playwright-visual-testing` | дефолт IDE; Playwright = код тестов |
| Notion | `notion-tasks`, `notion-workspace` | оба валидны |
| Design | `open-design`, `21st-design`, `stitch-design`, `figma-design`, `design-stack`, … | профилем MCP, не вырезать маршруты |
| Security | `security-hub`, `security-audit`, + 4 узких | front = hub |

Имена MCP в роутере — **дескрипторы Cursor** (`user-gitnexus`), в `mcp.json` — короткие id (`gitnexus`). Канон 21st: `mcp.json` = `21st`, дескриптор = `user-21st`.

---

## 6. Squad и агенты

Папка [`agents/`](agents/) — 16 файлов. **Не трогать логику.**

Squad (11): `squad-scout`, `squad-architect`, `squad-design`, `squad-build`, `squad-qa`, `squad-review`, `squad-growth`, `squad-ship`, `squad-memory`, `squad-cleanup`, `squad-marketing`.

В `SYSTEM-REGISTRY.md` таблице Squad нет `squad-marketing` (файл есть). `squad-cleanup` в реестре есть, в `routes.json` как `subagent` не вызывается.

Impeccable (4) + `dev-os-research`.

Скилл Squad: `skills/_archive/squad/project-squad/SKILL.md` (archived). Rule removed from live sync.

Роутер ссылается на Squad: scout / architect / design / build / qa / review / growth / ship / memory — cleanup и marketing слабо вшиты в keywords.

---

## 7. Хуки (каждый промпт)

[`hooks.json`](hooks.json)

| Событие | Скрипт | Зачем | Резать в фазе 1? |
|---------|--------|-------|------------------|
| beforeSubmit | `autopilot.ps1` | `!auto` | нет |
| beforeSubmit | `user-profile-intake.ps1` | профиль | нет |
| beforeSubmit | `task-router.ps1` | autorouter | нет |
| beforeSubmit | `prompt-coach-capture.ps1` | уроки | нет |
| beforeSubmit | `repo-intake.ps1` | репо в промпте | нет |
| beforeSubmit | `markitdown-intake.ps1` (timeout 12s) | PDF→md | нет |
| stop | `prompt-coach-stop.ps1` | мини-оценка | нет |
| stop | `notion-autowrite-stop.ps1` | Notion галочки | нет |
| preToolUse Shell | `rtk-cursor-hook.ps1` | сжатие терминала | нет |
| preToolUse | impeccable `hook-before-edit.mjs` | polish | нет |

6 процессов PowerShell на отправку — цена autorouter. Не выкидывать, пока не измерен профиль.

---

## 8. Плагины (кэш на диске ≠ включено в UI)

Папка `plugins/cache/cursor-public/` содержит **44** имени (clones). Кэш ≈ 165 МБ (диск-аудит июля).

Это **не значит**, что все 44 крутятся. Но у включённого плагина часто `alwaysApply: true` внутри кэша (Zapier, GitLab, Harness, Aikido, Omni, Exa, team-kit, create-plugin).

Решение сессии: оставить Exa + Vercel/Supabase; **выключить Zapier, GitLab, Harness** в Settings → Plugins. Чеклист: [`ai-tracking/plugin-disable-checklist.md`](ai-tracking/plugin-disable-checklist.md). Кэш файлов уже в `.cursorignore`.

В `mcp-plugin-tiers-s2.md` уже в disable-archive / low-signal: tavily, browse, braintrust, omni, harness… — живой `mcp.json` это игнорирует (braintrust включён).

---

## 9. GitNexus

- MCP в ядре `core`, heap **1536 МБ** (в store был 4096)
- `.gitnexusignore` отсекает `projects/`, `blocks/design/skills/open-design/repo`, `_archive`, `plugins/cache`, `ai-tracking`, venv
- Старый индекс пока на диске (~12 614 файлов) — `analyze` в этой сессии упал: воркеры не стартовали, пока старые MCP ещё живы
- После Reload: `powershell -File commands/gitnexus-reindex.ps1`

---

## 10. Быстрый индекс «куда идти»

| Ищу | Открыть |
|-----|---------|
| Что умеет хаб | этот файл → реестр |
| Какой скилл на задачу | `lib/task-router/routes.json` → `skill` |
| Список скиллов | `skills/_INDEX.md` (112, hub-only) |
| MCP «должен» | `lib/mcp-router/McpTier.ps1` |
| MCP «как есть» | `mcp.json` + этот файл §2 |
| Squad | `agents/squad-*.md` |
| Agency персона | `rules/agency/_INDEX.md` |
| Баги нагрузки | `ai-tracking/hub-load-audit.md` |
| Тест роутера | `commands/task-router-test.ps1` |
| Health MCP | `commands/mcp-health.ps1` |

---

## 11. Что не ломаем при оптимизации

- Autorouter: `hooks/task-router.ps1` + `routes.json`
- Squad файлы: `skills/_archive/squad/` (не live)
- Always-on семёрка rules выше
- MarkItDown **hook** (MCP — отдельно)
- RTK hook
- `memory` MCP
- GitNexus MCP (только сужение)

Остановка: closeout 2026-08-15 выполнен. Reload Window, чтобы `.cursorignore` вступил в индекс чата. Откат MCP: `mcp-profile.ps1 -Name full`. GitNexus: 1095 файлов, FTS офф (не чинить без отдельной команды).
