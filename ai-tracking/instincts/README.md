# ECC instincts — hot cache for session inject (≤6, confidence ≥0.7)

Instincts are learned patterns from ECC harness. Hooks inject top items into context.

## Format (`*.json`)

```json
{
  "id": "research-before-build",
  "confidence": 0.85,
  "text": "Run dev-os research before multi-file implementation.",
  "source": "ecc-harness",
  "updatedAt": "2026-07-13T00:00:00Z"
}
```

## Defaults (seed)

See `seed-instincts.json` in this folder.

## Injection

- Hook: `hooks/ecc-instincts.ps1` (optional, on-demand via ensure-ecc)
- Cap: 6 instincts, min confidence 0.7
- Policy: `docs/knowledge-base/TOKEN-MEMORY-POLICY.md`
