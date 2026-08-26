# Deep-dive hub integrity — 2026-08-26

## Scope
Full architecture/path audit after blocks split: Task Router, sync, ensure-open-design, canon docs, MCP profiles, project leftovers.

## Fixed
| Area | Change |
|------|--------|
| `routes.json` | memory → `blocks/dev-os` (no live Squad); automation-audit → `repo-intake`; agency/site-compliance/n8n docs → `blocks/` |
| `ensure-open-design.ps1` | Dest → `blocks/design/skills/open-design/repo` |
| Sync | `cursor-sync-workspace-rules.py` mirrors `blocks/*/rules/*.mdc` → `rules/` each run; ASCII print (cp1251-safe) |
| Canon | AGENTS / CLAUDE / REGISTRY / VISIBILITY / USER-RULES — block paths |
| Orchestrator / mcp-routing | block skill paths; descriptors `c-Users-artyo-cursor` |
| Projects | removed 13 leftover `project-squad.mdc` |
| Commands | sync-*-mcp + generate-agency-index + build-combined-notion → artyo |
| MCP profiles | live = core/design/qa/ops only; `docs`/`full` → `profiles/_archive/`; sentry URL stripped from example-full |
| GitNexus ignore | added `blocks/design/skills/open-design/repo/` |

## Verify
- Route skill/rule/docs paths: **0 missing**
- Task Router sample: **11/11 matched**
- Sync: **38 rules → 11 workspace roots**
- Stubs always-on: **8**
- Adversarial (paths/Dest): **PASS**; residuals cleaned (profiles + sentry)

## Intentional residual
- `skills/huashu-design/SKILL.md` — thin legacy discovery bridge → open-design (not a second design stack)

## Adversarial
Prior: [PASS-WITH-RESIDUALS](a06f4844-e119-4e70-a789-720c0276c5c3). Residuals 1–2–4 addressed in this report; #3 bridge kept by policy.
