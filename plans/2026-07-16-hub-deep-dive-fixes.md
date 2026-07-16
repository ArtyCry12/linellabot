# Hub Deep Dive Fixes — rebuilt Session 3 (2026-07-16)

**Source:** canvas `hub-deep-dive-audit` + S1/S2 commits + `ai-tracking/SESSION-3-REAUDIT.md`  
**Cursor plan mirror:** `plans/hub_deep_dive_fixes_89b4cfe0.plan.md`

## Context after S1+S2

| Layer | Status |
|-------|--------|
| find-skills / skills.sh wire | **DONE** (S1 `e0548fc`) |
| Skills taxonomy + archive cleanup | **DONE** (S2) |
| MCP tiers (always/on-demand/archive) | **DONE** |
| Design skills install + routes | **DONE** (`127dd79`) |
| Other Complement installs + routes | **DONE** (`40e8c44`) |
| LVM image JSON | **DONE** |
| Agency alwaysApply off | **DONE** (66/66 false) |
| Route echo in `task-router.mdc` | **DONE** (S3) |
| Full design matrix in `design-stack.mdc` + squad-design | **DONE** (S3) |
| hub-safe-cleanup Apply (markitdown sacred) | **DONE** (S3) |
| Dual-review protocol | **DONE** (S3, optional) |
| Chat digest command | **DONE** (`commands/chat-digest.ps1`) |
| Canvas ACTION_ITEMS refresh | **OPEN** (optional polish) |
| P3 design-ref sites / budget / Notion | **BACKLOG** |

## Hard do-not-touch (unchanged)

- `hooks.json`
- `mcp.json` secrets
- markitdown venv / `.cache/markitdown` (unless `-IncludeMarkitdownCache`)
- `agents/*.md` **model** lines / `model-map.md` lock
- Client repos outside hub

## Design matrix (authoritative)

See `rules/design-stack.mdc` + `agents/squad-design.md` (routing only).

Handoff: `Applied: [skills…]` + anti-slop checklist.

## Boss / Auto checklist

| Task type | Model / mode |
|-----------|----------------|
| Plan / architecture / risky refactor | Opus thinking xhigh (manual) |
| Routine build / docs | Auto / Sonnet |
| Explore codebase | Composer 2.5 (UI Explore) |
| Avoid | Two High models editing same files |

## Todos (post-S3)

| ID | Item | Status |
|----|------|--------|
| design-matrix | Full design matrix | **DONE** |
| route-echo | Echo «Подключил: …» | **DONE** |
| cleanup-safe | dry → Apply; markitdown KEEP | **DONE** |
| dual-review | Optional GPT+Sonnet fanout | **DONE** (protocol) |
| boss-guide | This section | **DONE** |
| router-tests | task-router + find-skills | **PASS** |
| taxonomy | ACTIVE/ON-DEMAND/ARCHIVE | **DONE** (S2) |
| agency-ondemand | alwaysApply false | **DONE** |
| chat-digest | `commands/chat-digest.ps1` | **DONE** |
| canvas-action | Update ACTION_ITEMS statuses | **OPEN** |
| deferred-refresh | User runs deferred after Cursor exit | **CHECKLIST** |

## Deferred refresh (Boss after session)

1. Close Cursor  
2. `powershell -File commands/cursor-system-refresh-deferred.ps1`  
3. Reopen / Reload Window if hooks changed (S3 did **not** change hooks.json)

## P3 backlog

- 3 design-ref websites in canvas  
- Budget $/mo  
- Notion lesson publish  
- Sync model-map ↔ agents when Boss lifts `trust_manual`

## Готово когда (S3)

1. This plan exists and mirrors Cursor plan file  
2. Route-echo + design matrix + cleanup Apply + dual-review + digest + tests  
3. Re-audit written  
4. Marker `SESSION 3 COMPLETE`
