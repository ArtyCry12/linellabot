# Полный аудит Cursor Hub

**Дата:** 2026-07-10  
**Путь:** `C:\Users\Asus\.cursor` (~454 MB)  
**Средний балл:** 7.6 / 10 (10 осей)

Это разбор **всего** хаба, не только последних установок Phase A.

---

## Инвентарь

| Зона | Что есть | Комментарий |
|------|----------|-------------|
| Rules | ~93 `.mdc` | 3 always-on hub + ~66 agency + on-demand |
| Skills | 77 в `_INDEX.md` | плюс SEO×20, plugin cache, templates |
| Hooks | 6 на промпт + preToolUse + stop | autopilot, router, coach, repo-intake, markitdown, RTK |
| Task Router | 35 маршрутов | `lib/task-router/routes.json` |
| Commands | ~77 `.ps1` | refresh, audit, tests, quiz, SEO |
| Squad | 10 агентов | scout … ship в `agents/squad-*.md` |
| MCP | 17 user + plugin cache | exa, memory, notion, vercel… |
| ai-tracking | ~116 MB | dev-os, production-studio, quiz profile |
| Docs | SYSTEM-REGISTRY, TAXONOMY | knowledge-base ~17 файлов |
| Tests | 11 `*-test.ps1` | markitdown, n8n-templates, rtk добавлены |
| Plugins | always-on rules | exa, zapier, team-kit грузят контекст |
| lib/ | router, coach, prompts | awesome-prompts 659, n8n-templates 297, markitdown, rtk |

---

## Бенчмарки (0–10)

| Ось | Сейчас | Цель | Смысл |
|-----|--------|------|-------|
| Автономия / !auto | 8.0 | 9.0 | autopilot hook работает, но границы размыты |
| Task Router | 8.5 | 9.0 | 35 маршрутов, хороший интент |
| MCP | 7.5 | 8.5 | много серверов, auth и timeout |
| Тесты hub | 6.8 | 8.0 | скрипты есть, CI и полный прогон нет |
| Документация | 8.0 | 8.5 | registry есть, не всё синхронизировано |
| Цена токенов | 7.8 | 8.5 | MarkItDown + RTK + tiktoken; plugin always-on rules |
| Порядок rules/skills | 7.2 | 8.5 | индекс есть, дубли в cache |
| ai-tracking | 6.0 | 8.0 | ~116 MB, нужна чистка и без секретов |
| Интеграции | 7.8 | 9.0 | Phase A 4/4, Notion нестабилен |
| Ясность автоматизации | 6.2 | 8.5 | !auto vs confirm vs plan-first |

---

## 12 зон: что хорошо и что болит

### 1. Rules

**Хорошо:** hub rules компактные (`00-agent-orchestrator`, `AGENTS.md`). On-demand rules не грузятся зря.  
**Болит:** ~66 agency rules и plugin always-on rules (exa, zapier, team-kit) едят токены в каждом чате.  
**Действие:** вынести agency в on-demand; сжать plugin rules.

### 2. Skills

**Хорошо:** `_INDEX.md`, Phase A (llm-council, awesome-prompts, crew-ai, babyagi).  
**Болит:** дубли в `plugins/cache` и `skills/*/library`; сложно найти «каноничный» скилл.  
**Действие:** один путь в SYSTEM-REGISTRY на каждый скилл.

### 3. Hooks

**Хорошо:** autopilot, router, coach, repo-intake, stop с prompt water.  
**Болит:** после правки `hooks.json` нужен Reload Window; легко забыть.  
**Действие:** напоминание в autopilot + POST-RELOAD-GUIDE.

### 4. Task Router

**Хорошо:** 35 маршрутов, SEO, clone, squad, memory, llm-council.  
**Болит:** короткие промпты (<8 символов) пропускаются; иногда двойной inject.  
**Действие:** тесты на top-10 маршрутов.

### 5. MCP

**Хорошо:** exa primary, memory, gitnexus, browser, vercel, supabase.  
**Болит:** Notion timeout; много серверов = auth friction.  
**Действие:** retry + cache; mcp-routing decision tree.

### 6. Commands

**Хорошо:** refresh, audit, cleanup, quiz-ingest, creative-loop, SEO pack.  
**Болит:** не все команды в одном hub-test; новые Phase A команды вручную.  
**Действие:** расширить `hub-learning-test.ps1`.

### 7. Squad

**Хорошо:** 10 ролей, token tier по задаче.  
**Болит:** пользователю не всегда ясно, когда squad vs один агент.  
**Действие:** router → subagent поле + квиз automation.

### 8. ai-tracking

**Хорошо:** dev-os, prompt-lessons, quiz profile, ISSUES-INDEX.  
**Болит:** ~116 MB; риск секретов в логах/промптах; bloat.  
**Действие:** cleanup script, gitignore sensitive paths, archive cold.

### 9. Docs

**Хорошо:** SYSTEM-REGISTRY, TAXONOMY, page-2 tracker.  
**Болит:** часть знаний только в чатах, не в md.  
**Действие:** FULL-SYSTEM-AUDIT + localhost landing как вход.

### 10. Tests

**Хорошо:** p3-system-test, prompt-coach-test, router tests.  
**Болит:** нет CI; score hub tests ~5.4–6.8; repo-intake gaps.  
**Действие:** один `hub-full-test.ps1` перед большими изменениями.

### 11. Plugins cache

**Хорошо:** figma, stripe, vercel skills из коробки.  
**Болит:** always-on rules из cache без явного запроса.  
**Действие:** only-on-demand для plugin rules где можно.

### 12. Phase A интеграции

**Хорошо:** llm-council, awesome-prompts (659), crew-ai crews, babyagi loop.  
**Болит:** awesome-prompts index rebuild вручную; crew JSON без UI.  
**Действие:** refresh.cmd включает rebuild index.

---

## Топ-риски

1. **Секреты в ai-tracking** — проверять перед commit.  
2. **Token bloat** — agency + plugin always-on rules.  
3. **Reload Window** — hooks не подхватятся без reload.  
4. **Автоматизация** — !auto без чётких gate'ов пугает и ломает доверие.

---

## Где смотреть дальше

- Лендинг: `docs/ecosystem-audit/index.html` → `http://localhost:8765`  
- Слабые места: `ai-tracking/ISSUES-INDEX.md`  
- Трекер Notion «2»: `ai-tracking/notion-prompts/page-2-EXECUTION.md`  
- Квизы → `ai-tracking/user-profile/profile.json`

---

## Язык для обучения

Пользователь просит **простой русский** и humanizer-main для текстов обучения.  
Правило: `rules/humanizer-writing.mdc`.  
Профиль: `ai-tracking/user-profile/writing-preferences.json`.
