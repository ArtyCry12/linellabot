---
name: n8n-templates
description: >-
  Match and import n8n workflows from awesome-n8n-templates (280+ JSON).
  Local index only — never load all templates into context. Use with n8n-mcp
  for deploy/validate. Triggers: n8n template, workflow template, @n8n.
version: "1.0.0"
license: MIT
compatibility: cursor
metadata:
  author: hub
  version: "1.0.0"
  source: https://github.com/enescingoz/awesome-n8n-templates
when_to_use: n8n_workflow_from_template, automation_blueprint
argument-hint: "[user automation goal]"
---

# n8n Templates — local matcher

Источник: [awesome-n8n-templates](https://github.com/enescingoz/awesome-n8n-templates).

## Принцип

**Never** грузить все 280+ JSON в контекст. Только:

1. `Find-N8nTemplates` → top 3 по задаче
2. `Get-N8nTemplateById` → один workflow JSON
3. Адаптация + валидация через `skills/n8n-workflow/` + `n8n-mcp`

## Индекс

```powershell
powershell -File commands/build-n8n-templates-index.ps1 -ForceClone
```

Хранится в `lib/n8n-templates/template-index.json` (поиск) и `template-corpus.jsonl` (полный JSON по id).

## Match

```powershell
powershell -File commands/n8n-templates-match.ps1 -Query "telegram AI bot" -Top 3
powershell -File commands/n8n-templates-match.ps1 -Id 42 -Full
```

## Алгоритм

1. Match top 3 шаблона по ключевым словам (title, category, nodes, triggers)
2. Показать пользователю краткий список (title, category, score)
3. Загрузить **один** winner через `-Id N -Full`
4. Применить правила `skills/n8n-workflow/SKILL.md` (expressions, validation)
5. Если `n8n-mcp` подключён: `validate_workflow`, deploy на instance

## Пары слоёв

| Слой | Роль |
|------|------|
| Этот skill | Поиск шаблона |
| `n8n-workflow` | Правила JSON, expressions, anti-hallucination |
| `n8n-mcp` | Live nodes DB, validate, deploy |

## Анти-паттерны

- Копировать весь README репо в чат
- Деплоить без validate
- Путать Zapier MCP с n8n
