# CrewAI bridge — Project Squad

Maps [crewAI](https://github.com/crewAIInc/crewAI) primitives to hub subagents.

## Crew → Subagent map

| CrewAI agent | Hub subagent | Primary skill |
|--------------|--------------|---------------|
| Marketing researcher | `squad-growth` | `seo-geo` |
| Content strategist | `squad-growth` | `agency-agents` (content-creator) |
| Copywriter | `squad-growth` | `awesome-prompts` |
| SEO auditor | `squad-growth` | `seo-geo` |
| Brief lead | `squad-design` | `production-studio` |
| Script / storyboard | `squad-design` | `production-studio` |
| Production QC | `squad-qa` | playbook + browser |

## Flow → Squad phases

| CrewAI flow step | Squad phase |
|------------------|-------------|
| Marketing research | Phase 7 (growth) entry |
| Production brief | Phase 3 (design) |
| Production QC | Phase 6 (qa) |

## Boss invocation

```
1. powershell -File commands/crew-plan.ps1 -Crew marketing -Topic "<topic>"
2. For each step: Use the squad-growth subagent to ...
3. Pass handoff: objective, findings, open loops (crewAI task output contract)
```

## Gates (from crew JSON)

- `publishRequiresApproval: true` — always
- `noAutoSocialPublish: true` — production crew
