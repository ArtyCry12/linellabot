# Profiles and personas

## SOUL.md (primary identity)

- Lives at project root (Cursor bootstrap) or `~/.hermes/SOUL.md` (Hermes CLI global)
- Defines **who the agent is** — tone, values, boundaries, communication style
- Reloaded each message in Hermes; in Cursor, treat as authoritative for the project
- Empty or deleted → default Hermes/Cursor behavior

Template: `../template/SOUL.md`

### Good SOUL.md patterns

```markdown
# Research assistant

- Lead with sources and uncertainty bounds.
- Never fabricate citations.
- Ask before writing to disk outside docs/research/.
```

```markdown
# Staff engineer

- Prefer minimal diffs; explain tradeoffs in one paragraph.
- Run tests before claiming done.
- No force-push, no commits unless asked.
```

## /personality (tone overlay)

Hermes CLI command — lightweight overlay on top of SOUL:

```
/personality none      # clear overlay
/personality <name>    # predefined or custom from config
```

**Cursor equivalent:** short-lived instruction in chat, or a `.cursor/rules/*.mdc` file with `alwaysApply: false` and a glob scope.

## Profiles (isolated agent instances)

Hermes CLI:

```bash
hermes profile create coder
hermes profile create writer --clone-from default
hermes -p coder
```

Each profile directory (`~/.hermes/profiles/<name>/`):

| File / dir | Purpose |
|------------|---------|
| `config.yaml` | Model, tools, display |
| `SOUL.md` | Profile-specific persona |
| `skills/` | Profile-local skills |
| `sessions/` / `state.db` | Isolated history |
| `.env` | Profile API keys (optional) |

### Cursor-only profile pattern

When Hermes CLI is not installed:

1. **Per-project** — different repos get different `SOUL.md` + `AGENTS.md`
2. **Per-worktree** — `git worktree add ../project-coder -b agent/coder` + bootstrap each
3. **Per-rule-set** — `.cursor/rules/coder.mdc` vs `researcher.mdc` with globs

## Memory layers

| Layer | File / tool | Content |
|-------|-------------|---------|
| Procedural | Skills (`SKILL.md`) | How to do repeatable workflows |
| Episodic | Session DB / agentmemory | What happened in past sessions |
| Semantic | `MEMORY.md`, Honcho | Facts about user and environment |
| Workspace | `AGENTS.md` | Repo-specific durable facts |

**Rule:** one primary semantic memory backend per setup — avoid conflicting `MEMORY.md`, Honcho, and agentmemory without clear scope split.

## Migrating from OpenClaw

```bash
hermes claw migrate --dry-run
hermes claw migrate
```

Imports: SOUL.md, memories, skills → `~/.hermes/skills/openclaw-imports/`, API keys, platform config.

Cursor: run migrate on Hermes CLI, then `install-cursor-skills.mjs` for skills you want in Cursor too.
