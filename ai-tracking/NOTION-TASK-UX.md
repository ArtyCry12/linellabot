# Notion task UX (REQ-027–029, 041)

**Skill:** `skills/notion-workspace/SKILL.md`  
**Prompt hub:** [📚Мой promt-engineering](https://app.notion.com/p/3966689eb5b880f68f77dbfba5efeed2)  
**Mega-prompt source:** [⚒️Cursor – промты](https://app.notion.com/p/3966689eb5b880ab88eded5a43eabd5d)

---

## Status emojis (REQ-027)

Apply in page title prefix or inline checklist:

| Status | Prefix |
|--------|--------|
| Not started | ⬜ |
| In progress | 🟡 |
| Done | ✅ |
| Blocked | 🔴 |

**Agent:** On task completion, suggest title update via `notion-update-page` (user approval for bulk).

---

## Daily use (REQ-028)

Recommended Notion views for Cursor work:

1. **Inbox** — new prompts user pastes (REQ-041: user inserts text)
2. **Active** — 🟡 only
3. **Done this week** — ✅ filter

Fonts/formatting: keep user's Notion theme; agent does not restyle without ask.

---

## Session comments (REQ-029)

After substantive session, agent may add comment (plain Russian):

```
🟡 Остановились: ...
🔴 Мешает: ...
➡️ Следующий шаг: ...
```

---

## Task visibility (REQ-041)

| Source | Visibility |
|--------|------------|
| User prompt in Notion | User pastes → agent reads via MCP |
| REQ registry | `ai-tracking/REQ-REGISTRY-NOTION.md` (hub SSOT) |
| Execution | `NOTION-EXECUTION-STATUS.md` |

Optional: duplicate high-level status to Notion page via MCP when user says «обнови статус в Notion».

---

## Boundaries (REQ-039–040)

- Ask before move/delete/reparent
- T3 cleanup only — see skill contract
- No inventing requirements from Notion pages

*P2 · 2026-07-10*
