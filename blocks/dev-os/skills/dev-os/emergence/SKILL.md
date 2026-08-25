---
name: dev-os-emergence
description: >-
  Dev OS Phase 3+ structural emergence — module map, agent creation checklist,
  boundaries vs Project Squad. Use when @dev-os emerge, new subagent proposal,
  or validating structural change after research gate.
---

# Dev OS — Structural Emergence

Parent: [../SKILL.md](../SKILL.md) · Map: `ai-tracking/dev-os/synthesis/structure-emergence.md`

## When to load

- User approves Phase 3+ or asks to add/change hub structure
- Proposing new `agents/*.md` or always-on rules
- Distinguishing Dev OS meta work from Squad execution

## Module map (summary)

| Module | Agent | Skill |
|--------|-------|-------|
| Meta-Orchestrator | Boss | dev-os SKILL |
| Research Engine | dev-os-research | research/ |
| Knowledge Corpus | — | memory/ (writes) |
| Decision Framework | Boss | decision/ |
| Memory Pipeline | squad-memory | memory/ |
| Execution | squad-* | project-squad |

Full diagram: [structure-emergence.md](../../../ai-tracking/dev-os/synthesis/structure-emergence.md)

## Agent creation checklist (mandatory)

Before creating any new agent file:

```
[ ] DEC-NNN entry drafted in decisions/log.md
[ ] Gate: understanding.md status == research_complete OR user override
[ ] Functional: task needs isolation from Boss chat?
[ ] Complexity: skill-only failed or context overloaded (cite instances)?
[ ] Pattern: repeating ≥3 times across sessions/projects?
[ ] No duplicate: existing squad-* or dev-os-* already covers this?
[ ] Boundaries: module owns this function per structure-emergence.md?
```

If any **No** on functional/complexity/pattern → use Task `explore` or existing agent.

## Allowed Phase 3 agents

| Agent | Purpose |
|-------|---------|
| `dev-os-research` | Domain research sprints, source cards, Exa threads |

## Forbidden without Phase 4+ decision

- Replacing Squad roster wholesale
- Always-on dev-os rule (stay on-demand)
- New MCP servers (research gap required)

## Routing quick reference

```
Meta / research / structure  → @dev-os (+ dev-os-research for sprints)
Build / QA / ship / audit    → @project-squad
Domain (n8n, seo, clone)     → domain skill
```

Log structural choices in `decisions/log.md`.
