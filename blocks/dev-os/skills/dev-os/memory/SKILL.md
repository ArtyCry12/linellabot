---
name: dev-os-memory
description: >-
  Dev OS memory tiers and update pipeline — what to store, validate, compress,
  and promote to user-memory. Use when @dev-os memory, knowledge promotion,
  or corpus cleanup for Cursor AI Dev OS.
---

# Dev OS — Memory System

Parent: [../SKILL.md](../SKILL.md)

## Tiers

| Tier | Location | Content | TTL |
|------|----------|---------|-----|
| Working | chat + `research/in-progress/` | Raw notes, hypotheses | Session |
| Project | `research/domains/`, `research/sources/` | Findings, extraction cards | Until validated or archived |
| Long-term | `user-memory` MCP + `AGENTS.md` | Verified patterns only | Persistent |
| Skill | `skills/dev-os/`, domain skills | Stable procedures | Git |

Existing hub stack: **user-memory → AGENTS.md → ai-tracking/** (DEC-009; Obsidian removed).

## What enters long-term memory

Only:

- Durable patterns (≥2 sources or production proof)
- Repeated engineering decisions
- Validated optimizations
- Security constraints

## What does NOT enter long-term memory

- One-off hypotheses
- Unverified README claims
- Temporary task context
- Secrets / API keys

## Update pipeline (mandatory)

```
1 extract   → source card or domain finding
2 validate  → ≥2 sources OR production evidence
3 compress  → one paragraph + links
4 store     → correct tier
5 conflict  → check anti-patterns.md + existing memory
```

## Promotion path

```
research/sources/*.md
  → domains/*/findings.md
  → layers/best-practices.md
  → user-memory (via squad-memory or explicit remember)
  → skills/dev-os/ or domain skill update (stable procedure)
```

## Pruning

- Remove superseded findings from `in-progress/`
- Mark decision log entries `superseded`
- Never delete source cards — archive with note

## Automation

- `squad-memory` (Haiku) may write to user-memory **after** validation step
- Dev OS agent must not bulk-write memory from single-source research

## Autonomy mode (DEC-005 + DEC-008)

| Confidence | Criteria | Action |
|------------|----------|--------|
| **High** | ≥2 sources OR production proof | Auto-promote to LTM (`user-memory` / AGENTS.md) via squad-memory |
| **Medium** | 1 strong source, plausible | Append to [proposed-insights.md](../../../ai-tracking/dev-os/research/in-progress/proposed-insights.md) |
| **Low** | Hypothesis, single weak signal | Working tier only; do not promote |

Autonomy allows high-confidence writes without user confirm. Security/data-loss/architecture changes still escalate.
