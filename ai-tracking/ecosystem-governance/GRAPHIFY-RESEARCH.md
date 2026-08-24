# Graphify research (governance W0/graph)

**Date:** 2026-08-24  
**Decision gate:** Boss asked to research Graphify **before** locking GitNexus+Registry hybrid.  
**Status:** research complete — **install not done** (await Architect pilot plan).

## What Graphify is

- Repo: [Graphify-Labs/graphify](https://github.com/graphify-labs/graphify) (Apache-2.0; skill `/graphify` for Cursor and many assistants).
- Builds a **queryable knowledge graph** from code + docs (+ optional PDFs/media).
- Code path: local **tree-sitter AST** (deterministic, no LLM, nothing leaves machine).
- Docs/media: optional semantic pass via assistant/API.
- Outputs typically under `graphify-out/`: `graph.json`, `GRAPH_REPORT.md`, `graph.html`.
- Also: CLI query/path/explain; optional MCP serve; pre-commit sync pattern.

Stars/marketing numbers move fast; treat stars as **filter only**, not proof of fit for this hub.

## Vs GitNexus (already in hub)

| Need | GitNexus (live) | Graphify |
|------|-----------------|----------|
| Symbol impact / rename / detect_changes | **Yes — required by AGENTS.md** | Not a drop-in replacement |
| Hub already wired (MCP, heap, ignore) | **Yes** | New install + skill + disk graph |
| Docs/PDFs/video into same graph | Weak | **Stronger** |
| Customize entities (skills↔rules↔hooks↔MCP) | Code-symbol oriented | Better if we feed governance MD/JSON as sources |
| Token savings via query-not-grep | Partial (impact/context) | Core pitch |
| Risk of dual-graph chaos | — | High if both always-on without roles |

## Fit for MASTER “ecosystem graph”

MASTER needs: entity map, quarantine moves update graph, new entities auto-register.

- **GitNexus alone:** insufficient for Customize governance entities.
- **Graphify alone:** does not replace GitNexus impact/rename gates on code.
- **Graphify on entire `~/.cursor`:** expensive/noisy (1800 skills, OD repo, plugins/cache) unless heavily excluded.
- **Ecosystem Registry JSON** (lightweight): cheapest way to track skill tiers / quarantine / MCP profiles; Architect owns updates.

## Recommendation (Architect default until Boss overrides)

1. **Keep GitNexus** as code-intelligence plane (unchanged policy).  
2. **Do not install Graphify into always-on hub MCP** in this wave.  
3. **Next step (still governance):** Architect maintains `ai-tracking/ecosystem-governance/registry.json` (entities + tier + status).  
4. **Optional pilot (EXPERIMENTAL, later):** run Graphify on a **narrow** tree only — e.g. `rules/` + `hooks/` + `ai-tracking/ecosystem-governance/` + `lib/task-router/` — to see if docs-aware edges beat Registry. Success → SECONDARY skill; fail → quarantine skill, keep Registry.  
5. **Do not** add Graphify + a second full code indexer “just because”.

## Install notes (when pilot approved)

```text
# typical (verify upstream README at install time)
uv tool install graphify-labs
# or PyPI package name per current docs (graphify vs graphifyy — confirm before run)
graphify .
```

Exclude: `plugins/cache`, `.venv*`, `skills/open-design/repo`, `_archive`, `node_modules`, OneDrive migrate leftovers.

## Verdict line

**Graphify = promising SECONDARY/EXPERIMENTAL for docs-rich maps; not a GitNexus replacement; not CORE until narrow pilot passes.**  
Governance entity source of truth for now: **Ecosystem Registry + Architect**.
