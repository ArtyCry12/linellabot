---
name: game-studios-multiagent
description: >-
  Orchestrates indie game development with a 49-agent studio hierarchy (design,
  programming, art, audio, narrative, QA, production) adapted from Claude Code
  Game Studios. Use for @game-studios-multiagent, game studio multiagent, team-combat,
  brainstorm game, GDD, vertical slice, dev-story, gate-check, or bootstrapping a
  structured game project with parallel specialist agents in Cursor.
argument-hint: "[workflow e.g. start | team-combat melee parry | brainstorm cozy farming]"
user-invocable: true
---

# Game Studios Multiagent (Cursor)

Turn one Cursor session into a **structured game studio**: directors, department leads, and specialists — coordinated via the Task tool, not autonomous autopilot.

| Resource | Path |
|----------|------|
| Skill root | `C:/Users/Asus/.cursor/skills/game-studios-multiagent/` |
| Full template (49 agents, 73 workflows) | `.../template/` |
| Bootstrap | `node C:/Users/Asus/.cursor/skills/game-studios-multiagent/scripts/init-game-studio.mjs <dir>` |
| Source zip (optional) | `C:/Users/Asus/.cursor/skills-libraries/Claude-Code-Game-Studios-main ( multiagent ).zip` |

## Where work happens

All game artifacts (`design/`, `src/`, `assets/`, `production/`, `docs/`) belong in the **user's game project directory** — not inside this skill folder.

### Bootstrap (empty or non-studio workspace)

If the target has no `CLAUDE.md` + `.claude/agents/`:

```bash
node C:/Users/Asus/.cursor/skills/game-studios-multiagent/scripts/init-game-studio.mjs .
```

Then work in that directory. If already bootstrapped, skip init.

**Claude Code optional:** Native `/slash` skills and git hooks in `.claude/hooks/` work in Claude Code. In Cursor, follow the same skill files manually (see below).

---

## Collaboration protocol (non-negotiable)

**User-driven collaboration, not autonomous execution.**

Every task: **Question → Options → Decision → Draft → Approval**

- Ask before proposing solutions
- Present 2–4 options with pros/cons; user decides
- Show drafts before finalizing
- **Ask "May I write this to [filepath]?"** before Write/Edit on design or production docs
- No commits unless the user asks
- Multi-file changes need explicit approval for the full set

---

## Cursor ↔ Claude Code mapping

| Claude Code | Cursor |
|-------------|--------|
| `subagent_type: game-designer` | Task(`generalPurpose`, prompt includes full text from `.claude/agents/game-designer.md`) |
| `/brainstorm` | Read `.claude/skills/brainstorm/SKILL.md`, execute steps |
| Parallel subagents | Multiple Task calls in **one message** when inputs are independent |
| Agent teams (experimental) | Parallel Tasks + **separate git worktrees** per teammate when editing same repo |
| Hooks (`validate-commit.sh`, etc.) | Run checks manually when relevant; no auto-hook in Cursor |

### Spawning a studio role

