# DEC-056 — Unified Production Studio (live-action + AI)

**Status:** Accepted  
**Date:** 2026-07-10  
**REQ:** 056

## Context

REQ-056 asks whether live-action marketing shoots and AI/LVM video should be separate systems or one.

## Decision

**Unify at this stage** under `skills/production-studio` + `ai-tracking/production-studio/`, with **three logical modules** that can split later without rewriting the core pipeline.

```
production-studio/
├── modules/shared/      ← script, segments, storyboard, assembly, QC
├── modules/ai-lvm/      ← gen prompts, Magnificent, Veo/Kling/Seedance
└── modules/live-action/ ← shoot briefs, talent, B-roll, on-set notes
```

## Rationale

| Factor | Unified now | Split later if |
|--------|-------------|----------------|
| Same script → segment → storyboard flow | ✓ | Live team uses only `live-action` skill |
| Same viral refs vault (REF-16/17 + AI refs) | ✓ | Dedicated live-only refs folder |
| Same QC gate (human approve before publish) | ✓ | Different QC rubrics per medium |
| User workflow | One `@production-studio` entry | Agency hires live-only editor |

## Separation hooks (foundation)

| Hook | Location | Future split |
|------|----------|--------------|
| `track` field on segments | `segment-manifest.json` | `ai` \| `live` \| `hybrid` |
| Module READMEs | `modules/*/README.md` | Each → standalone skill |
| REF routing | REF-01–15 AI-leaning · REF-16–18 live | Filter by tag in INDEX |
| Commands | `/storyboard` shared · `/live-shoot` optional later | New slash without moving shared |

## Consequences

- **Positive:** One playbook, one manual test path, less duplication.
- **Positive:** Hybrid reels (talking head + AI B-roll) are first-class.
- **Trade-off:** Skill file grows — detail lives in `references/` and `modules/`.
- **Future:** If live-only volume dominates → extract `skills/live-production/` copying `modules/live-action/` + shared contract.

## Related

- `ai-tracking/production-studio/ARCHITECTURE.md`
- `templates/production-studio/segment-manifest.json`
- REF-16, REF-17 in refs vault
