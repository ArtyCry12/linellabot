---
name: notion-workspace
description: >-
  Notion MCP workspace ops — read structure, light T3 cleanup (preserve user
  wording), task colors/emojis by status, session handoff notes. Use when user
  shares Notion URLs or asks to organize Cursor prompts in Notion.
argument-hint: "[fetch page | T3 cleanup | task status update]"
user-invocable: true
---

# Notion Workspace Skill

**MCP:** `notion` → https://mcp.notion.com/mcp (OAuth)

## T3 cleanup contract (user-defined)

- **Do not** heavy refactor user text
- Fix typos, spacing, headings only
- Turn chaos → readable plan **without inventing** new requirements
- Preserve original intent and attachments

## Task markers

| Status | Emoji | Color hint |
|--------|-------|------------|
| Not started | ⬜ | gray |
| In progress | 🟡 | yellow |
| Done | ✅ | green |
| Blocked | 🔴 | red |

## Session handoff (for user)

After substantive work, optional Notion comment (see `ai-tracking/NOTION-TASK-UX.md`):
- Where we stopped
- What blocks next step
- Plain language, no AI slop

## Hub cross-links

- Task UX: `ai-tracking/NOTION-TASK-UX.md`
- REQ status: `ai-tracking/NOTION-EXECUTION-STATUS.md`
- Prompt lessons: `ai-tracking/prompt-lessons/`

## Boundaries

- Respect user's Notion hierarchy — ask before moving pages
- Prompts inserted by user — agent reads via MCP, does not overwrite without approval
