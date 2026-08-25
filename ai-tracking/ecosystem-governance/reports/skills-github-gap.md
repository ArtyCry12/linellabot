# Dual research — skills.sh + GitHub (2026-08-25)

Channels: [skills.sh](https://www.skills.sh/) leaderboard + [VoltAgent/awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills) (scan-list, **not** cloned).

Criteria: installs / stars-as-filter / portable SKILL.md / clear win / cherry-pick 1–several / no monorepo clone. Target: `hub` or `blocks/<id>`.

**Installs 2026-08-25 (Boss Да):** A+B → `blocks/design` (not hub). C → `blocks/seo-geo-aio` cherry-pick `web-quality-audit` only (not the 6-skill monorepo). Removed `.agents` copies after move.

## Overlap (already in hub or blocks)

| Candidate | Channel | Overlap | Target if new | Verdict |
|-----------|---------|---------|---------------|---------|
| find-skills | skills.sh | `skills/find-skills` | — | SKIP |
| frontend-design | skills.sh / Anthropic | `skills/frontend-design` | hub | SKIP |
| caveman | skills.sh | `skills/caveman` | hub | SKIP |
| web-design-guidelines | skills.sh | `skills/web-design-guidelines` | hub | SKIP |
| ui-ux-pro-max | skills.sh | `blocks/design/skills/ui-ux-pro-max` | design | SKIP |
| impeccable | skills.sh | `blocks/design/skills/impeccable` | design | SKIP |
| design-taste-frontend | skills.sh | `blocks/design/skills/design-taste-frontend` | design | SKIP |
| shadcn | skills.sh | `skills/shadcn` | hub | SKIP |
| remotion / remotion-best-practices | skills.sh / awesome Remotion team | `blocks/media/skills/remotion` (+ OD repo nested) | media | SKIP (canon already media) |
| copywriting / content-strategy / marketing-psychology | skills.sh | `blocks/agency/...` | agency | SKIP |
| seo-audit | skills.sh | `blocks/seo-geo-aio/skills/seo-audit` | seo-geo-aio | SKIP |
| playwright-cli / webapp-testing | skills.sh / Anthropic | `blocks/qa/skills/playwright` | qa | SKIP |
| supabase / supabase-postgres-best-practices | skills.sh / awesome | MCP plugin + no dedicated skill | integrations | SKIP this wave (no live Supabase projects in MCP) |
| sentry-cli / Sentry team skills | skills.sh / awesome | Cursor **plugin** org nlmedia | security | SKIP (lock: plugin only) |
| Stitch / Figma | awesome | design profile MCP | design | SKIP |
| Trail of Bits security | awesome | `blocks/security/skills/cybersecurity/library` | security | SKIP (library already) |
| Notion team skills | awesome | `blocks/integrations/skills/notion-*` | integrations | SKIP |
| Resend skills | awesome | Resend MCP plugin | integrations | SKIP this wave |
| grill-me / tdd / writing-plans / verification-before-completion / mattpocock | skills.sh | `skills/_quarantine/` | — | SKIP (quarantine canon) |
| graphify | hub disk | `skills/graphify` | hub | SKIP (pilot refused) |
| Azure / Lark / TestMu suites | skills.sh / awesome | none | — | SKIP (wrong stack / monorepo) |
| VoltAgent framework skills | awesome | none | hub | SKIP (not this hub’s runtime) |

## Ask-once shortlist (not installed)

Install **only** if Boss replies **Да** to an id. `npx skills add` must land in the **target**, not orphan `skills/<name>/` and not only `~/.agents`.

| id | Candidate | Channel | Why | Target | Verdict |
|----|-----------|---------|-----|--------|---------|
| A | `vercel-react-best-practices` | skills.sh | React perf; Boss: block not hub | `blocks/design` | INSTALLED |
| B | `vercel-composition-patterns` | skills.sh | composition; Boss: block not hub | `blocks/design` | INSTALLED |
| C | `web-quality-audit` (Addy Osmani) | awesome-agent-skills | Lighthouse/web quality; cherry-pick 1 of 6 | `blocks/seo-geo-aio` | INSTALLED |

Do **not** install Sentry skills, Remotion duplicates, or Azure/Lark suites.

## Mapping rule used

- Coding UI (`shadcn`, `frontend-design`, Vercel React) → **hub**
- Remotion → **media** only
- SEO/CWV → **seo-geo-aio**
- Security auditors / Sentry plugin → **security** (no extra Sentry skill)
