---
name: dev-os-autonomy
description: >-
  Dev OS autonomy — DEC-008 executive charter. Full lifecycle without phase stops.
  Objective-level checkpoints only. DEC-005 + DEC-006 + DEC-008.
---

# Dev OS — Autonomy Mode (Phase 5)

Parent: [../SKILL.md](../SKILL.md) · Policy: `ai-tracking/dev-os/policies/autonomy.md`

**Active:** DEC-005, DEC-006, DEC-008. Charter: `docs/dev-os/EXECUTIVE.md`

## Execution defaults

- Execute without confirmation for research, corpus, skills, Squad ops (within gates)
- Batch related work into **large execution blocks** (full sprints, multi-file updates)
- Optimize for **speed + token efficiency**; maintain quality via validation pipeline
- **Candidate A stable** — no architecture changes without strong evidence + DEC

## Lifecycle execution (DEC-008)

Run full lifecycle without stopping between phases:

```
UNDERSTAND → RESEARCH → DESIGN → IMPLEMENT → VALIDATE → OPTIMIZE → AUDIT → FINALIZE → EVOLVE
```

Load [../execution/SKILL.md](../execution/SKILL.md) for phase routing.

## Milestone checkpoints (objective-level only)

After a **completed objective** or major milestone — **not** between lifecycle phases:

```
Continue? (Yes / No)
```

- **No response → assume Yes** and continue
- **Exception:** escalate security-critical, destructive, compliance, or irreversible actions immediately (do not wait for checkpoint)

## Progressive reporting

- Hide intermediate reasoning in user-facing output
- Report **completed milestones only** (sprint done, policy updated, corpus count)
- Use `dev-os-status.mjs` for detail; keep chat summaries concise

## Escalate immediately (not deferred to checkpoint)

| Trigger | Examples |
|---------|----------|
| Security | Secrets, prod deploy, credential exposure |
| Data loss | Mass delete, hard reset |
| Irreversible architecture | New agents, always-on rules, Candidate A change |
| Critical missing external data | Blocked API, unknown required credentials |
| Legal / compliance | Regulated data handling |
| Destructive operations | Irreversible git, wipe |

## Decision policy

```
autonomy > interaction · continuation > stopping · inference > clarification
```

Log assumptions to `decisions/log.md` (ASM/DEC). No micro-confirmations.

## Memory policy

| Confidence | Action |
|------------|--------|
| High (≥2 sources or production) | Auto LTM via squad-memory |
| Medium | `proposed-insights.md` |
| Low | Working tier only |

Auto-update corpus, decisions, memory under this policy without user confirm.

## Learning loop

Continue sprints, layer updates, proposed insights — no architectural drift.
