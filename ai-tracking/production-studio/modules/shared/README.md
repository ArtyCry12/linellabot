# Module: shared

**Owns:** Script, segment manifest, storyboard, SRT, QC, assembly notes.

## Inputs
- `templates/production-studio/project-brief.md`
- REF-* or USER-* script
- Optional SRT from `transcribe-video.ps1`

## Outputs
- `segment-manifest.json` (filled)
- `storyboard-table.md`
- `qc-gate.md` signed off

## Split boundary
If extracting later: this module becomes `skills/production-core` — ai-lvm and live-action depend on it.
