---
name: crew-ai
description: >-
  Cursor adaptation of crewAIInc/crewAI — Crews (role-based agent teams) and
  Flows (sequential production pipelines) mapped to Project Squad subagents.
  Use for marketing campaigns, SEO content pipelines, production-studio
  brief-to-QC. Triggers: crew, marketing crew, production crew, crewai, multi-agent workflow.
version: "1.0.0"
license: MIT
compatibility: cursor
metadata:
  author: hub
  version: "1.0.0"
  source: https://github.com/crewAIInc/crewAI
when_to_use: marketing_pipeline, production_pipeline, multi_agent_crew
argument-hint: "[marketing | production] [topic]"
---

# CrewAI — Cursor hub adaptation

Source: [crewAIInc/crewAI](https://github.com/crewAIInc/crewAI). **Do not** install Python crewai in the hub repo — use **patterns only**.

## Mapping

| CrewAI | Cursor hub |
|--------|------------|
| **Crew** | Sequential `Task` subagents with role/goal/backstory |
| **Flow** | `workflow-phases.md` + crew JSON task chain |
| **agents.yaml** | `lib/crew-ai/crews/*.json` |
| **tasks.yaml** | `tasks[]` in same JSON |
| **Process sequential** | Boss runs steps 1→N; parallel only where roster allows |

## Built-in crews

| Crew | ID | Hub owner |
|------|-----|-----------|
| Marketing / SEO / copy | `marketing-crew` | `squad-growth` |
| Production studio | `production-crew` | `squad-design` + `squad-qa` |

## Quick start

```powershell
powershell -File commands/crew-plan.ps1 -Crew marketing -Topic "SaaS landing"
powershell -File commands/crew-plan.ps1 -Crew production -Project "reel 15s"
```

Boss (or parent agent):

1. Run `crew-plan` → markdown spawn plan
2. Execute tasks **in order** respecting `dependsOn`
3. **Gate:** no publish/deploy/social post without user approval

## When to use

- Full marketing pipeline: research → strategy → copy → SEO audit
- Production: brief → script → storyboard → QC
- User mentions **crew**, **crewAI**, **multi-agent marketing**

**Skip** for single-step SEO audit (`seo-geo` route) or one-shot copy edit.

## Parallelism (DEC-004)

- Marketing crew: max 2 parallel (research + strategy prep only if independent)
- Default: **sequential** per crew JSON `process`

## Python crew (optional, client projects)

For standalone Python automation outside Cursor:

```shell
uv pip install crewai
crewai create crew my_project
```

Hub docs only — run in `C:\Users\Asus\projects\`, not in `.cursor`.

## Связи

- `skills/project-squad/reference/crew-ai-bridge.md`
- `skills/production-studio/SKILL.md`
- `skills/seo-geo/SKILL.md`
- `rules/crew-ai.mdc`
