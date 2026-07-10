# Domain: Optimization

**Scope:** token economy, context compression, caching, model routing, cost/latency.

## Findings summary (Sprint 3)

1. **Prefix stability = cache leverage** — static system/rules/skills frontmatter before dynamic content; avoid timestamps in always-on layers.
2. **Trim tool outputs at ingestion** — largest token sink in agent loops; filter before inject beats compress later.
3. **Target 60–80% context utilization** — not max window; compress/summarize at ~75% with last 3–5 turns verbatim.
4. **Hub already aligned** — Candidate A: on-demand rules/skills, lazy MCP, model-map tiers, one web provider (class E audit).
5. **Acon-style guideline compression** — domain findings merges should preserve intent/decisions (research protocol note).

## Sources

| ID | Title | URL | Confidence |
|----|-------|-----|------------|
| 2026-zylos-prompt-caching-agents | Prompt caching for agents | https://zylos.ai/research/2026-03-27-prompt-caching-kv-cache-optimization-long-running-ai-agents | high |
| 2026-mlmastery-context-engineering | Context engineering guide | https://machinelearningmastery.com/effective-context-engineering-for-ai-agents-a-developers-guide/ | high |
| 2026-acon-context-compression | Acon arXiv | https://arxiv.org/html/2510.00615v3 | medium |
| 2026-hub-token-optimization | Hub token audit | file://rules/mcp-routing.mdc | high |
