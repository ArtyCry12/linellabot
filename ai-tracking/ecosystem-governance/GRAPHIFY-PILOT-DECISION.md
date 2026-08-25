# Graphify pilot decision

**Date:** 2026-08-25  
**Verdict:** **REFUSE narrow pilot for now** (Architect).

## Why

Boss allowed pilot only if it improves governance/registry/router without architectural junk.

| Need | GitNexus + Registry | Graphify pilot |
|------|---------------------|----------------|
| Customize entity tiers / quarantine | Registry JSON owns this | Would duplicate |
| Code impact / rename gates | GitNexus required by AGENTS.md | Not a replacement |
| Extra disk graph + skill noise | — | Adds graphify-out + second query model |
| Token win for hub governance | Low — registry is tiny | Marginal on narrow tree |

## Keep

- `skills/graphify` remains on disk as EXPERIMENTAL (not quarantined).
- Research note: `GRAPHIFY-RESEARCH.md` still valid.
- Revisit pilot after Registry has ≥1 month of live updates **or** if Boss needs docs/media graph for a specific project (run Graphify **in that project**, not hub).

## Decision log

`DEC: graphify-hub-pilot-refused-2026-08-25`
