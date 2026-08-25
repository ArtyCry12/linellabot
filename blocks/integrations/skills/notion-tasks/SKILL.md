---
name: notion-tasks
description: >-
  Use when the user shares a Notion URL or asks about tasks, checklists, colors,
  or done/not-done status. Fast pass: what is done, open, blocked. Respects
  automationPrefs.alwaysAsk for MCP writes. Triggers: notion.so, notion task,
  галочки, чеклист.
argument-hint: "<notion-url | sync | status>"
user-invocable: true
---

# Notion tasks (hub)

**Profile:** `ai-tracking/user-profile/profile.json` — confirm-writes for MCP publish.

## When triggered

User pastes `notion.so` / `app.notion.com` or asks «что сделано в Notion».

## Workflow

1. **Read** — `notion` MCP: fetch page + child blocks (tasks, toggles, checkboxes).
2. **Summarize** in plain Russian:
   - Done (checked)
   - Open (unchecked)
   - Blocked / needs human
   - Color tags if present (call out meaning)
3. **Writes** — only after explicit approval unless user sent `!auto` and task is non-destructive draft comment.

## Output format

```
## Notion: <title>
- Сделано: N
- Открыто: M
- Блокеры: …

### Открытые
- [ ] …

### Сделано
- [x] …
```

## Cross-links

- Workspace skill: `skills/notion-workspace/SKILL.md`
- Rule: `rules/notion-workspace.mdc`
- Coach publish: `commands/prompt-lesson-notion.ps1`
