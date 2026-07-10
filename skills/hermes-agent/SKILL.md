---
name: hermes-agent
description: >-
  Personalized self-improving agents from Nous Research Hermes Agent — SOUL.md
  personas, profiles, cross-session memory, skill catalog, delegation, and gateway
  patterns adapted for Cursor. Use for @hermes-agent, Hermes Agent, personalized
  agent, SOUL.md, hermes profile, self-improving skills, Honcho memory, or
  bootstrapping a persistent agent identity in a project.
argument-hint: "[workflow e.g. install | persona | import-skill writing-plans | delegate plan.md]"
user-invocable: true
---

# Hermes Agent (Cursor)

Adapt [Hermes Agent](https://github.com/NousResearch/hermes-agent) — the self-improving agent with a closed learning loop — for Cursor sessions. Two layers:

| Layer | What it gives you |
|-------|-------------------|
| **Hermes CLI** (optional) | Full autonomous agent: profiles, gateway (Telegram/Discord/…), cron, curator, kanban |
| **Cursor adaptation** (this skill) | Personas, memory, skill catalog, and delegation workflows inside Cursor |

| Resource | Path |
|----------|------|
| Skill root | `C:/Users/Asus/.cursor/skills/hermes-agent/` |
| Source library | `C:/Users/Asus/.cursor/skills-libraries/hermes-agent-main (!!  personalized-agents !! ).zip` |
| Extracted source (fallback) | `C:/Users/Asus/.cursor/skills-libraries/_extract-hermes-agent/hermes-agent-main/` |
| Bootstrap | `node C:/Users/Asus/.cursor/skills/hermes-agent/scripts/init-hermes-workspace.mjs <dir>` |
| Install Hermes skill → Cursor | `node C:/Users/Asus/.cursor/skills/hermes-agent/scripts/install-cursor-skills.mjs <skill-name>` |

## When to use

- User wants a **persistent agent identity** (tone, values, boundaries) via `SOUL.md`
- User wants **multiple personas** (coder vs researcher vs ops) — Hermes profiles or Cursor rules
- User asks to **import Hermes skills** into Cursor (`writing-plans`, `systematic-debugging`, …)
- User wants **cross-session memory** (pair with `@agentmemory` / Honcho when running Hermes CLI)
- User wants **multi-agent delegation** (Hermes `delegate_task` → Cursor `Task` tool)
- User says **install Hermes**, **hermes gateway**, **hermes profile**, **personalized agent**

**Not for:** one-off coding with no persona/memory — skip this skill.

---

## Quick start (Cursor-only personalization)

### 1. Bootstrap project workspace

```bash
node C:/Users/Asus/.cursor/skills/hermes-agent/scripts/init-hermes-workspace.mjs .
```

Creates in the target directory:

- `SOUL.md` — agent persona (edit freely; loaded as project context)
- `AGENTS.md` snippet merge hint (if no `AGENTS.md` yet, seeds `AGENTS.hermes.md`)
- `.cursor/rules/hermes-persona.mdc` — optional rule hook for persona consistency

### 2. Edit persona

Open `SOUL.md`. Examples:

```markdown
You are a concise senior engineer. Lead with decisions, then rationale.
Ask before destructive git ops. Prefer surgical diffs.
```

### 3. Import a Hermes workflow skill into Cursor

```bash
node C:/Users/Asus/.cursor/skills/hermes-agent/scripts/install-cursor-skills.mjs writing-plans
node C:/Users/Asus/.cursor/skills/hermes-agent/scripts/install-cursor-skills.mjs systematic-debugging
```

Installed to `~/.cursor/skills/<name>/SKILL.md` (agentskills.io-compatible frontmatter preserved).

Browse catalog: [reference/skill-catalog-index.md](reference/skill-catalog-index.md)

---

## Quick start (full Hermes CLI)

Windows (native, early beta):

```powershell
iex (irm https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.ps1)
```

Linux / macOS / WSL:

```bash
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
```

Then:

```bash
hermes setup          # wizard: model, tools, gateway
hermes model          # pick provider
hermes                # interactive CLI
hermes gateway start  # Telegram, Discord, Slack, …
```

Full CLI reference: [reference/hermes-cli-reference.md](reference/hermes-cli-reference.md)

---

## Personalized agent model

Hermes personalizes through **four layers**. Map each to Cursor:

| Hermes | Purpose | Cursor equivalent |
|--------|---------|-------------------|
| `SOUL.md` | Core identity & tone | Project `SOUL.md` + optional `.cursor/rules/hermes-persona.mdc` |
| `/personality` | Session tone overlay | User Rules or short rule file per session |
| Profiles (`hermes -p NAME`) | Isolated configs, skills, memory | Separate `~/.hermes/profiles/<name>/` **or** git worktrees + per-worktree `AGENTS.md` |
| Memory (`MEMORY.md`, Honcho) | Cross-session user model | `AGENTS.md` learned facts, `@agentmemory`, or `hermes memory` when CLI installed |

Details: [reference/profiles-and-personas.md](reference/profiles-and-personas.md)

### Self-improving loop (Hermes-native)

When Hermes CLI is installed:

1. Agent completes a complex task → may **create a skill** (`skill_manage` / curator)
2. **Curator** tracks usage, archives stale agent-authored skills
3. **Session search** (FTS5) recalls past conversations
4. Skills load via `/skill <name>` or `hermes -s <name>`

In Cursor: after solving a repeatable workflow, offer to **save a Cursor skill** (`@create-skill`) — same procedural-memory idea.

---

## Cursor ↔ Hermes mapping

| Hermes | Cursor |
|--------|--------|
| `delegate_task(goal, context)` | `Task(subagent_type="generalPurpose", prompt=…)` with full task text inline |
| `hermes chat -q "…"` spawn | `Task` or `hermes chat -q` in terminal for fire-and-forget |
| `hermes -w` worktree | `git worktree` + separate Cursor window |
| `/skill name` | `@name` or Read `~/.cursor/skills/<name>/SKILL.md` |
| `hermes profile create` | `init-hermes-workspace.mjs` per project + profile-specific `SOUL.md` |
| Kanban multi-worker | Parallel `Task` calls + [subagent-driven-development](reference/workflows.md) |
| Gateway `/personality` | Edit `SOUL.md` or User Rules |
| `hermes cron` | Cursor Automations (`@automate`) or external cron hitting webhook |

Full mapping: [reference/cursor-mapping.md](reference/cursor-mapping.md)

---

## Recommended Hermes skills for Cursor users

Import these first (software-development + autonomous-ai-agents):

| Skill | Use when |
|-------|----------|
| `writing-plans` | Multi-step implementation needs a plan file first |
| `subagent-driven-development` | Execute plan via delegated subagents with review gates |
| `test-driven-development` | Bugfix or feature with regression safety |
| `systematic-debugging` | Flaky failures, unknown root cause |
| `requesting-code-review` | Pre-merge quality pass |
| `hermes-agent` | Configure or troubleshoot Hermes CLI itself |

```bash
node C:/Users/Asus/.cursor/skills/hermes-agent/scripts/install-cursor-skills.mjs writing-plans
node C:/Users/Asus/.cursor/skills/hermes-agent/scripts/install-cursor-skills.mjs subagent-driven-development
```

---

## Delegation workflow (Cursor)

Adapted from Hermes `subagent-driven-development`:

1. **Read plan once** — parent extracts all tasks; subagents never read the plan file
2. **Todo list** — track tasks in Cursor todos
3. **Per task** — `Task` with: full task text, file paths, TDD steps, return format
4. **Two-stage review** — spec compliance, then code quality (parent or `code-reviewer` Task)
5. **Serialize or parallelize** — parallel only when tasks touch disjoint files

Workflow detail: [reference/workflows.md](reference/workflows.md)

---

## Multi-profile setups

### Hermes CLI profiles

```bash
hermes profile create coder --clone
hermes profile create researcher --clone
hermes -p coder          # isolated skills, memory, sessions
```

Each profile: `~/.hermes/profiles/<name>/` with own `SOUL.md`, `config.yaml`, `skills/`.

### Cursor-only profiles (no CLI)

| Profile | Setup |
|---------|-------|
| **Coder** | `SOUL.md` + strict lint/build rules in `.cursor/rules/` |
| **Researcher** | Lighter rules, `@seo-geo` / web skills, no write without approval |
| **Ops** | `AGENTS.md` with deploy/cron facts; terminal-heavy |

Use **separate git worktrees** when two profiles edit the same repo concurrently.

---

## Memory integration

| Backend | Best for |
|---------|----------|
| Hermes built-in | `MEMORY.md` + user profile when CLI installed |
| [Honcho](https://github.com/plastic-labs/honcho) | Dialectic user modeling across profiles (`hermes honcho setup`) |
| [agentmemory](https://github.com/) | Cursor session recall (`@recall`, `@remember`) |
| `AGENTS.md` | Durable workspace facts (already in this repo pattern) |

Do not duplicate memory stores — pick one primary backend per project.

---

## Collaboration protocol

When acting as a personalized agent in Cursor:

1. **Honor `SOUL.md`** — tone and boundaries override generic defaults
2. **Ask before identity changes** — editing `SOUL.md`, User Rules, or profile split
3. **Persist learnings** — offer `@remember` or `AGENTS.md` update after durable outcomes
4. **Skills over improvisation** — load imported Hermes skill before inventing workflow
5. **No commits/deploy** unless user explicitly requests (matches project `AGENTS.md`)

---

## Additional resources

- [reference/skill-catalog-index.md](reference/skill-catalog-index.md) — 90+ bundled skills by category
- [reference/profiles-and-personas.md](reference/profiles-and-personas.md) — SOUL, personality, profiles
- [reference/cursor-mapping.md](reference/cursor-mapping.md) — tool-by-tool mapping
- [reference/workflows.md](reference/workflows.md) — delegation, TDD, debugging
- [reference/hermes-cli-reference.md](reference/hermes-cli-reference.md) — full CLI (from upstream skill)
- Docs: https://hermes-agent.nousresearch.com/docs/
- Upstream: https://github.com/NousResearch/hermes-agent (MIT)

---

## Examples

**Bootstrap persona in current project**

```text
@hermes-agent bootstrap persona for a terse staff-engineer agent
```

**Import planning workflow**

```text
@hermes-agent install writing-plans and subagent-driven-development into Cursor skills
```

**Run Hermes alongside Cursor**

```text
@hermes-agent help me create a "researcher" profile and connect Telegram gateway
```

**Delegate a plan**

```text
@hermes-agent execute docs/plans/auth-refactor.md using subagent-driven-development
```

Parent agent: read this skill, run bootstrap/install scripts when needed, honor `SOUL.md`, map Hermes patterns to Cursor tools.
