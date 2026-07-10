# Production Studio

**Slash:** `/production-studio` · **Skill:** `skills/production-studio/SKILL.md`

Task: **$ARGUMENTS**

---

## Router

| User intent | Route |
|-------------|-------|
| storyboard, раскадровка | `/storyboard` + storyboard-director |
| script, сценарий | refs vault REF-* or USER-* |
| segment split | `references/segment-splitter.md` → manifest |
| live shoot | `references/live-action-module.md` + live-shoot-brief template |
| style | `references/style-lock.md` |
| full pipeline | `ai-tracking/production-studio/LVM-PIPELINE.md` |
| manual test | `ai-tracking/P3-MANUAL-TEST-PLAYBOOK.md` §2 |

## Architecture

Unified **live + AI** (DEC-056): `ai-tracking/production-studio/ARCHITECTURE.md`

## Modules

- `modules/shared` — script, segments, QC
- `modules/ai-lvm` — Magnificent, Veo, prompts
- `modules/live-action` — shoot briefs, REF-16–18

## New project

1. Copy `templates/production-studio/project-brief.md` to user project folder.
2. Fill brief → segment-manifest → storyboard → gen/QC.

Do not commit user media or gen outputs into hub git.
