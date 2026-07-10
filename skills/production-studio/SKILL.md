---
name: production-studio
description: >-
  Unified Production Studio — live-action + AI/LVM video, storyboards, viral
  scripts, segment splits. DEC-056 unified with splittable modules. Triggers
  production studio, storyboard, раскадровка, live shoot, hybrid reel, LVM,
  reels, tiktok, монтаж 15-30s.
argument-hint: "[brief | script | storyboard | live-shoot | segment-split]"
user-invocable: true
---

# Production Studio (Cursor Hub)

**REQ:** 049–057, 065 · **DEC-056:** live + AI unified · **Manual test:** `ai-tracking/P3-MANUAL-TEST-PLAYBOOK.md`

## Architecture

```
modules/shared     → script, segments, storyboard, QC
modules/ai-lvm     → prompts, Magnificent, Veo/Kling
modules/live-action → shoot briefs, REF-16–18
```

Full map: `ai-tracking/production-studio/ARCHITECTURE.md`

## Segment prompt formula (AI)

`[Тип/Стиль] + [Объект и действие] + [Окружение] + [Свет/ракурс] + [Параметры/текст]`

## Chunk durations (REQ-057)

2 / 4 / 6 / 8 / 10 s — one duration per project. See `references/segment-splitter.md`.

## Track per segment

`ai` | `live` | `hybrid` — in `templates/production-studio/segment-manifest.json`

## Workflow

```
Brief → Style lock → Script (refs) → Segment manifest → Storyboard → Gen/shoot → QC → Assembly
```

## Slash & references

| Task | Route |
|------|-------|
| Storyboard | `/storyboard` · `references/storyboard-director.md` |
| Style | `references/style-lock.md` |
| Live shoot | `references/live-action-module.md` |
| Pipeline | `ai-tracking/production-studio/LVM-PIPELINE.md` |
| Templates | `templates/production-studio/` |
| Transcribe | `commands/transcribe-video.ps1` |
| Media refs | `references/media-conversion.md` |
| LVM segment | `/lvm-segment` |

## MCP

| Task | Route |
|------|-------|
| Video prompts | Magnificent MCP |
| Motion | gemini / browser |
| Research | Exa on demand |

## Refs vault

18 × `ai-tracking/production-studio/refs/REF-*.md` — USER-*.md overrides.

## Out of scope

- Auto-publish social without approval
- Hub git for user media / renders
