---
name: agency-agents
description: >-
  The Agency (msitarzewski/agency-agents) — 66+ hub-integrated marketing, sales,
  design, product, and paid-media personas as on-demand Cursor rules. Use for
  @agency, agency agent, content strategist, sales discovery, PPC, brand voice,
  proposal copy, or when Squad needs a deep specialist persona. Max 2 personas
  per session. Rules live in rules/agency/*.mdc.
argument-hint: "[persona e.g. content-creator | sales-engineer | ui-designer]"
user-invocable: true
---

# Agency Agents (Cursor Hub)

**Source:** `C:\Users\Asus\projects\agency-agents` (git clone)  
**Installed rules:** `rules/agency/*.mdc` (66 agents — marketing, sales, design, product, paid-media)  
**Refresh:** `commands/install-agency-agents.ps1`

## When to use

| User intent | Agency rule (reference in prompt) |
|-------------|-----------------------------------|
| Landing / blog / social copy | `@content-creator` or `@seo-specialist` |
| B2B proposal / discovery | `@sales-engineer` or `@proposal-strategist` |
| UI critique / brand | `@ui-designer` or `@brand-guardian` |
| Paid ads / PPC | `@ppc-strategist` or `@paid-social-strategist` |
| Product PRD / prioritization | `@product-manager` |
| Reddit / LinkedIn voice | `@reddit-community-builder` or `@linkedin-content-creator` |

Full index: `rules/agency/_INDEX.md`

## How to activate

1. **@ mention** in Cursor chat: `@content-creator Write hero copy for …`
2. **Boss spawn:** read one `rules/agency/<slug>.mdc` when Task needs persona depth
3. **Squad handoff:** `squad-growth` may delegate to `@seo-specialist`; `squad-design` to `@ui-designer`

## Token rules (mandatory)

- **Max 2** agency personas per session
- Load **one** `.mdc` at a time — never list entire `rules/agency/`
- Prefer Squad for execution; Agency for **voice + process + deliverable shape**
- Do not set `alwaysApply: true` on agency rules

## Squad pairing

| Squad agent | Agency backup |
|-------------|---------------|
| squad-growth | content-creator, seo-specialist, growth-hacker, ai-citation-strategist |
| squad-design | ui-designer, whimsy-injector, visual-storyteller, brand-guardian |
| Boss (sales/B2B) | sales-engineer, proposal-strategist, discovery-coach |
| squad-architect | product-manager, sprint-prioritizer |

## Maintenance

```powershell
# Re-sync after upstream agency-agents pull
C:\Users\Asus\.cursor\commands\install-agency-agents.ps1 -Convert
```

Map reference: `docs/knowledge-base/AGENCY-PORTFOLIO-MAP.md`
