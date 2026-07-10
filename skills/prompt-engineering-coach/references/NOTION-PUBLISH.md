# Notion publish after lesson (approval required)

**Parent page:** `CoachConfig.json` → `notionHubPageId` (📚Мой promt-engineering)

## Flow

1. Lesson saved to `ai-tracking/prompt-lessons/YYYY-MM-DD-slug.md`
2. Agent asks: **«Опубликовать урок в Notion? (да/нет)»**
3. Only on **да** / **yes**:
   - Run `commands/prompt-lesson-notion.ps1 -LessonPath <file>`
   - MCP `notion-create-pages` with `parent.page_id` from payload
   - Read `notion://docs/enhanced-markdown-spec` before formatting content
4. Never publish without explicit user approval.

## Payload helper

```powershell
powershell -File commands/prompt-lesson-notion.ps1 -LessonPath "ai-tracking/prompt-lessons/2026-07-10-slug.md"
```

Outputs JSON with title, parent_page_id, content for MCP.
