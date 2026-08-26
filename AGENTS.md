<!-- gitnexus:start -->
# GitNexus — Code Intelligence

This project is indexed by GitNexus as **cursor-hub-artyom** (3642 symbols, 4203 relationships, 28 execution flows after 2026-08-25 reindex). Local folder stays `.cursor`. Use the GitNexus MCP tools to understand code, assess impact, and navigate safely.

> Index stale? Run `node .gitnexus/run.cjs analyze` from the project root — it auto-selects an available runner. No `.gitnexus/run.cjs` yet? `npx gitnexus analyze` (npm 11 crash → `npm i -g gitnexus`; #1939).

## Always Do

- **MUST run impact analysis before editing any symbol.** Before modifying a function, class, or method, run `impact({target: "symbolName", direction: "upstream"})` and report the blast radius (direct callers, affected processes, risk level) to the user.
- **MUST run `detect_changes()` before committing** to verify your changes only affect expected symbols and execution flows. For regression review, compare against the default branch: `detect_changes({scope: "compare", base_ref: "main"})`.
- **MUST warn the user** if impact analysis returns HIGH or CRITICAL risk before proceeding with edits.
- When exploring unfamiliar code, use `query({search_query: "concept"})` to find execution flows instead of grepping. It returns process-grouped results ranked by relevance.
- When you need full context on a specific symbol — callers, callees, which execution flows it participates in — use `context({name: "symbolName"})`.
- For security review, `explain({target: "fileOrSymbol"})` lists taint findings (source→sink flows; needs `analyze --pdg`).

## Never Do

- NEVER edit a function, class, or method without first running `impact` on it.
- NEVER ignore HIGH or CRITICAL risk warnings from impact analysis.
- NEVER rename symbols with find-and-replace — use `rename` which understands the call graph.
- NEVER commit changes without running `detect_changes()` to check affected scope.

## Resources

| Resource | Use for |
|----------|---------|
| `gitnexus://repo/cursor-hub-artyom/context` | Codebase overview, check index freshness |
| `gitnexus://repo/cursor-hub-artyom/clusters` | All functional areas |
| `gitnexus://repo/cursor-hub-artyom/processes` | All execution flows |
| `gitnexus://repo/cursor-hub-artyom/process/{name}` | Step-by-step execution trace |

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

## Token economy

**RTK** (shell) · **Caveman** (prose) · **Ponytail** (code YAGNI) — `rules/rtk-token-economy.mdc`, `rules/ponytail.mdc`, `skills/ponytail/`.

## Security Hub

Front door: `skills/security-hub/SKILL.md`. Library playbooks: `skills/cybersecurity/`. CI templates: `templates/security-ci/`. Scans: `commands/security-scan.ps1` (DAST/recon need `-Authorized`).

## Open Design

Скилл: `C:/Users/artyo/.cursor/blocks/design/skills/open-design/SKILL.md` (hub bridge: `skills/huashu-design` → open-design). Каталог templates: `blocks/design/skills/open-design/repo/` или `skills/open-design/repo/` если vendored. Обновление: `powershell -File commands/ensure-open-design.ps1` · upstream https://github.com/nexu-io/open-design. Правило: `blocks/design/rules/open-design.mdc` (on-demand). Legacy `@huashu` → тот же скилл. Архив: `skills/_archive/huashu-design/`.

## Clone Website (AI Website Cloner)

Скилл: `C:/Users/artyo/.cursor/skills/clone-website/SKILL.md`. Шаблон Next.js: `skills/clone-website/template/`. Bootstrap в любую папку: `node skills/clone-website/scripts/init-clone-project.mjs <dir>`. Триггеры: `@clone-website`, `/clone-website`, клон/копия сайта. Требует **cursor-ide-browser** MCP.

## Memory stack (DEC-009)

Primary: **`user-memory` MCP** → **`AGENTS.md`** → **`ai-tracking/`** (Dev OS corpus). Route memory via parent agent + `blocks/dev-os` (or hub `skills/dev-os` until split). Project Squad archived.

## 21st Design (21st.dev UI registry)

Скилл: `C:/Users/artyo/.cursor/skills/21st-design/SKILL.md`. Локальный каталог: `lib/21st/search_results.json` (обновление: `node skills/21st-design/scripts/ensure-library.mjs`). Триггеры: `@21st`, 21st.dev, Magic MCP `/ui`, установка компонентов через `shadcn add https://21st.dev/r/...`. MCP: **`21st`** → дескриптор `user-21st` (профиль `design`).

## Оркестрация MCP и скиллов

**Registry:** `SYSTEM-REGISTRY.md` · **Decision tree:** `rules/auto-orchestrator.mdc`

Лёгкое правило-оркестратор: `rules/00-agent-orchestrator.mdc`. Детали MCP — `rules/mcp-routing.mdc`. Синхрон rules: `python commands/cursor-sync-workspace-rules.py` (legacy shim: `huashu-sync-workspace-rules.py`). One-click refresh: `commands/cursor-system-refresh.cmd`.

Текст для **User Rules** (весь Cursor): `open-design-USER-RULES.txt` — компактный блок.

<!-- openrouter-free:start -->
## OpenRouter free models

Canon (find in hub): [`ai-tracking/openrouter-free.md`](ai-tracking/openrouter-free.md) · skill `skills/openrouter-free/SKILL.md` · rule `rules/openrouter-free-routing.mdc` · test `commands/openrouter-free-test.ps1`.

Key: Windows user env `OPENROUTER_API_KEY`. Do **not** Override OpenAI Base URL. Not the cancelled Vercel eve promo.

**Subagent:** even if the role file/`model-map` names GPT/Claude/Grok, boss **replaces** it for draft/routine: OpenRouter wrapper for text; Task `glm-5.2-high` only if Cursor tools are required. Never `inherit` a paid parent for draft work.
<!-- openrouter-free:end -->

<!-- seo-geo-aio:start -->
## SEO + GEO + AIO block

Canon: [i-tracking/ecosystem-governance/blocks/seo-geo-aio/CHARTER.md](ai-tracking/ecosystem-governance/blocks/seo-geo-aio/CHARTER.md) · route seo-geo-aio-block · skill skills/seo-geo.
<!-- seo-geo-aio:end -->
