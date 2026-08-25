---
name: dev-os-decision
description: >-
  Dev OS decision framework — Research → Reason → Design candidates → Execute.
  Dynamic subagent emergence checklist, security override, decision log format.
  Use when @dev-os decide, architecture choice, or after comparative analysis.
---

# Dev OS — Decision Framework

Parent: [../SKILL.md](../SKILL.md) · Log: `ai-tracking/dev-os/decisions/log.md`

## Pipeline

```
Research → Reason → Design (candidates) → Execute
```

**Design** outputs are **candidates**, not final architecture.

## Reasoning steps

1. Gather evidence from corpus (`layers/`, domain findings, source cards)
2. Compare approaches — pros, cons, limits
3. Identify conflicts with existing hub (Squad, registry, memory)
4. Generate 2–3 candidate options minimum
5. Apply conflict priority: safety > quality > adaptability > autonomy > tokens

## Dynamic subagent emergence

Before creating `agents/<name>.md`:

| Check | Question |
|-------|----------|
| Functional | Does task need dedicated specialization? |
| Complexity | Is single-agent context overloaded? |
| Optimization | Is pattern repeating across projects? |

If **no** to all → use Task `explore` / existing Squad role / skill only.

If **yes** → document in decision log **before** creating agent file (requires gate open or user override).

## Model routing (provisional)

Until synthesis replaces it, use [project-squad model-map](../../project-squad/reference/model-map.md):

| Task type | Model tier |
|-----------|------------|
| Research synthesis | Strong reasoning |
| Code execution | Codex / build tier |
| Scout / cleanup | Composer / Haiku |
| Security review | Strong + cybersecurity skill |

## Security override

Before deploy, destructive ops, or credential handling:

- Run cybersecurity skill review
- Block if high risk; log in decision log

## Decision log entry format

```markdown
## DEC-NNN — Title

| Field | Value |
|-------|-------|
| Date | YYYY-MM-DD |
| Status | proposed | accepted | superseded |
| Revisit | date or trigger |

**Observation:**
**Options:** (numbered)
**Evidence:** (links to source cards)
**Choice:**
**Consequences:**
```

## Self-restructuring rule

System may change internal structure **only after**:

- Completed analysis for affected area
- Decision log entry
- Gate status allows (or user override)

## Autonomy mode (DEC-005 + DEC-006 + DEC-008)

- **Default:** full lifecycle without phase stops; log assumptions (DEC/ASM)
- **Checkpoints:** one line after completed objective only; **silence = continue**
- **Escalate immediately:** security, data loss, irreversible architecture, critical missing data, legal, destructive ops
- **Batch** related work; milestone-only reporting
- **Candidate A stable** unless strong evidence + DEC
- **Safety override:** conflict priority #1 blocks unsafe autonomy

## Execution handoff

When gate allows execution phase:

- Operational tasks → Project Squad (provisional roster)
- Domain tasks → existing domain skills
- Meta/structure → remain in Dev OS loop
