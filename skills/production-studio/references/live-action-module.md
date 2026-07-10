# Live-action module (DEC-056 / REQ-056)

Unified with AI — **not** a separate product. This reference is the live branch inside `@production-studio`.

## When to use `track: live`

- Real talent on camera (REF-16, REF-17)
- Commercial product shoot (REF-18)
- User says "съёмка", "live", "оператор", "B-roll"

## When to use `track: hybrid`

- Talking head + AI motion graphics (OMNI REEl pattern)
- Live A-roll plate + Veo/Omni B-roll overlay
- Segment has both `live_shot` and `ai_prompt_b` in manifest

## Workflow

```
Script → segment-manifest (track per row)
  → live: fill live-shoot-brief.md
  → hybrid: shoot plate + /storyboard on SRT for AI half
  → ai: skip shoot, prompts only
→ QC gate → assembly
```

## Shoot brief template

`templates/production-studio/live-shoot-brief.md`

## Split future

If `skills/live-production` extracted: keep `segment-manifest.json` schema unchanged; only routing table in INDEX filters REF-16–18.

## Director defaults (from REF-16)

- Pattern interrupt every 4–5s
- No "hi guys" opener
- Single CTA
- B-roll: hands, product, environment texture
