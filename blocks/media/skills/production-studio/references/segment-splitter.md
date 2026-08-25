# Segment splitter (REQ-057)

## Allowed durations

**2 · 4 · 6 · 8 · 10** seconds per segment — pick **one** duration per project (LVM API consistency).

## Rules

1. **Never cut mid-sentence** — split on breath, beat, or scene change.
2. **Hook segment** ≤ first 2s of content (can be 2s segment alone).
3. **CTA segment** last — minimum 2s readable.
4. **Narrative arc** across parts: each part must end with open loop or transition word unless final part.
5. **Hybrid:** live plate length = segment duration; AI overlay prompt references same timestamps.

## Algorithm (agent)

```
1. Read full script + target total (15-30s)
2. Choose segment_duration_s (default 10 for OMNI-style)
3. parts_total = ceil(total / segment_duration_s)
4. For each part: assign track (ai|live|hybrid) from brief
5. Write segment-manifest.json
6. Validate: sum(duration) ≈ target ±2s
```

## OMNI REEl mapping

27s reel → 3×10s parts (last part may be 7s trimmed in edit) — see `OMNI-REEL-ARCHITECTURE.md`.

## Output

Update `templates/production-studio/segment-manifest.json` in project folder (not hub git).
