# Notion video pipeline — pass status

**Date:** 2026-08-25  
**Parent:** https://app.notion.com/p/3966689eb5b880aa8e8ff0ae02b0f77a  
**Title:** Идеи из соц сетей — ссылки на видео

## Done

| Step | Status |
|------|--------|
| Fetch parent + 55 children via Notion MCP | **DONE** |
| Inventory JSON/MD/INDEX | **DONE** → `notion-ideas/` |
| Platform split | IG 51 · TikTok 3 · other 1 |

## Video → brief (content extraction)

Remote crawl (Exa) of TikTok/Instagram **timed out / blocked** (login walls, short-link redirects). Local Whisper script (`commands/transcribe-video.ps1`) expects a **downloaded file**, not a URL.

### Delivered now

- Full link catalog (machine + human tables)
- Brief **stubs** for named pages + TikTok/other (see `BRIEFS-QUEUE.md`) — schema ready; fill when media is downloaded or captions available

### Resume for deep briefs

1. Download reel locally (or paste caption text into Notion child)
2. `powershell -File commands/transcribe-video.ps1 -VideoPath <file> -OutDir ai-tracking/ecosystem-governance/notion-ideas/transcripts`
3. Fill brief fields: summary → core idea → mechanism → hook → implementation → source → relevance → adaptation

## Residual

**Automated speech/caption extraction for all 55 URLs** — not completed (platform anti-bot). Inventory + queue = governance-complete pass for this wave; content briefs need local media or Boss pastes.
