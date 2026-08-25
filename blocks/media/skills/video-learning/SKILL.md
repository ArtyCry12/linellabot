---
name: video-learning
description: >-
  Use when the user shares YouTube, Reels, TikTok, or Shorts URL and wants a
  transcript-based summary or lesson. Flow: URL → transcript (fetch/Exa) →
  MarkItDown if attachment → summary → ai-tracking/learning/ + optional Notion.
  Triggers: youtube, reels, видео, транскрипт, разбери видео.
argument-hint: "<video-url> [--notion]"
user-invocable: true
---

# Video learning pipeline

## Flow

1. **Detect URL** — YouTube, youtu.be, tiktok, instagram reels, shorts.
2. **Transcript**
   - Primary: Exa `web_fetch_exa` or `user-fetch` for page metadata
   - YouTube: captions via fetch; if blocked → Exa search for transcript mirrors
3. **Normalize** — MarkItDown hook/MCP for attachments; trim to token budget.
4. **Summarize** (plain Russian, humanizer):
   - 5–8 bullet takeaways
   - Action items for agency work
   - Glossary if jargon-heavy
5. **Persist** — `ai-tracking/learning/YYYY-MM-DD-<slug>.md`
6. **Optional Notion** — draft lesson; ask unless `!auto`

## Output template

```markdown
# Видео: <title>
**URL:** …
**Дата:** …

## Главное
- …

## Действия
- …

## Термины
- …
```

## MCP

| Step | Server |
|------|--------|
| Research | `plugin-exa-exa` |
| Single URL | `user-fetch` |
| File convert | `markitdown-mcp` (always-on) |

## Commands

- `commands/ensure-markitdown.ps1`
- `commands/prompt-lesson-notion.ps1` (optional publish)