1. Read `.claude/agents/<role>.md` (YAML frontmatter + body).
2. Task prompt must include: role body, file paths, constraints, collaboration protocol, and **return format** (deliverables only).
3. Parent agent synthesizes results; escalates conflicts per [coordination rules](#coordination).

### Parallel task protocol

When a workflow spawns independent roles (e.g. `/review-all-gdds` phases, `/team-combat` implementation):

1. Launch all independent Task calls before awaiting any
2. Collect results before dependent phases
3. Surface BLOCKED agents immediately; partial report if some complete
4. For file conflicts: one worktree per parallel implementer, merge at end

---

## Studio hierarchy

```
Directors:     creative-director | technical-director | producer
Leads:         game-designer | lead-programmer | art-director | audio-director
               narrative-director | qa-lead | release-manager | localization-lead
Specialists:   gameplay/engine/ai/network/ui programmers, designers, TA, audio, QA, …
Engine packs:  godot-* | unity-* | unreal-* / ue-*  (one set per project)
```

Escalation: design → `creative-director`; technical → `technical-director`; cross-domain → `producer`. Same-tier consult only — no binding cross-domain decisions.

Full roster: [reference/agent-roster.md](reference/agent-roster.md)

---

## Entry workflows

### First session → onboarding

Treat as `/start`:

1. Detect: engine in `.claude/docs/technical-preferences.md`, `design/gdd/game-concept.md`, `src/**`, `prototypes/`, `production/`
2. Ask where the user is: **no idea | vague idea | clear concept | existing work**
3. Route per `.claude/skills/start/SKILL.md` paths A–D
4. Set `production/review-mode.txt` (`full` | `lean` | `solo`) when appropriate

### User names a slash command

Example: "run `/team-combat` melee parry system"

1. Read `.claude/skills/team-combat/SKILL.md` (or named skill)
2. Resolve review mode: `--review` arg → `production/review-mode.txt` → default `lean`
3. Run phases; use AskQuestion (or conversational options) at each gate
4. Spawn agents per skill's pipeline

### User names a feature without a command

Pick the closest workflow from [reference/command-index.md](reference/command-index.md) or a `team-*` orchestrator.

---

## Seven-phase pipeline (summary)

| # | Phase | You are here when… |
|---|-------|-------------------|
| 1 | Concept | No `design/gdd/game-concept.md` |
| 2 | Systems design | Systems index exists; GDDs incomplete |
| 3 | Technical setup | No architecture ADRs / control manifest |
| 4 | Pre-production | No epics/stories or vertical slice |
| 5 | Production | Stories in progress |
| 6 | Polish | Feature-complete; tuning/QA |
| 7 | Release | Shipping |

Details: [reference/workflow-phases.md](reference/workflow-phases.md) · catalog: `.claude/docs/workflow-catalog.yaml`

**`/gate-check`**: advisory only — user chooses to proceed.

---

## Team orchestration (`team-*`)

Use when one feature spans design + code + art + audio + QA.

| Skill | Typical feature |
|-------|-----------------|
| `team-combat` | Combat mechanics end-to-end |
| `team-narrative` | Quests, dialogue, story beats |
| `team-ui` | Screens, HUD, flows |
| `team-audio` | Music/SFX integration |
| `team-level` | Level blockout + scripting |
| `team-polish` | Late-game feel pass |
| `team-qa` | Test plan + regression |
| `team-release` | Release candidate |
| `team-live-ops` | Events, seasons, economy live ops |

Pattern (from `team-combat`): design → architecture (+ engine specialist) → **parallel implement** → QA → optional director gates (`full` mode).

---

## Path-scoped rules

When editing files, apply matching `.claude/rules/*.md`:

| Path | Rule focus |
|------|------------|
| `src/gameplay/**` | Data-driven, delta time, no UI in gameplay |
| `src/core/**` | Hot-path allocations, thread safety |
| `src/ai/**` | Perf budgets, debuggability |
| `src/networking/**` | Server authority, versioned messages |
| `src/ui/**` | No game state ownership, a11y |
| `design/gdd/**` | 8 sections, formulas, edge cases |
| `tests/**` | Naming, coverage patterns |
| `prototypes/**` | Relaxed; README + hypothesis required |

---

## Project layout (after bootstrap)

```
CLAUDE.md
.claude/agents/          # 49 role prompts
.claude/skills/          # 73 workflow skills
.claude/rules/           # path-scoped standards
.claude/hooks/           # Claude Code automation
design/gdd/              # concepts + system GDDs
src/                     # game code
assets/                  # art, audio, data
production/              # stage, review-mode, epics, sprints
docs/                    # ADRs, architecture
tests/ prototypes/ tools/
```

---

## Design foundations (use in brainstorm/review)

- **MDA** — Mechanics, Dynamics, Aesthetics
- **SDT** — Autonomy, Competence, Relatedness
- **Flow** — challenge/skill balance
- **Bartle** — player type fit
- **Verification-driven** — acceptance criteria before implementation

---

## Coordination

From `.claude/docs/coordination-rules.md`:

1. Vertical delegation — don't skip tiers on complex decisions
2. Horizontal consultation — same tier, no cross-domain binding calls
3. Conflicts → shared parent or directors above
4. Multi-domain changes → `producer` coordinates
5. No edits outside domain without delegation

---

## Additional resources

- [reference/command-index.md](reference/command-index.md) — all 73 workflows
- [reference/agent-roster.md](reference/agent-roster.md) — full agent list
- [reference/workflow-phases.md](reference/workflow-phases.md) — phase gates
- Upstream: [Claude Code Game Studios](https://github.com/Donchitos/Claude-Code-Game-Studios) (MIT)

---

## Quick examples

**New project**

```text
@game-studios-multiagent bootstrap this folder and run studio onboarding
```

**Combat feature**

```text
@game-studios-multiagent /team-combat dodge-roll with i-frames
```

**Design only**

```text
@game-studios-multiagent /design-system inventory and crafting
```

Parent agent: read the skill file, spawn roles with Task, enforce approval gates, merge worktree branches if used.
