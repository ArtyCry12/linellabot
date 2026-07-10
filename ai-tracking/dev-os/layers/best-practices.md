# Dev OS — Best Practices Layer

Production-proven patterns extracted from research. Each entry needs ≥2 sources or production evidence.

---

### Simplest agent topology first

- **Domain:** multi-agent
- **Pattern:** Start with single Boss + tools/skills; add subagents only when repeated specialization need is proven.
- **Why it works:** Reduces compounding errors and debug surface (Anthropic); matches bootstrap gate intent.
- **Sources:** 2024-12-anthropic-effective-agents, 2026-cursor-subagents-docs

### File-based agent definitions

- **Domain:** multi-agent
- **Pattern:** Subagents as markdown with YAML frontmatter in `.cursor/agents/`; explicit descriptions for delegation.
- **Why it works:** Version control, team sharing, no runtime server; Cursor-native.
- **Sources:** 2026-cursor-subagents-docs, hub Squad roster

### Context budget discipline

- **Domain:** context-engineering
- **Pattern:** Treat context window as finite; load rules/skills/MCP on-demand; one web research provider per thread.
- **Why it works:** Coherence and cost; prevents tool/ rule pollution.
- **Sources:** 2025-09-29-anthropic-context-engineering, hub mcp-routing

### Agent-shaped MCP tools

- **Domain:** context-engineering
- **Pattern:** Clear tool names, minimal params, consolidated operations, LLM-friendly error messages.
- **Why it works:** Tools are part of the prompt; bad tools waste context and cause misuse.
- **Sources:** 2025-09-11-anthropic-writing-tools-mcp

### Handoff artifacts for long work

- **Domain:** context-engineering
- **Pattern:** Structured files in ai-tracking for cross-session/cross-agent continuity instead of relying on compaction alone.
- **Why it works:** Avoids context anxiety and lossy summarization near window limits.
- **Sources:** 2026-anthropic-harness-long-running, dev-os corpus design

### Validate before long-term memory

- **Domain:** memory-systems
- **Pattern:** extract → validate (2+ sources or production evidence) → compress → store → conflict check.
- **Why it works:** Prevents hypothesis pollution in LTM; mem0/Letta both emphasize curation.
- **Sources:** 2025-mem0-arxiv-paper, 2026-letta-memfs, skills/dev-os/memory

### Cursor-native rules/skills/MCP layering

- **Domain:** ai-dev-environments
- **Pattern:** Minimal always-on rules; skills for procedures; MCP on-demand; CLI via rule hints
- **Why it works:** Official Cursor guidance + 2.4 lazy MCP loading
- **Sources:** 2026-cursor-customizing-agents, 2026-cursor-changelog-2-4

### MCP routing before adding servers

- **Domain:** mcp-ecosystem
- **Pattern:** Audit SYSTEM-REGISTRY + mcp-routing; one web provider per thread; descriptor-first calls
- **Why it works:** Prevents tool context pollution and provider conflicts
- **Sources:** 2026-hub-mcp-routing, 2025-mcp-architecture-spec

### Tiered memory (working / project / LTM / skill)

- **Domain:** memory-systems
- **Pattern:** Raw notes in working tier; domain findings in project tier; validated patterns to user-memory; stable procedures in skills.
- **Why it works:** Separates ephemeral from durable; matches Letta MemFS hierarchy and hub stack.
- **Sources:** 2026-letta-memfs, 2026-hub-user-memory-mcp

### n8n dual stack (skill + instance MCP)

- **Domain:** automation
- **Pattern:** Offline n8n-workflow skill for JSON/expressions; instance n8n-mcp for build/run when connected; HITL for PII/money/prod
- **Why it works:** Skill works when MCP fails; instance MCP adds validate/compile loop
- **Sources:** 2026-hub-n8n-workflow-skill, 2026-n8n-mcp-build-workflows

### Prompts as versioned skills

- **Domain:** prompt-systems
- **Pattern:** Multi-step SKILL.md protocols + agent role files; registry/triggers not inlined mega-prompts
- **Why it works:** Progressive disclosure + cache-stable prefixes (PromptKit, production prompt arch)
- **Sources:** 2026-microsoft-promptkit, 2026-hub-prompt-stack

### Creative on-demand routing

- **Domain:** creative-systems
- **Pattern:** Route huashu / 21st / figma / stitch via orchestrator; squad-design for project creative; never load for meta/research
- **Why it works:** Creative MCPs are heavy; execution-layer separation preserves tokens
- **Sources:** 2026-hub-creative-routing, 2026-figma-design-agent-mcp

### Bounded autonomy with milestone checkpoints

- **Domain:** security + optimization
- **Pattern:** Execute by default; one checkpoint per milestone; silence=continue; immediate escalate for security/destructive/architecture
- **Why it works:** Long unattended runs without sacrificing OWASP-aligned gates
- **Sources:** DEC-005, DEC-006, 2025-owasp-llm01-prompt-injection

---