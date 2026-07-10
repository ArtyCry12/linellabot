# Dev OS — Decision Log

Format: observation → options → evidence → choice → revisit date.

---

## DEC-001 — Meta-layer over Project Squad

| Field | Value |
|-------|-------|
| Date | 2026-07-01 |
| Status | accepted |
| Revisit | after Research Sprint 1 complete |

**Observation:** Hub already has fixed Project Squad (10 subagents). Bootstrap spec forbids premature role fixation.

**Options:**
1. Replace Squad immediately with dynamic agents
2. Dev OS as meta-layer; Squad provisional until synthesis
3. Parallel systems with no interaction

**Evidence:** User choice in bootstrap planning; spec Part 3 dynamic emergence rule.

**Choice:** Option 2 — meta-layer. Squad executes operational tasks; Dev OS owns research and structural decisions.

**Consequences:** Squad SKILL gets provisional notice; bootstrap gate blocks new agents until `research_complete`.

---

## DEC-002 — File-first memory over managed store (provisional)

| Field | Value |
|-------|-------|
| Date | 2026-07-01 |
| Status | provisional |
| Revisit | after Sprint 2 (mcp-ecosystem, ai-dev-environments) or if semantic search becomes bottleneck |

**Observation:** mem0 and Letta offer compelling managed/git memory patterns; hub already uses user-memory MCP + ai-tracking files.

**Options:**
1. Adopt mem0 MCP for all LTM
2. Adopt Letta-style MemFS as primary (expand ai-tracking pattern)
3. Hybrid: file corpus for research + user-memory for validated facts (current + Dev OS tiers)

**Evidence:** 2026-letta-memfs, 2026-mem0-architecture, 2026-production-memory-frameworks, 2026-hub-user-memory-mcp; Sprint 1 compare matrix.

**Choice:** Option 3 — extend current stack with Dev OS tiered corpus; defer external memory service until measured need.

**Consequences:** Research lives in `ai-tracking/dev-os/`; promotion pipeline in memory skill; mem0 remains optional upgrade path.

---

## DEC-003 — Phase 3 structural emergence (minimal agents)

| Field | Value |
|-------|-------|
| Date | 2026-07-01 |
| Status | accepted |
| Revisit | after Sprint 2 or 3 structural decisions |

**Observation:** User approved Phase 3. Sprint 1 evidence favors simplest topology: skills + Boss for most meta functions; one complexity-driven agent for repeated domain research sprints.

**Options:**
1. Full Dev OS agent roster (research, architect, decision, memory) — 4+ new agents
2. Skills-only meta-layer — no new agents
3. Minimal emergence: one `dev-os-research` agent + module map document; Squad unchanged

**Evidence:** 2024-12-anthropic-effective-agents (simplest first); structure-emergence analysis; cursor-subagents (file agents when specialization clear); DEC-001 meta-layer boundary.

**Choice:** Option 3 — module map in `synthesis/structure-emergence.md`; single emerged agent `dev-os-research`; decision/memory/orchestration stay Boss + skills; Squad = execution layer.

**Consequences:** `skills/dev-os/emergence/SKILL.md` for future agent proposals; Phase 4 produces design candidates; no Squad roster changes.

---

## DEC-004 — Phase 4 system design: Candidate A (minimal meta)

| Field | Value |
|-------|-------|
| Date | 2026-07-01 |
| Status | accepted |
| Revisit | if ≥3 structural decisions/quarter (Candidate B) or corpus >50 sources (Candidate C) |

**Observation:** Phase 4 compared three hub architectures after Sprints 1–2 (5 domains, 21 source cards). User accepted minimal meta topology.

**Options:**
1. **Candidate A** — Phase 3 as-is: Boss + dev-os skills + dev-os-research + Squad execution; no new MCP
2. **Candidate B** — Add dev-os-architect agent for structural decisions
3. **Candidate C** — Corpus-first + optional mem0 at scale

**Evidence:** design-candidates.md; Sprint 2 Cursor-native validation; DEC-003 module map; 2026-cursor-changelog-2-4, 2026-hub-mcp-routing.

**Choice:** Candidate A — minimal meta. Defer B and C until emergence triggers in structure-emergence.md fire.

**Consequences:** Phase 4 closed. Hub operating model canonical: meta-layer (Dev OS) + execution layer (Squad). No roster/MCP changes. Candidate B/C remain documented fallbacks only.

---

## DEC-006 — Long-run autonomy checkpoint mode

| Field | Value |
|-------|-------|
| Date | 2026-07-01 |
| Status | accepted |
| Revisit | if silent-continue causes missed user stop intent |

**Observation:** User wants long unattended runs: minimal interaction, milestone checkpoints only, default-continue on silence, batched execution blocks, progressive reporting.

**Options:**
1. Confirm every step (rejected)
2. No checkpoints ever (risky for destructive ops)
3. **Milestone checkpoint** — single "Continue? Yes/No" after sprint; silence = Yes; immediate escalate for security/destructive/irreversible

**Evidence:** User autonomy patch spec; DEC-005 base; Candidate A stability requirement.

**Choice:** Option 3 — update `policies/autonomy.md` + `autonomy/SKILL.md`; batch sprints; hide intermediate reasoning; architecture frozen unless strong evidence.

