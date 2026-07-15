# Studio Agent Roster (49 roles)

Agent prompts live at `.claude/agents/<name>.md` after bootstrap.

## Tier 1 — Directors (synthesis, gates)

| Agent | Domain |
|-------|--------|
| `creative-director` | Vision, design conflicts |
| `technical-director` | Architecture, technical conflicts |
| `producer` | Cross-department coordination, scope |

## Tier 2 — Department leads

| Agent | Domain |
|-------|--------|
| `game-designer` | Mechanics, systems, GDDs |
| `lead-programmer` | Engineering standards, delegation |
| `art-director` | Visual direction |
| `audio-director` | Audio direction |
| `narrative-director` | Story, lore |
| `qa-lead` | Test strategy |
| `release-manager` | Shipping |
| `localization-lead` | L10n |

## Tier 3 — Specialists (selection)

`gameplay-programmer`, `engine-programmer`, `ai-programmer`, `network-programmer`, `tools-programmer`, `ui-programmer`, `systems-designer`, `level-designer`, `economy-designer`, `technical-artist`, `sound-designer`, `writer`, `world-builder`, `ux-designer`, `prototyper`, `performance-analyst`, `devops-engineer`, `analytics-engineer`, `security-engineer`, `qa-tester`, `accessibility-specialist`, `live-ops-designer`, `community-manager`

## Engine packs (pick one set)

| Engine | Lead | Sub-specialists |
|--------|------|-----------------|
| Godot 4 | `godot-specialist` | `godot-gdscript-specialist`, `godot-shader-specialist`, `godot-gdextension-specialist`, `godot-csharp-specialist` |
| Unity | `unity-specialist` | `unity-dots-specialist`, `unity-shader-specialist`, `unity-addressables-specialist`, `unity-ui-specialist` |
| Unreal 5 | `unreal-specialist` | `ue-gas-specialist`, `ue-blueprint-specialist`, `ue-replication-specialist`, `ue-umg-specialist` |

## Team orchestration skills (multi-agent)

Spawn coordinated specialists for one feature:

`/team-combat`, `/team-narrative`, `/team-ui`, `/team-release`, `/team-polish`, `/team-audio`, `/team-level`, `/team-live-ops`, `/team-qa`

Each team skill defines phases, parallel spawn points, and review-mode gates.
