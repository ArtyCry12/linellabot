# Domain: Multi-Agent Systems

**Scope:** orchestration, delegation, coordination, hierarchy, agent lifecycle, communication protocols.

## Findings summary

1. **Pattern taxonomy matters.** LangChain's four patterns (subagents, skills, handoffs, routers) map cleanly onto Cursor hub primitives: `agents/*.md`, `skills/`, Task delegation, orchestrator routing.
2. **Runtime vs file-based agents.** LangGraph provides graph runtime with Command routing; Cursor uses markdown agent files + Task tool — topology is declarative, routing is LLM-driven in parent.
3. **Simplicity first.** Anthropic recommends single-agent + tools until complexity is measured; multi-agent adds compounding error and debug cost.
4. **Cursor subagents are first-class.** YAML frontmatter agents with isolated context, foreground/background, per-agent models — hub's Squad is this pattern at scale.
5. **Supervisor pattern fits meta-layer.** Dev OS Boss as router; Squad specialists as workers; research gate prevents roster expansion without evidence.

## Comparative notes

| Pattern | Best for | Hub mapping |
|---------|----------|-------------|
| Subagents | Isolated specialist tasks | `agents/squad-*.md`, Task tool |
| Skills | Reusable procedures | `skills/*/` |
| Handoffs | Sequential ownership transfer | ai-tracking handoff files |
| Supervisor | Dynamic routing | Boss + orchestrator rules |
| Pipeline | Fixed DAG | n8n workflows, CI scripts |

**Tension:** LangGraph/LangChain encourage multi-agent graphs; Anthropic warns against premature complexity. **Resolution:** Dev OS gate + provisional Squad label.

## Open gaps

- AutoGen / CrewAI deep dive (deferred to sprint 2)
- Empirical error rates for 10-agent Squad vs 3-agent minimal roster
- Background subagent cost/latency benchmarks in Cursor

## Sources

| ID | Title | URL | Confidence |
|----|-------|-----|------------|
| 2026-03-28-langgraph-supervisor | LangGraph Supervisor Pattern | https://www.abstractalgorithms.dev/langgraph-multi-agent-supervisor-pattern | high |
| 2026-01-14-langchain-multi-agent-patterns | Choosing Multi-Agent Architecture | https://www.langchain.com/blog/choosing-the-right-multi-agent-architecture | high |
| 2026-cursor-subagents-docs | Cursor Subagents | https://cursor.com/docs/subagents | high |
| 2024-12-anthropic-effective-agents | Building Effective Agents | https://www.anthropic.com/research/building-effective-agents | high |
