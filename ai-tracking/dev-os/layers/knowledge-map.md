# Dev OS — Knowledge Map

Cross-domain map of approaches, links, and conflicts. Updated through Sprint 5 — **10/10 domains complete**.

## Compare matrix

| Approach | Domain | Pros | Cons | When to use | Obsolete? | Sources |
|----------|--------|------|------|-------------|-----------|---------|
| Cursor file subagents | multi-agent | Versionable, IDE-native, isolated context | Roster sprawl if ungated | Hub execution with known roles | No | cursor-subagents |
| LangGraph supervisor | multi-agent | Dynamic routing, traceable | Runtime overhead, needs graph infra | Complex branching workflows | No | langgraph-supervisor |
| Single agent + tools | multi-agent | Simple, debuggable | Limited parallelism | Default until complexity proven | No | anthropic-effective-agents |
| Skills as capabilities | multi-agent | Token-efficient, reusable | Needs discovery/routing | Procedures, not personas | No | langchain-patterns |
| Context as budget | context-eng | Coherence, cost control | Requires curation discipline | Always | No | anthropic-context-eng |
| MCP tool shaping | context-eng | Better tool use, less pollution | Design upfront | All MCP servers | No | anthropic-tools-mcp |
| Handoff files | context-eng | Clean resets, auditable | Manual structure | Long research/build | No | harness-long-running |
| On-demand rules/skills | context-eng | Low always-on token cost | Routing must be correct | Hub orchestration | No | hub audit |
| File corpus (git) | memory | Human-readable, diffable | Manual merge, no semantic search | Research tiers, dev-os | No | hub-user-memory |
| user-memory MCP | memory | Cross-session facts | Separate store | Validated session LTM | No | hub-user-memory |
| mem0 managed | memory | Auto extract/dedup | External dep, write latency | Multi-tenant personalization | No | mem0-architecture |
| Letta MemFS | memory | Git audit, tiered prompt | Agent must maintain files | Transparent agent memory | No | letta-memfs |
| Cursor rules/skills/MCP stack | ai-dev-env | Native IDE model, token-aware | Requires discipline | Cursor hub primary | No | cursor-customizing-agents |
| Lazy MCP load (2.4) | ai-dev-env | Saves context | Discovery latency | Many MCP servers | No | cursor-changelog-2-4 |
| Manual/on-demand rules | ai-dev-env | Low always-on cost | Must @mention or route | Dev OS, domain triggers | No | cursor-rules-docs |
| MCP host-client-server | mcp-ecosystem | Isolation, capability negotiation | Multi-server auth | Any MCP IDE | No | mcp-architecture-spec |
| Tools vs resources vs prompts | mcp-ecosystem | Clear separation of concerns | More design upfront | Server authors | No | mcp-server-concepts |
| Hub MCP routing table | mcp-ecosystem | Dedup, conflict reduction | Hub-specific policy | This workspace | No | hub-mcp-routing |
| Token budget 60–80% | optimization | Quality + cost balance | Needs monitoring | Long agent sessions | No | mlmastery-context-eng |
| Prompt prefix caching | optimization | 50–90% input cost cut | Prefix must be stable | Large static system prompts | No | zylos-prompt-caching |
| OWASP LLM + sandbox | security | Standard risks + kernel policy | Ops complexity | Ship/deploy paths | No | owasp-llm-top10 |
| Autonomy bounded | security | Flow without micro-confirm | Must escalate critical | Phase 5 execution | No | DEC-005 |
| n8n skill + instance MCP | automation | Offline + live validate | Two surfaces to maintain | Event automation | No | hub-n8n-workflow |
| Skills as prompt protocols | prompt-systems | Versioned procedures | Discovery routing needed | Hub instruction stack | No | promptkit |
| Creative execution layer | creative-systems | On-demand heavy tools | Wrong layer if meta-loaded | Design/motion/UI tasks | No | hub-creative-routing |

## Cross-domain links

- **multi-agent ↔ context:** Each subagent hop duplicates system context — minimize roster (Anthropic) + on-demand skills (hub).
- **multi-agent ↔ memory:** Handoff files bridge agents without shared chat (harness design); Letta MemFS mirrors ai-tracking structure.
- **context ↔ memory:** Tool responses and memory injections compete for same window — tier what enters prompt (Letta system/ vs lazy).
- **Dev OS meta-layer:** Research corpus = Letta-style project memory; gate = Anthropic simplicity discipline.
- **ai-dev-env ↔ context:** Cursor platform confirms rules-minimal + skills-on-demand — same as Dev OS orchestrator policy.
- **mcp-ecosystem ↔ context:** Lazy MCP discovery (2.4) + deterministic tools/list = prompt cache + descriptor-first hub workflow.

- **creative-systems ↔ meta-layer:** Creative MCPs stay in Squad execution — Dev OS documents only, does not own design tools.

## Conflicting approaches

| Conflict | Side A | Side B | Resolution (provisional) |
|----------|--------|--------|--------------------------|
| Multi-agent vs simple | LangGraph/LangChain patterns | Anthropic simplest-first | Gate + provisional Squad; add agents only via decision log |
| Opaque vs transparent memory | mem0 managed store | Letta/git files | Hub stays file-first; mem0 optional at scale |
| Compaction vs reset | In-place compaction | Context reset + handoff | Long Dev OS sprints use handoff files in ai-tracking |
| Many MCP servers vs web dedup | MCP spec (compose many) | Hub mcp-routing (one web provider) | Keep hub dedup; add servers only task-triggered |

## Domain index

- [multi-agent](../research/domains/multi-agent/findings.md) — 4 sources
- [context-engineering](../research/domains/context-engineering/findings.md) — 4 sources
- [memory-systems](../research/domains/memory-systems/findings.md) — 5 sources
- [ai-dev-environments](../research/domains/ai-dev-environments/findings.md) — 4 sources (Sprint 2)
- [mcp-ecosystem](../research/domains/mcp-ecosystem/findings.md) — 4 sources (Sprint 2)
- [optimization](../research/domains/optimization/findings.md) — 4 sources (Sprint 3)
- [security](../research/domains/security/findings.md) — 4 sources (Sprint 3)
- [automation](../research/domains/automation/findings.md) — 4 sources (Sprint 4)
- [prompt-systems](../research/domains/prompt-systems/findings.md) — 4 sources (Sprint 4)
- [creative-systems](../research/domains/creative-systems/findings.md) — 4 sources (Sprint 5)

**Corpus:** 10/10 domains complete.
