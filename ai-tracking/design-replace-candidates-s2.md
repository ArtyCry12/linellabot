# Design skills — replace candidates (list only · Session 2)

Policy: Design is the most replace-eligible domain. No installs in this pass — wait for explicit Да.

Liquidity from [skills.sh](https://www.skills.sh/) (Jul 2026 probes + leaderboard).

## Keep for now (wired sacred-adjacent)

| Hub skill | Role |
|-----------|------|
| frontend-design (Anthropic bridge) | Web anti-slop gate |
| design-stack | shadcn/tailwind/CRO |
| huashu-design | Deck / HTML / PPTX / motion HTML |
| 21st-design | 21st Magic registry |
| clone-website | Site clone |
| ui-ux-pro-max | UX checklist |
| awesome-design-md | DESIGN.md |

## Suboptimal / gap vs catalog

| Hub pain | Better candidate (skills.sh) | Installs (approx) | Suggested install cmd |
|----------|------------------------------|-------------------|------------------------|
| No Vercel web guidelines skill | `vercel-labs/agent-skills@web-design-guidelines` | **466K** | `npx skills add vercel-labs/agent-skills -s web-design-guidelines` |
| shadcn not first-class skill | `shadcn/ui@shadcn` | **237K** | `npx skills add shadcn/ui -s shadcn` |
| Stitch skill missing (MCP only) | `google-labs-code/stitch-skills@shadcn-ui` | **45K** | `npx skills add google-labs-code/stitch-skills -s shadcn-ui` |
| Taste / anti-slop depth | `leonxlnx/taste-skill@design-taste-frontend` or `high-end-visual-design` | **200K+** (leaderboard) | `npx skills add leonxlnx/taste-skill -s design-taste-frontend` |
| Impeccable polish suite | `pbakaus/impeccable` (polish/critique/…) | **~195K** | `npx skills add pbakaus/impeccable` |
| remotion duplicate of production-studio | Consider `remotion-dev/skills@remotion-best-practices` (428K) **or** archive remotion skill later | 428K | Optional later |
| Low-signal frontend-design forks | Avoid nexu-io forks unless Anthropic skill drifts | 1–3K | Skip |

## Integration plan (when you say Да)

1. Install only approved rows via `npx skills add … -g -y`.
2. Hub wrapper under `skills/<name>/SKILL.md` (thin) OR rely on `.agents/skills` + route.
3. Add/adjust `routes.json` keywords; do **not** remove huashu/frontend-design until smoke test.
4. Update `squad-design.md` matrix (routing only; models untouched).
5. Run `find-skills-test` + design route samples.

## Not installing now

Await: AskQuestion with selected IDs from the table above.
