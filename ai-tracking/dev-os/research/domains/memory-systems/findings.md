# Domain: Memory Systems

**Scope:** short/long-term memory, extraction, validation, tiering, external vs file-based stores.

## Findings summary

1. **Three production archetypes:** managed extraction layer (mem0), git-backed MemFS (Letta), bi-temporal graph (Zep/Graphiti) — choice depends on write cost, audit needs, read latency.
2. **mem0 pattern:** LLM extract-on-write, dedup, entity linking, multi-signal retrieval — good for personalization without unbounded chat history.
3. **Letta MemFS pattern:** markdown + YAML frontmatter, `system/` always in prompt, lazy-load paths, agent self-edits memory — strong fit for hub's ai-tracking + skills promotion.
4. **Hub baseline:** user-memory MCP (session facts) + AGENTS.md + ai-tracking/ + skills — no single vector DB; squad-memory promotes validated patterns.
5. **Validation before LTM:** Part 3 rule confirmed by mem0 paper and production comparisons — never promote one-off hypotheses.

## Comparative notes

| Approach | Write | Read | Audit | Hub fit |
|----------|-------|------|-------|---------|
| File corpus (ai-tracking) | Manual/agent | grep/read | git | **current Dev OS tier** |
| user-memory MCP | agent remember | recall | MCP store | **current session LTM** |
| mem0 | auto extract | semantic+BM25 | managed | optional if scale demands |
| Letta MemFS | agent edit files | tiered load | git | aligns with dev-os corpus |
| Graph (Zep) | relationship extract | temporal query | bi-temporal | overkill for solo hub |

## Open gaps

- Explicit promotion criteria from dev-os corpus → user-memory (thresholds)
- mem0 vs user-memory MCP side-by-side in hub
- seo-geo HOT/WARM/COLD formal mapping to dev-os tiers

## Sources

| ID | Title | URL | Confidence |
|----|-------|-----|------------|
| 2026-mem0-architecture | Mem0 Architecture | https://github.com/mem0ai/mem0 | high |
| 2026-letta-memfs | Letta MemFS | https://docs.letta.com/letta-code/memory/ | high |
| 2025-mem0-arxiv-paper | Mem0 arXiv 2504.19413 | https://arxiv.org/abs/2504.19413 | high |
| 2026-production-memory-frameworks | Production Memory Comparison | https://jatinbansal.com/ai-engineering/production-memory-frameworks/ | medium |
| 2026-hub-user-memory-mcp | Hub user-memory + tiers | file://SYSTEM-REGISTRY.md | high |
