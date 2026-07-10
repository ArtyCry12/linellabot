# Hermes skill catalog (bundled)

Source: `hermes-agent-main/skills/` + `optional-skills/`. Install into Cursor:

```bash
node C:/Users/Asus/.cursor/skills/hermes-agent/scripts/install-cursor-skills.mjs <name>
node C:/Users/Asus/.cursor/skills/hermes-agent/scripts/install-cursor-skills.mjs --list
```

## software-development (12) — start here

| Skill | Focus |
|-------|-------|
| `writing-plans` | Implementation plans before coding |
| `subagent-driven-development` | Plan execution via delegated subagents |
| `test-driven-development` | Red-green-refactor |
| `systematic-debugging` | Reproduce → minimize → fix |
| `requesting-code-review` | Pre-merge review checklist |
| `plan` | Lightweight planning |
| `spike` | Time-boxed exploration |
| `python-debugpy` | Python debugger attach |
| `node-inspect-debugger` | Node inspect workflows |
| `debugging-hermes-tui-commands` | Hermes TUI debugging |
| `hermes-agent-skill-authoring` | Author Hermes SKILL.md files |
| `hermes-s6-container-supervision` | Container supervision (Hermes Docker) |

## autonomous-ai-agents (5)

| Skill | Focus |
|-------|-------|
| `hermes-agent` | CLI, gateway, profiles, tools |
| `claude-code` | Claude Code integration patterns |
| `codex` | OpenAI Codex patterns |
| `opencode` | OpenCode patterns |
| `kanban-codex-lane` | Kanban + Codex worker lane |

## devops (3)

`kanban-orchestrator`, `kanban-worker`, `webhook-subscriptions`

## productivity (9)

Browse with `--list`; includes note-taking and workflow helpers.

## mlops (9)

Training, vector DBs, DSPy research modules.

## creative (20)

TouchDesigner, media pipelines, concept work.

## github (6)

GitHub automation and repo workflows.

## research (5)

Literature and investigation workflows.

## Other categories

`apple`, `data-science`, `email`, `gaming`, `mcp`, `media`, `note-taking`, `red-teaming`, `smart-home`, `social-media`, `yuanbao`, `dogfood`

## optional-skills (not in default bundle)

Heavier or niche — same install script searches `optional-skills/`:

- `honcho` — cross-session user modeling (pairs with Hermes CLI)
- `openhands`, `blackbox` — external agent frameworks
- `kanban-video-orchestrator` — multi-agent video pipeline
- `page-agent`, blockchain, health, web-development, communication, …

Run `install-cursor-skills.mjs --list` for the full discovered set from your extracted copy.
