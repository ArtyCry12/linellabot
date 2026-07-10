# Game Studios — 7-Phase Pipeline

Authoritative source in bootstrapped projects: `.claude/docs/workflow-catalog.yaml`

| Phase | Goal | Key workflows |
|-------|------|----------------|
| **1. Concept** | Idea → documented concept | `/brainstorm`, `/setup-engine`, `/art-bible`, `/map-systems` |
| **2. Systems design** | GDD per MVP system | `/design-system`, `/review-all-gdds`, `/gate-check` |
| **3. Technical setup** | Architecture + ADRs | `/create-architecture`, `/architecture-decision`, `/create-control-manifest` |
| **4. Pre-production** | UX + vertical slice | `/ux-design`, `/vertical-slice`, `/create-epics`, `/create-stories` |
| **5. Production** | Implement stories | `/dev-story`, `/sprint-plan`, `/sprint-status` |
| **6. Polish** | Balance, perf, QA | `/balance-check`, `/perf-profile`, `/regression-suite` |
| **7. Release** | Ship | `/release-checklist`, `/launch-checklist`, `/changelog` |

**Gate checks** (`/gate-check`) are advisory — user decides whether to advance.

**Review modes** (`production/review-mode.txt`): `full` | `lean` | `solo` — controls director gate spawning in team workflows.

**Stage file**: `production/stage.txt` — update when completing a phase; `/help` logic uses artifact globs from workflow-catalog.
