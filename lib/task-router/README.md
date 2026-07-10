# Task Router

Automatic intent → skill / MCP / subagent / mode routing for every chat message.

## Flow

```
User prompt
  → hooks/task-router.ps1 (UserPromptSubmit)
  → lib/task-router/Resolve-TaskRoute.ps1
  → scores lib/task-router/routes.json
  → injects [TASK ROUTE] additionalContext
  → agent follows rules/task-router.mdc (always-on)
```

Runs **alongside** `hooks/autopilot.ps1` (autopilot adds execution rights; router adds tool bundle).

## Maintain

| Action | How |
|--------|-----|
| Add route | Edit `routes.json` — keywords (RU+EN), phrases, tags |
| Test | `commands/task-router-test.ps1` |
| Debug one prompt | `commands/task-router-test.ps1 -Prompt "your text"` |
| Full tree | `rules/auto-orchestrator.mdc` |

## Scoring

| Signal | Points |
|--------|--------|
| `@tag` match | 15 |
| Phrase match | 10 |
| Keyword match | 3 each |
| Minimum to inject | 6 (configurable in routes.json) |

## Version

DEC-057 · 2026-07-10
