# Module: live-action

**Owns:** Shoot briefs, shot lists, B-roll, on-set timing for real talent.

## Inputs
- Script segments with `track: live` or `hybrid`
- REF-16, REF-17, REF-18 patterns

## Outputs
- `live-shoot-brief.md` (from template)
- Shot list table in storyboard
- Assembly notes: which plates are A-roll vs B-roll

## Hybrid rule (DEC-056)
Talking-head segments stay `live`; AI-generated B-roll overlays use `track: hybrid` on the **same** segment manifest — two prompt files, one timeline row.

## Split boundary
Future `skills/live-production` — copy this folder + shared segment contract only.
