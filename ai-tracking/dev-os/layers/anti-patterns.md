# Dev OS — Anti-patterns Layer

What breaks systems and typical mistakes.

---

### Premature multi-agent roster

- **Domain:** multi-agent
- **Symptom:** Many generic subagents, vague descriptions, no delegation
- **Root cause:** Copying framework patterns before measuring task complexity
- **Fix / avoid:** Dev OS bootstrap gate; Anthropic simplest-first; decision log for each new agent
- **Sources:** 2024-12-anthropic-effective-agents, 2026-cursor-subagents-docs

### Always-on context bloat

- **Domain:** context-engineering
- **Symptom:** Slow responses, ignored rules, tool confusion
- **Root cause:** Too many always-on rules/skills/MCP servers loaded every turn
- **Fix / avoid:** On-demand rules (dev-os.mdc not always-on); orchestrator routing table
- **Sources:** 2025-09-29-anthropic-context-engineering, hub 00-agent-orchestrator

### Unvalidated memory promotion

- **Domain:** memory-systems
- **Symptom:** Contradictory AGENTS.md facts; stale patterns treated as canon
- **Root cause:** Single-source README claims written to LTM
- **Fix / avoid:** 2+ source validation; conflict check against anti-patterns layer
- **Sources:** 2025-mem0-arxiv-paper, skills/dev-os/memory

### Compaction as only long-task strategy

- **Domain:** context-engineering
- **Symptom:** Agent wraps up early or loses thread mid-research
- **Root cause:** Relying on summarization without structured handoff
- **Fix / avoid:** ai-tracking handoff files; background subagents for parallel research
- **Sources:** 2026-anthropic-harness-long-running

### Rule over-engineering (Cursor official anti-pattern)

- **Domain:** ai-dev-environments
- **Symptom:** Slow agent, ignored instructions, context waste
- **Root cause:** Too many always-on rules
- **Fix / avoid:** Move occasional content to skills; keep 1–2 always-on hub rules
- **Sources:** 2026-cursor-customizing-agents

### Opaque memory with no audit trail

- **Domain:** memory-systems
- **Symptom:** Cannot debug why agent "remembers" wrong fact
- **Root cause:** Vector-only store without human-readable corpus
- **Fix / avoid:** File corpus for research; git-tracked dev-os layers
- **Sources:** 2026-letta-memfs, 2026-production-memory-frameworks

### Sensitive automation without HITL

- **Domain:** automation
- **Symptom:** Unreviewed prod workflow changes; PII/money actions auto-executed
- **Root cause:** Full n8n MCP autonomy on sensitive paths
- **Fix / avoid:** HITL for money/PII/prod; narrow exposed workflows first
- **Sources:** 2026-uibakery-n8n-mcp-guide, DEC-005 escalation rules

### Creative stack loaded for meta tasks

- **Domain:** creative-systems
- **Symptom:** Token bloat; figma/huashu MCP loaded during research/Dev OS work
- **Root cause:** Missing orchestrator routing
- **Fix / avoid:** Creative MCPs only via squad-design / explicit @huashu / @21st
- **Sources:** 2026-hub-creative-routing, 2026-cursor-customizing-agents

### Autonomy without escalation discipline

- **Domain:** security
- **Symptom:** Destructive git/deploy runs during "silent continue"
- **Root cause:** Treating all actions as non-escalating
- **Fix / avoid:** Immediate escalate for security/data-loss/architecture; DEC-006 checkpoint does not defer these
- **Sources:** DEC-006, 2025-owasp-llm01-prompt-injection

---