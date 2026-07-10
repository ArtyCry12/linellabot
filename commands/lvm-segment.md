# LVM segment assembly (REQ-031)

Task: **$ARGUMENTS**

---

## Goal

Produce **one segment** ready for gen or shoot — not full reel export.

## Steps

1. Read `templates/production-studio/segment-manifest.json` schema.
2. Apply `references/segment-splitter.md` for duration.
3. Set `track`: ai | live | hybrid per DEC-056.
4. If **ai/hybrid** — emit Prompt A + B per `storyboard-director.md`.
5. If **live/hybrid** — fill `live-shoot-brief.md` sections for this segment only.
6. Output paths for user project folder (not hub git).

## Assembly note

DaVinci/CapCut merge is manual; document order in `qc-gate.md`.

## MCP

- Magnificent / gemini for ai track
- No auto-spend >3 segments without note in output
