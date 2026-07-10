# Dev OS — Long-Term Evolution Principles

**Status:** Permanent operating policy  
**Decision:** DEC-007 (evolution) · complements **DEC-008** executive charter  
**Phase:** 5+ continuous improvement  
**Architecture:** Candidate A stable unless strong evidence + DEC

> These are **not one-time tasks**. Dev OS continuously improves when evidence exists. Never change without justification (research, testing, repeated practice).

## Core principle

Evolve into a cleaner, smarter, faster, more reliable, maintainable AI Dev OS — preserving **stability, security, portability, quality**.

Conflict order unchanged: **safety > quality > adaptability > autonomy > tokens**.

---

## 1. Knowledge management

| Responsibility | Cadence |
|----------------|---------|
| Merge duplicates, remove outdated info | On discovery |
| Consolidate fragmented docs | Per sprint or milestone |
| Clean knowledge graph, improve indexing | Ongoing |
| Promote **validated** info to LTM only | Per memory skill pipeline |
| Archive obsolete material (don't delete history) | `research/in-progress/archive/` |

**Artifacts:** `ai-tracking/dev-os/`, layers/, `proposed-insights.md`, user-memory

---

## 2. Performance monitoring

Evaluate when patterns repeat or hub feels slow:

- Token/context usage, latency, MCP/plugin performance
- Model routing, tool selection, unnecessary reasoning/context load

**Action:** propose → validate → apply **safe** improvements autonomously. Log ASM/DEC.

**Hub refs:** `optimization/` domain, mcp-routing, model-map, dev-os-status.mjs

---

## 3. Tool discovery

Monitor ecosystem (GitHub, Cursor, MCP, skills, frameworks, automation, security tools).

**Never adopt automatically.** Flow: compare → benchmark → compatibility → measurable value vs existing stack.

**Prioritize stability over novelty.** New MCP/agents require DEC + emergence checklist.

---

## 4. Quality assurance

Periodic audit (squad-scout pattern or dev-os-research):

- Architecture docs, prompts, skills, rules, subagents, MCP, memory, routing, file org
- Detect: duplicates, dead files, stale docs, naming drift, conflicting rules, broken refs

**Action:** fix safe items autonomously; escalate architecture changes.

---

## 5. Future compatibility

Remain portable where practical:

- Separate platform-specific logic (Cursor) from reusable knowledge
- Document interfaces; migration-friendly corpus structure
- Avoid Cursor lock-in unless benefit is significant

**Portable:** `ai-tracking/dev-os/`, skills content, decision log  
**Platform-bound:** `.mdc` rules, `agents/*.md`, MCP descriptors

---

## 6. Continuous system maintenance

Permanent housekeeping:

- Archive legacy; normalize naming; simplify folders
- Optimize indexing, cache/context routing
- Reduce complexity without Candidate A rewrites

**Trigger:** evolution backlog, squad-cleanup, cursor-system-refresh

---

## 7. Ecosystem health

Monitor MCP servers, plugins, integrations, automation (n8n), local infra.

Detect: failures, conflicts, stale config, duplicate integrations.  
Repair when safe; escalate credentials/security.

**Hub:** SYSTEM-REGISTRY, mcp-routing, `commands/*-mcp*.mjs`, ensure-* scripts

---

## 8. Market intelligence

Research capability for products, SaaS, competitors, pricing, trends — **evidence-based**, multi-source, multi-region when relevant.

**Route:** dev-os-research + Exa; output to `research/in-progress/` or domain findings — not LTM without validation.

---

## 9. Human communication

Improve clarity, structure, practicality; avoid robotic tone. Applies to docs, prompts, reports, user responses.

**Aligns with:** user communication rules, huashu-design for creative output.

---

## 10. Self-evolution

After milestones/projects:

- Lessons learned → patterns → workflows, prompts, routing, memory, docs, automation
- Incremental, evidence-based, maintainable
- Never sacrifice long-term stability for short-term optimization

**Trigger:** post-milestone review in `evolution/backlog.md`

---

## Execution contract (with DEC-006)

| Activity | Autonomous? | Escalate? |
|----------|-------------|-----------|
| Corpus/layer cleanup | Yes | No |
| Safe perf/doc fixes | Yes | No |
| Tool **recommendation** | Yes | No |
| Tool **integration** / new MCP | No | Yes |
| Architecture / agents / always-on rules | No | Yes |
| git commit/push/deploy | No | Yes |

## Checkpoint

One line after major evolution cycles: `Continue? (Yes / No)` — silence = continue.

## Related

- [autonomy.md](autonomy.md) · [evolution/backlog.md](../evolution/backlog.md) · [memory skill](../../../skills/dev-os/memory/SKILL.md)
