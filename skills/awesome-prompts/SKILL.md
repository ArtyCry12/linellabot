---
name: awesome-prompts
description: >-
  Match and adapt user prompts using local index from f/awesome-chatgpt-prompts
  (prompts.chat). Use when the user writes a vague or short prompt and a proven
  template would help. Does NOT load the full repo into context — local index +
  optional prompts.chat MCP fallback. Triggers: улучши промт, prompt template,
  act as, @awesome-prompts.
version: "1.0.0"
license: Apache-2.0
compatibility: cursor
metadata:
  author: hub
  version: "1.0.0"
  source: https://github.com/f/awesome-chatgpt-prompts
when_to_use: vague_user_prompt, prompt_improvement, role_play_template
argument-hint: "[user prompt to match]"
---

# Awesome Prompts — local matcher + adapter

Источник: [f/awesome-chatgpt-prompts](https://github.com/f/awesome-chatgpt-prompts) / [prompts.chat](https://prompts.chat).

## Принцип

**Never** загружай весь CSV/README в контекст. Только:

1. `Find-PromptTemplates` → top 3 по ключевым словам
2. `Get-PromptTemplateById` → полный текст **одного** шаблона
3. Адаптация под задачу пользователя (язык, домен, переменные `${key}`)

## Когда включать

- Промпт пользователя короткий/размытый (< 80 символов без структуры)
- «Сделай как expert / act as / улучши мой промт»
- Нужен role-play или structured system prompt

**Skip** если: `!auto`, уже есть Deliverables/контракт, или prompt-coach lesson mode.

## Алгоритм

### 1. Match (local, fast)

```powershell
powershell -File commands/awesome-prompts-match.ps1 -Query "<user text>" -Top 3
```

Или dot-source `lib/awesome-prompts/Match-PromptTemplate.ps1` → `Find-PromptTemplates`.

### 2. Load winner only

```powershell
powershell -File commands/awesome-prompts-match.ps1 -Id <id> -Full
```

### 3. Adapt

- Перевести на язык пользователя (RU если пользователь на RU)
- Подставить переменные: `Expand-PromptTemplate -Variables @{ character = "..." }`
- Добавить hub-контекст: task-router route, релевантный skill, MCP
- **Не** копировать шаблон 1:1 если задача уже конкретная — только borrow structure

### 4. MCP fallback (optional)

Если local match score < 8 или 0 results:

- `search_prompts` on `prompts.chat` MCP (already in `mcp.json`)
- `improve_prompt` для структурирования

## Index maintenance

```powershell
powershell -File commands/build-awesome-prompts-index.ps1
```

Outputs:

| File | Role |
|------|------|
| `lib/awesome-prompts/prompt-index.json` | search (committed after build) |
| `lib/awesome-prompts/prompt-corpus.jsonl` | full text by id (gitignored, rebuild locally) |

## Anti-patterns

- Loading PROMPTS.md or full CSV into chat
- Applying template without adapting to user's actual goal
- Replacing user's explicit constraints with template defaults

## Связи

- `rules/awesome-prompts.mdc`
- `rules/prompt-engineering-coach.mdc` — lessons, not templates
- `mcp.json` → `prompts.chat` remote MCP
