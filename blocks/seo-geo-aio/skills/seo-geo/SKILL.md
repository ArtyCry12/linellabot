---
name: seo-geo
description: >-
  SEO and GEO (Generative Engine Optimization) skill pack — 20 specialist skills
  for keyword research, content, audits, technical SEO, monitoring, and CORE-EEAT/CITE
  quality gates. Use for @seo-geo, SEO audit, keyword research, meta tags, schema
  markup, SERP analysis, content gap, rank tracking, backlinks, GEO visibility,
  EEAT, AI search optimization, or /aaron:auto-style workflows in Cursor.
argument-hint: "[goal e.g. audit URL | keyword research for topic | write SEO article]"
user-invocable: true
---

# SEO & GEO Skills (Cursor)

Aaron He Zhu's **seo-geo-claude-skills** pack (v9.9.9, Apache-2.0) — 20 skills, shared handoff contract, zero required integrations.

| Resource | Path |
|----------|------|
| Skill root | `C:/Users/Asus/.cursor/skills/seo-geo/` |
| Full library (skills, commands, references) | `.../library/` |
| Skill index (routing) | [skill-index.md](skill-index.md) |
| Source zip | `C:/Users/Asus/.cursor/skills-libraries/seo-geo-claude-skills-main ( SEO optimiz ).zip` |
| Bootstrap project memory | `node C:/Users/Asus/.cursor/skills/seo-geo/scripts/init-seo-geo-memory.mjs .` |
| Install flat sub-skills for Cursor | `node C:/Users/Asus/.cursor/skills/seo-geo/scripts/link-subskills.mjs` |

## Where work happens

- **Deliverables** (audits, briefs, drafts, reports) belong in the **user's project** (workspace), not inside this skill folder.
- **Project memory** (optional): `memory/hot-cache.md`, `memory/research/`, `memory/wiki/` — create with the init script when running multi-session SEO campaigns.

## Cursor invocation

| User says | You do |
|-----------|--------|
| `@seo-geo` + goal | Route via [skill-index.md](skill-index.md); load the matching `library/<phase>/<skill>/SKILL.md` |
| `@seo-geo keyword-research …` | Read `library/research/keyword-research/SKILL.md` and execute |
| Old `/seo:*` or `/aaron:*` | Map using **Command aliases** below |
| Single skill name only | Load that skill file directly from `library/` |

**Do not** improvise SEO frameworks — use the pack's CORE-EEAT (80 items) and CITE (40 items) references when auditors run.

---

## Auto-routing (replaces `/aaron:auto` in Cursor)

1. Parse the user's **goal**, **URL/topic/domain**, and **blocking inputs** (language, market, CMS).
2. Pick the **smallest skill chain** that completes the outcome (see [skill-index.md](skill-index.md)).
3. If the goal is ambiguous but a URL/topic exists → lightweight triage: `on-page-seo-auditor` or `keyword-research` before deeper chains.
4. If no actionable object → ask **one** concise blocking question.
5. Default depth: one expert skill; chain only when the user asks for end-to-end workflow.
6. **Pack boundary**: decline non-SEO/GEO coding tasks unless the user explicitly wants SEO impact on code (then `technical-seo-checker` / schema only).

### Recommended chains

| Workflow | Skill order |
|----------|-------------|
| New content | `keyword-research` → `content-gap-analysis` → `seo-content-writer` → `geo-content-optimizer` → `meta-tags-optimizer` → `content-quality-auditor` |
| Publish gate | `content-quality-auditor` → `on-page-seo-auditor` → `schema-markup-generator` |
| Trust review | `content-quality-auditor` + `domain-authority-auditor` (120-item) |
| Declining traffic | `performance-reporter` → `content-refresher` → re-audit |
| Technical health | `technical-seo-checker` → `internal-linking-optimizer` |
| GEO visibility | `geo-content-optimizer` → `entity-optimizer` → `serp-analysis` (AI Overviews) |

---

## Command aliases (Claude Code → Cursor)

When the user mentions these slash commands, run the equivalent skill chain:

| Command | Cursor equivalent |
|---------|-------------------|
| `/aaron:auto` | Auto-routing section above |
| `/aaron:discover` | `keyword-research`, `serp-analysis` |
| `/aaron:compete` | `competitor-analysis`, `backlink-analyzer` |
| `/aaron:map` | `content-gap-analysis`, `internal-linking-optimizer` |
| `/aaron:brief` | `keyword-research` + brief sections from `seo-content-writer` references |
| `/aaron:write` | `seo-content-writer` |
| `/aaron:refresh` | `content-refresher` |
| `/aaron:publish` | `meta-tags-optimizer`, `schema-markup-generator` |
| `/aaron:audit` | `on-page-seo-auditor`, `content-quality-auditor` |
| `/aaron:visibility` | `geo-content-optimizer`, `serp-analysis` |
| `/aaron:tech` | `technical-seo-checker` |
| `/aaron:authority` | `domain-authority-auditor`, `entity-optimizer` |
| `/aaron:watch` | `rank-tracker`, `alert-manager` |
| `/aaron:report` | `performance-reporter` |
| `/aaron:remember` | `memory-management` |

Command source files: `library/commands/*.md` (full rules, gates, wiki routing).

---

## Loading a sub-skill

1. Resolve skill name from [skill-index.md](skill-index.md).
2. **Read** `library/<category>/<skill-name>/SKILL.md` in full (frontmatter + contract sections).
3. Follow its **Instructions**; pull `references/` only when the skill points there.
4. End with **Handoff Summary** fields: objective, findings, evidence, open loops, keyword, content type, status, CORE-EEAT/CITE scores, priority IDs, URL.
5. Suggest **Next Best Skill** from that file's footer.

### Protocol-layer skills (run when triggered)

| Skill | Role |
|-------|------|
| `content-quality-auditor` | CORE-EEAT publish gate (veto: T04, C01, R10) |
| `domain-authority-auditor` | CITE trust gate (veto: T03, T05, T09) |
| `entity-optimizer` | Canonical entity / Knowledge Graph signals |
| `memory-management` | HOT/WARM/COLD project memory + wiki |

Shared refs: `library/references/skill-contract.md`, `state-model.md`, `core-eeat-benchmark.md`, `cite-domain-rating.md`.

---

## Data tiers (no tools required)

| Tier | Meaning |
|------|---------|
| 1 | User-provided URLs, exports, copy, Search Console screenshots |
| 2 | MCP / API connectors (`library/CONNECTORS.md`, `~~category` placeholders) |
| 3 | Live fetch via browser or `user-fetch` when allowed |

Never invent rankings, volumes, or backlinks — label estimates and ask for exports when data is missing.

---

## Parallel work (Cursor Task tool)

Independent research tasks (`keyword-research`, `competitor-analysis`, `serp-analysis`) may run as parallel `generalPurpose` subagents; merge handoffs before `seo-content-writer` or auditors.

---

## Updating the library

Replace `library/` from the zip or:

```bash
npx skills add aaron-he-zhu/seo-geo-claude-skills
```

Then re-copy into `C:/Users/Asus/.cursor/skills/seo-geo/library/` or re-run `link-subskills.mjs`.

## License

Apache-2.0 — [library/LICENSE](library/LICENSE). Author: [Aaron He Zhu](https://github.com/aaron-he-zhu/seo-geo-claude-skills).
