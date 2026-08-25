# Skills classify — dry-run

**When:** 2026-08-25T01:36:52.785Z
**Moved:** no (dry-run only)

## Counts

| Metric | N |
|--------|--:|
| Total scanned | 411 |
| Hub-top with SKILL.md | 58 |
| Quarantine candidates (hard) | 0 |
| Quarantine soft (indexed, not routed) | 4 |
| _INDEX names | 125 |
| Route skill refs | 57 |

### By tier

- **CORE**: 14
- **DEPRECATED**: 76
- **EXPERIMENTAL**: 278
- **SECONDARY**: 43

### Hub-top by tier (names)

**CORE** (14): caveman, clone-website, cybersecurity, dev-os, ecosystem-architect, find-skills, markitdown, open-design, openrouter-free, ponytail, project-squad, prompt-engineering-coach, security-hub, seo-geo

**EXPERIMENTAL** (1): graphify

**SECONDARY** (43): 21st-design, agency-agents, ai-search-optimization, awesome-design-md, awesome-prompts, brainstorming, cloudflare-security-audit, code-review-pro, content-strategy, copywriting, core-web-vitals, design-stack, design-taste-frontend, devsecops-expert, entity-seo, firebase-security-rules-auditor, frontend-design, impeccable, marketing-ideas, marketing-psychology, n8n-templates, n8n-workflow, n8n-workflow-architect, n8n-workflow-automation, notion-tasks, notion-workspace, opc-seo-geo, playwright, playwright-visual-testing, pr-review, production-studio, programmatic-seo, qa-start, remotion, repo-intake, secret-scanning, seo-audit, shadcn, site-compliance-audit, stitch-shadcn-ui, ui-ux-pro-max, video-learning, web-design-guidelines

## Quarantine candidates — hard (NOT applied)

_None — every hub-top skill is in `_INDEX` or routes or CORE._

## Quarantine soft — indexed but not in routes (NOT applied)

Candidates for Boss review. Safer first batch than touching routed skills.

| Name | Proposed dest | Why |
|------|---------------|-----|
| `awesome-design-md` | `skills/_quarantine/awesome-design-md/` | listed in skills/_INDEX.md; not referenced in routes.json — soft quarantine review |
| `n8n-templates` | `skills/_quarantine/n8n-templates/` | listed in skills/_INDEX.md; not referenced in routes.json — soft quarantine review |
| `remotion` | `skills/_quarantine/remotion/` | listed in skills/_INDEX.md; not referenced in routes.json — soft quarantine review |
| `ui-ux-pro-max` | `skills/_quarantine/ui-ux-pro-max/` | listed in skills/_INDEX.md; not referenced in routes.json — soft quarantine review |

## Already DEPRECATED on disk

`skills/_archive/` — **76** SKILL.md (leave; already out of active index).

Open Design `repo/` templates — **278** tagged EXPERIMENTAL / keep_on_disk_not_index (do not quarantine into hub trash; leave under OD).

## Next gate

Boss: **APPLY soft quarantine** (all or name list) → move into `skills/_quarantine/`.
Until then nothing is moved.
