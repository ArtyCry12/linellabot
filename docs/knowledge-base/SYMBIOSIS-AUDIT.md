# Symbiosis audit (REQ-078)

How hub layers reinforce each other — **improve, don't rebuild**.

## Layer matrix

| Layer | Feeds | Fed by |
|-------|-------|--------|
| User Rules | All | — |
| 00-orchestrator | MCP/skill pick | SYSTEM-REGISTRY |
| auto-orchestrator | Task route | Taxonomy, P2 repos KB |
| Skills | Execution | Rules, MCP |
| MCP | Tools | mcp.json |
| Squad (10) | Delivery | subagent-guardrails, handoff template |
| ai-tracking | Memory | squad-memory, prompt-lessons |
| Notion | User visibility | notion-workspace |
| seo-geo | Marketing quality | SEO-STACK, PageSpeed |
| design-stack | UI | 21st, context7, iconify |
| production-studio | Video | magnific, OMNI architecture |

## Friction removed in P2

- Missing `seo-geo.mdc` → added
- Subagent anti-patterns → `subagent-guardrails.mdc`
- P2 repos → `P2-REPOS.md`
- Design deps scattered → `DESIGN-STACK-MANIFEST.md`
- Prompt learning → `PROMPT-HOOKS.md` + lessons dir

## Intentional deferrals (not gaps)

| Item | Why |
|------|-----|
| Full Google Trio | GOOGLE-STACK-LITE — user impact for OAuth |
| GSC auto (REQ-020) | Same |
| Skills mass delete | REQ-025 manifest first — avoid breaking refs |
| P3 Production Studio LVM | Phase boundary |

## Health score (subjective)

| Area | P2 end state |
|------|----------------|
| Routing | Strong |
| MCP config | Strong |
| Knowledge base | Good |
| Skills hygiene | Fair — cleanup manifest ready |
| Notion ops | Good — UX doc; live DB optional |
| SEO CLI | Good — npx-based |

*2026-07-10*