**Consequences:** Sprint 5+ runs autonomously; one checkpoint line per milestone only.

---

### ASM-2026-07-01-006 — Evolution batch (LTM + anti-patterns)

- **Assumption:** User "Yes" authorizes LTM promotion + anti-pattern hardening without architecture change
- **Rationale:** DEC-006 continue; high-confidence corpus complete
- **Revisit:** next milestone checkpoint

---

## DEC-005 — Phase 5 autonomy upgrade + Sprint 3 enable

| Field | Value |
|-------|-------|
| Date | 2026-07-01 |
| Status | accepted |
| Revisit | if autonomy causes bad commit/deploy or missed escalation |

**Observation:** User requested autonomy mode for Phase 5: default execute, log assumptions, escalate only security/data-loss/irreversible architecture. Enable Sprint 3 (optimization + security).

**Options:**
1. User-confirm every step (status quo)
2. Full autonomy without gates (unsafe)
3. **Bounded autonomy** — execute by default; DEC/ASM logging; security > autonomy; Sprint 3 auto-run

**Evidence:** User patch spec; OWASP LLM01 (escalation triggers); DEC-004 Candidate A (no arch changes during sprint); hub cybersecurity + git user rules.

**Choice:** Option 3 — `skills/dev-os/autonomy/SKILL.md` + `policies/autonomy.md`; memory high-confidence auto-LTM else proposed insight; Sprint 3 executed (4+4 sources).

**Assumptions (batched):**
- ASM-2026-07-01-001: 4 sources/domain sufficient for minimal Sprint 3 (same as Sprint 2)
- ASM-2026-07-01-002: Medium-confidence Acon card stays proposed insight until second source
- ASM-2026-07-01-003: Autonomy does not waive git commit/push user rules

**Consequences:** dev-os-research and Boss default to continue; only 3 escalation classes block. Sprint 3 domains populated.

---

## DEC-007 — Long-term evolution principles (permanent policy)

| Field | Value |
|-------|-------|
| Date | 2026-07-03 |
| Status | accepted |
| Revisit | annual policy review or major platform shift |

**Observation:** User defined 10 permanent continuous-improvement objectives: knowledge, performance, tools, QA, portability, maintenance, ecosystem, market intel, communication, self-evolution.

**Options:**
1. One-time doc only (no enforcement)
2. **Permanent operating policy** encoded in policies + evolution skill + backlog tracks
3. Expand architecture (rejected — no evidence)

**Evidence:** User specification; DEC-004 stability; DEC-006 autonomy; corpus-synthesis self-evolution loop.

**Choice:** Option 2 — `policies/evolution-principles.md`, `skills/dev-os/evolution/SKILL.md`, backlog continuous tracks. No architecture change.

**Consequences:** Dev OS evolves incrementally with evidence; tool adoption requires compare/validate; safe maintenance autonomous; integration/ship still escalates.

---

## DEC-008 — Executive master prompt (operating charter)

| Field | Value |
|-------|-------|
| Date | 2026-07-03 |
| Status | accepted |
| Revisit | if charter conflicts with user git/safety rules in practice |

**Observation:** User provided final executive master prompt: autonomous engineering org, full lifecycle per task, no phase fragmentation, full autonomy with narrow interrupt set, continuous self-evolution.

**Options:**
1. Chat-only behavior (no encoding)
2. **Canonical charter** `docs/dev-os/EXECUTIVE.md` + execution skill; refine DEC-006 checkpoints to objective-level only
3. Replace Candidate A (rejected)

**Evidence:** User executive prompt; DEC-004/007 stability constraints; existing hub routing.

**Choice:** Option 2 — EXECUTIVE.md + `skills/dev-os/execution/SKILL.md`; lifecycle UNDERSTAND→EVOLVE; architecture improvements within Candidate A require DEC; phase-continuous execution.

**Consequences:** Boss defaults to full delivery lifecycle; Squad/domain skills for IMPLEMENT/VALIDATE; milestone checkpoints not phase checkpoints.

---

## DEC-009 — Obsidian purge + unified memory stack

| Field | Value |
|-------|-------|
| Date | 2026-07-03 |
| Status | accepted |
| Revisit | if user reintroduces PKM with different tool |

**Observation:** User final run: remove Obsidian entirely; memory = user-memory + AGENTS.md + ai-tracking only; focus hub/team.

**Choice:** Remove obsidian MCP from mcp.json, delete obsidian-mcp rule/skill/ensure script, update Squad/Dev OS/registry/audit/refresh.

**Consequences:** Single memory stack; no vault MCP dependency; fetch MCP remains (restart via Cursor Settings if errored).

---

### ASM-2026-07-03-001 — Evolution cycle 001

- **Assumption:** fetch/obsidian MCP errors are runtime (services down), not hub misconfiguration
- **Rationale:** STATUS.md errored; empty tool descriptors; Exa/memory/gitnexus healthy
- **Revisit:** after Obsidian start + fetch MCP reconnect

---

### ASM-2026-07-01-004 — Sprint 4 autonomous execution

- **Assumption:** Sprint 4 (automation + prompt-systems) follows Sprint 2–3 minimal pattern (4 sources/domain)
- **Rationale:** User directed Phase 5 continue under DEC-005; plan priority order item 4
- **Revisit:** N/A — sprint complete
