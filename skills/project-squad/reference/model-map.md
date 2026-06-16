# Project Squad — model map v2 (user-confirmed)

| Role | Agent file | Model slug | Token tier |
|------|------------|------------|------------|
| **Boss** | *(parent chat)* | `claude-opus-4-7-thinking-xhigh` | High |
| scout | `agents/squad-scout.md` | `composer-2.5-fast` | Low |
| architect | `agents/squad-architect.md` | `claude-4.6-sonnet-medium-thinking` | Medium |
| design | `agents/squad-design.md` | `claude-4.6-sonnet-medium-thinking` | Medium |
| build | `agents/squad-build.md` | `gpt-5.3-codex-high-fast` | High |
| qa | `agents/squad-qa.md` | `claude-4.6-sonnet-medium-thinking` | Medium |
| review | `agents/squad-review.md` | `gpt-5.5-medium` | Medium |
| growth | `agents/squad-growth.md` | `claude-4.6-sonnet-medium-thinking` | Medium |
| ship | `agents/squad-ship.md` | `claude-4.6-sonnet-medium-thinking` | Medium |
| memory | `agents/squad-memory.md` | `claude-4.5-haiku-thinking` | Low |
| cleanup | `agents/squad-cleanup.md` | `composer-2.5-fast` | Low |

## Rules

- Pass `model` to Task when spawning built-in subagent_types; for **custom** agents invoke by name: `Use the squad-scout subagent to …`
- Never two **High** tier agents on same files in parallel.
- Boss stays on Opus 4.7 only for orchestration — specialists do the work.
- Prefer custom `agents/squad-*.md` over generic Task types when both fit.

## Invocation modes

| Mode | When |
|------|------|
| **Custom subagent** | `squad-scout`, `squad-build`, … — visible in Cursor Subagents UI |
| **Task built-in** | `explore`, `shell`, `deployment-expert` — fallback if custom unavailable |
