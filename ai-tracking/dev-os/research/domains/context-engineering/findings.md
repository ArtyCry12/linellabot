# Domain: Context Engineering

**Scope:** context window budgeting, compaction, tool design, harness design, selective loading.

## Findings summary

1. **Context is a budgeted asset**, not unlimited memory. Curation beats accumulation (Anthropic context engineering).
2. **Tools are context.** MCP tool names, parameters, and response shapes are part of the prompt; consolidate and shape for LLM consumption.
3. **Harness design for long tasks:** file-based handoffs beat in-chat compaction alone; context resets with structured artifacts; model-specific "context anxiety" requires empirical harness tuning.
4. **Hub already applies patterns:** on-demand rules/skills, MCP routing dedup (one web provider per thread), descriptor-first MCP calls.
5. **Composition:** memory + compaction + tool clearing stack — see Claude cookbook for when each applies.

## Comparative notes

| Strategy | Pros | Cons | When |
|----------|------|------|------|
| Full history | Simple | Degrades coherence, costly | Short tasks only |
| Compaction | Continuity | Anxiety persists, lossy | Mid-length sessions |
| Context reset + handoff file | Clean window, auditable | Requires discipline | Long research/build |
| Selective skill/rule load | Token efficient | Needs routing | Always in hub |
| Tool response shaping | Better agent behavior | Upfront design cost | All MCP integrations |

## Open gaps

- Karpathy guidelines deep extraction (seed source, pending card)
- RAG vs file-corpus for dev-os research retrieval
- Token budgets per Squad role (empirical)

## Sources

| ID | Title | URL | Confidence |
|----|-------|-----|------------|
| 2025-09-29-anthropic-context-engineering | Effective Context Engineering | https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents | high |
| 2025-09-11-anthropic-writing-tools-mcp | Writing Tools for Agents | https://www.anthropic.com/engineering/writing-tools-for-agents | high |
| 2026-anthropic-harness-long-running | Harness for Long-Running Apps | https://www.anthropic.com/engineering/harness-design-long-running-apps | high |
| 2026-03-claude-cookbook-context-engineering | Context Engineering Cookbook | https://platform.claude.com/cookbook/tool-use-context-engineering-context-engineering-tools | medium |
