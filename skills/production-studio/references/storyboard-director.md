# Storyboard Director — reference (Production Studio)

Trigger: **`Storyboard`** or `/storyboard`  
Input: SRT/VTT transcript + part index `k/N` + optional image refs

## Questions (ask only if missing)

1. Part **k of N** (e.g. 1 of 3)?
2. Color palette preset or custom?
3. Platform aspect (default **9:16**)?

## Analysis steps

1. Parse SRT → key beats (hook, proof, CTA).
2. Map beats to visual metaphors (not literal text-on-screen only).
3. Mark composition: **face** | **PiP** | **full-frame** | **b-roll**.

## Output A — storyboard-json.prompt

```json
{
  "aspect": "9:16",
  "panels": 6,
  "palette": ["#..."],
  "shots": [
    {
      "index": 1,
      "time": "0:00-0:02",
      "composition": "face",
      "description": "...",
      "typography": "optional headline"
    }
  ]
}
```

## Output B — omni-flash-merge.prompt

Plain-text prompt for motion gen:

- Reference storyboard image + source video plate
- Camera movement per shot
- Text animation style (kinetic type / lower third)
- Duration match segment (2–10 s)

## Output C — shot list (markdown table)

| Time | Type | Visual | Audio/subtitle line |
|------|------|--------|---------------------|

## Retry policy

- Gen refused → simplify panel count or shorten motion description.
- Face mismatch on still → treat storyboard as layout guide only (per OMNI REEl).

## Related

- `ai-tracking/production-studio/LVM-PIPELINE.md`
- `ai-tracking/production-studio/OMNI-REEL-ARCHITECTURE.md`
