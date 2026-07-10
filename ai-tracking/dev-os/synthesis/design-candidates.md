---
phase: 4
status: closed
accepted_candidate: A
decision: DEC-004
version: 1.0
updated: 2026-07-01
depends_on: structure-emergence.md
sprint_evidence: [sprint_1, sprint_2]
---

# Dev OS — Design Candidates (Phase 4)

> **Closed.** User accepted **Candidate A** — logged as [DEC-004](../decisions/log.md#dec-004--phase-4-system-design-candidate-a-minimal-meta).

## Accepted topology (canonical operating model)

```
Boss (Meta-Orchestrator)
├── dev-os skills (research, decision, memory, emergence)
├── dev-os-research agent (domain sprints)
├── ai-tracking/dev-os/ corpus
└── Project Squad (execution layer — unchanged roster)
```

| Layer | Components |
|-------|------------|
| Meta | Boss, `skills/dev-os/`, `dev-os-research`, corpus, DEC log |
| Execution | `squad-*` agents, domain skills, MCP per mcp-routing |
| Deferred | dev-os-architect (B), mem0 corpus search (C) |

## Candidate A — Minimal meta ✓ ACCEPTED

**Topology:** Phase 3 as-is — Boss + dev-os skills + dev-os-research + Squad execution.

| Pros | Cons |
|------|------|
| Cursor-native; lowest token cost | No dedicated architect agent |
| Validated by Sprint 2 platform docs | Manual tradeoff analysis for structural forks |
| No new MCP servers | |

**Squad impact:** None  
**Status:** **Accepted** (DEC-004)

## Candidate B — Dual-layer expanded (deferred)

**Trigger to revisit:** ≥3 structural/MCP decisions in one quarter requiring isolated reasoning.

**Status:** Deferred — do not implement until DEC + emergence checklist passes.

## Candidate C — Corpus-first + optional mem0 (deferred)

**Trigger to revisit:** Corpus >50 sources OR file search repeatedly fails for research workflows.

**Status:** Deferred — aligns with DEC-002 provisional (file-first until measured need).

## Phase 4 closure checklist

- [x] Three candidates compared with evidence
- [x] User selected Candidate A
- [x] DEC-004 logged
- [x] No Squad roster changes
- [x] No new MCP servers
- [x] Fallback triggers documented for B and C

**Next:** Phase 5 — Execution + evolution (ongoing). Optional Sprint 3 for remaining domains.
