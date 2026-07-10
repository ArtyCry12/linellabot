# Agency Portfolio Map — agency-agents → Project Squad

**Source:** [msitarzewski/agency-agents](https://github.com/msitarzewski/agency-agents) (232 agents, 16 divisions).  
**Hub policy (DEC-004):** Squad stays **10 agents**. Agency agents are **borrowed specialists**, not roster replacements.

## When to spawn agency vs squad

| Need | Use |
|------|-----|
| Full project cycle in one workspace | **Squad** (`squad-*`) |
| Deep persona for one deliverable | **Agency** (1–2 agents) |
| Hub / system maintenance | `squad-cleanup` + `dev-os` |
| Research / bootstrap | `dev-os-research` |

## Division → Squad mapping

| Agency division | Squad lead | Example agency agents | Spawn hint |
|-----------------|------------|-------------------------|------------|
| Engineering | `squad-build` | Frontend Developer, Backend Architect, DevOps Automator | After architect plan approved |
| Design | `squad-design` | UI Designer, Whimsy Injector, Brand Guardian | Parallel with scout (read-only) |
| Marketing | `squad-growth` | Content Strategist, Reddit Community Builder, SEO Specialist | SEO/launch phases |
| Paid Media | `squad-growth` | PPC Strategist, Analytics Interpreter | Paid campaign tasks |
| Sales | Boss + growth | Sales Engineer, Discovery Call Analyst | B2B proposals |
| Product | `squad-architect` | Product Manager, UX Researcher | Discovery / PRD |
| Project Management | Boss | Sprint Coordinator, Studio Producer | Multi-week engagements |
| Testing | `squad-qa` | Evidence Collector, API Tester | QA phase |
| Security | cybersecurity skill | Security Engineer, Compliance Auditor | Before ship |
| Support | `squad-build` | Support Responder, Docs Maintainer | Post-launch |
| Finance | Boss (verify math) | Financial Analyst | Pricing models — **always double-check numbers** |
| Strategy | `dev-os-research` | Business Analyst, Competitive Intel | B2B discovery |
| Specialized | context-specific | AI Engineer, Legal Reviewer | Ad hoc |
| Game / Academic / GIS | — | Use game-studios-multiagent template | Separate vertical |

## Install to Cursor (recommended subsets for AI agency)

```powershell
# Marketing + sales + design — typical agency stack
./scripts/install.sh --tool cursor --division marketing,sales,design,product
```

## Spawn template (Boss)

```
Read agency agent: C:\Users\Asus\projects\agency-agents\marketing\marketing-content-strategist.md
Activate that persona for this task only. Deliverable: <X>. No hub file edits unless asked.
Model: Sonnet. Token budget: medium.
```

## Personality patterns worth copying into Squad briefs

1. **Deliverable-first** — concrete outputs, not advice dumps (agency philosophy §814)
2. **Success metrics** — define before work (Karpathy goal-driven + agency metrics)
3. **Evidence** — Testing division "3–5 issues + visual proof" → `squad-qa`
4. **Community voice** — Reddit agent → human tone for `squad-growth` social copy

## Token guardrails

- Max **2** agency personas active per session
- Load **one** agent `.md` file per spawn — never entire division
- Agency file paths live under `C:\Users\Asus\projects\agency-agents\` (not in hub git)
