<!-- gitnexus:start -->
# GitNexus — Code Intelligence

This project is indexed by GitNexus as **.cursor** (11 symbols, 4 relationships, 0 execution flows). Use the GitNexus MCP tools to understand code, assess impact, and navigate safely.

> If any GitNexus tool warns the index is stale, run `npx gitnexus analyze` in terminal first.

## Always Do

- **MUST run impact analysis before editing any symbol.** Before modifying a function, class, or method, run `gitnexus_impact({target: "symbolName", direction: "upstream"})` and report the blast radius (direct callers, affected processes, risk level) to the user.
- **MUST run `gitnexus_detect_changes()` before committing** to verify your changes only affect expected symbols and execution flows.
- **MUST warn the user** if impact analysis returns HIGH or CRITICAL risk before proceeding with edits.
- When exploring unfamiliar code, use `gitnexus_query({query: "concept"})` to find execution flows instead of grepping. It returns process-grouped results ranked by relevance.
- When you need full context on a specific symbol — callers, callees, which execution flows it participates in — use `gitnexus_context({name: "symbolName"})`.

## Never Do

- NEVER edit a function, class, or method without first running `gitnexus_impact` on it.
- NEVER ignore HIGH or CRITICAL risk warnings from impact analysis.
- NEVER rename symbols with find-and-replace — use `gitnexus_rename` which understands the call graph.
- NEVER commit changes without running `gitnexus_detect_changes()` to check affected scope.

## Resources

| Resource | Use for |
|----------|---------|
| `gitnexus://repo/.cursor/context` | Codebase overview, check index freshness |
| `gitnexus://repo/.cursor/clusters` | All functional areas |
| `gitnexus://repo/.cursor/processes` | All execution flows |
| `gitnexus://repo/.cursor/process/{name}` | Step-by-step execution trace |

## CLI

| Task | Read this skill file |
|------|---------------------|
| Understand architecture / "How does X work?" | `.claude/skills/gitnexus/gitnexus-exploring/SKILL.md` |
| Blast radius / "What breaks if I change X?" | `.claude/skills/gitnexus/gitnexus-impact-analysis/SKILL.md` |
| Trace bugs / "Why is X failing?" | `.claude/skills/gitnexus/gitnexus-debugging/SKILL.md` |
| Rename / extract / split / refactor | `.claude/skills/gitnexus/gitnexus-refactoring/SKILL.md` |
| Tools, resources, schema reference | `.claude/skills/gitnexus/gitnexus-guide/SKILL.md` |
| Index, status, clean, wiki CLI commands | `.claude/skills/gitnexus/gitnexus-cli/SKILL.md` |

<!-- gitnexus:end -->

## Huashu Design (花叔 Design)

Скилл: `C:/Users/Asus/.cursor/skills/huashu-design/SKILL.md` (или `~/.agents/skills/`). Обновление: `npx.cmd skills add alchaincyf/huashu-design`. Правило в `.cursor/rules/huashu-design.mdc` подключается **по релевантности** (не always-on), чтобы не раздувать контекст.

## Clone Website (AI Website Cloner)

Скилл: `C:/Users/Asus/.cursor/skills/clone-website/SKILL.md`. Шаблон Next.js: `skills/clone-website/template/`. Bootstrap в любую папку: `node skills/clone-website/scripts/init-clone-project.mjs <dir>`. Триггеры: `@clone-website`, `/clone-website`, клон/копия сайта. Требует **cursor-ide-browser** MCP.

## Obsidian MCP (always-on, автономный)

MCP `obsidian` в `mcp.json`. Правило `rules/obsidian-mcp.mdc` — **always-on**: агент **сам** создаёт/редактирует/удаляет заметки после содержательной работы, **без** запроса «сохранить?». Скилл: `skills/obsidian-mcp/SKILL.md`. Obsidian Desktop должен быть запущен.

## 21st Design (21st.dev UI registry)

Скилл: `C:/Users/Asus/.cursor/skills/21st-design/SKILL.md`. Локальный каталог: `lib/21st/search_results.json` (обновление: `node skills/21st-design/scripts/ensure-library.mjs`). Триггеры: `@21st`, 21st.dev, Magic MCP `/ui`, установка компонентов через `shadcn add https://21st.dev/r/...`. MCP: `@21st-dev/magic` (ключ: https://21st.dev/magic/console).

## Оркестрация MCP и скиллов

**Registry:** `SYSTEM-REGISTRY.md` · **Decision tree:** `rules/auto-orchestrator.mdc`

Лёгкое правило-оркестратор: `rules/00-agent-orchestrator.mdc`. Детали MCP — `rules/mcp-routing.mdc`. Синхрон rules: `python commands/huashu-sync-workspace-rules.py`. One-click refresh: `commands/cursor-system-refresh.cmd`.

Текст для **User Rules** (весь Cursor): `huashu-design-USER-RULES.txt` — компактный блок.