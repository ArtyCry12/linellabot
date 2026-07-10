---
status: complete
version: 1.0
updated: 2026-07-01
domains: 10
source_cards: 41
architecture: Candidate A
---

# Dev OS — Corpus Synthesis (10/10)

> Consolidated understanding after Sprints 1–5. **Not a new architecture** — validates Candidate A (DEC-004).

## One-paragraph vision

The ideal Cursor AI Dev OS for this hub is a **research-gated meta-layer** (Boss + dev-os skills + dev-os-research + file corpus) sitting above a **Cursor-native execution layer** (Project Squad + on-demand domain skills + selective MCP). It learns through source cards → domain findings → layers → decisions; executes with bounded autonomy (DEC-006); keeps context as the primary constraint; and refuses architectural sprawl unless evidence + DEC.

## Domain conclusions (compressed)

| Domain | Core conclusion |
|--------|-----------------|
| multi-agent | Simplest-first; file subagents when specialized; Squad = workers |
| context-engineering | Budget context; handoff files; tool-shaped MCP; on-demand load |
| memory-systems | File corpus + user-memory; validate before LTM |
| ai-dev-environments | Rules minimal; skills procedural; MCP lazy (Cursor 2.4) |
| mcp-ecosystem | Host-client-server; hub routing dedup; no new servers without gap proof |
| optimization | 60–80% utilization; stable prefix; trim tool outputs |
| security | OWASP LLM01; execution gates; autonomy cannot override safety |
| automation | n8n skill + instance MCP; HITL for sensitive workflows |
| prompt-systems | Hub stack IS prompt system; progressive disclosure |
| creative-systems | Execution layer only; squad-design + huashu/21st/figma on-demand |

## What we will NOT do (unless new DEC)

- Replace Candidate A topology
- Add dev-os-architect or expand Squad roster without emergence checklist
- Adopt mem0 before corpus >50 sources or search failure (Candidate C trigger)
- Always-on dev-os rule

## Phase 5 evolution (ongoing)

1. **Learn** — monitor hub usage; add source cards when patterns repeat
2. **Promote** — high-confidence findings → best-practices → user-memory
3. **Prune** — supersede decisions; archive in-progress hypotheses
4. **Execute** — Squad for builds; dev-os-research for new domain deep-dives
5. **Review** — Candidate B/C triggers in design-candidates.md

## Evidence

Full index: [../index.md](../index.md) · Decisions: [../decisions/log.md](../decisions/log.md)
