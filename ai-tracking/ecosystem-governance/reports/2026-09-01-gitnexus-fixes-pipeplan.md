# Fixes pipeplan — GitNexus reindex reliability (2026-09-01)

**Status:** LOCK — implementer starts immediately  
**Parent verifies:** boss agent after implementer (not implementer)  
**Hub:** `C:\Users\artyo\.cursor`  
**Do not commit. Do not push.**

## Context (incident)

Failed runs (2026-09-01):

| Run | Exit | Cause |
|-----|------|--------|
| 113863 | 1 | Parse phase: worker timeout on `impeccable/scripts/lib/surface-briefs.mjs`, `target-args.mjs`; circuit breaker |
| 113864 | 3221226505 | Same family on `template-extensions.mjs`, `live-accept.mjs`; process crash |
| 113867/113869 | shell timeout | `status` OK; wrapper marked failed |
| 113870 | shell timeout | analyze succeeded ~188s; wrapper marked failed |

Successful mitigation already on disk: `.gitnexusignore` excludes `blocks/design/skills/impeccable/scripts/`, `skills/_quarantine/`, `skills/skills-main-top-coding/`. Index was up-to-date at `7db6b88` after skip.

**Goal:** make reindex **repeatable** and **verifiable** without parent guessing. No Matt-adapter changes.

## Never

- Commit / push
- Re-run full `gitnexus-reindex.ps1` unless `gitnexus-test.ps1` reports stale (saves ~3–5 min)
- Touch `blocks/dev-os/skills/{grill-rounds,wayfinder,project-context}`
- Touch `lib/task-router/routes.json` except if test needs a one-line doc reference (prefer not)
- Remove `.gitnexusignore` exclusions without documenting hang file
- Patch global npm `gitnexus` for DEP0190

## Deliverables

### 1. Incident report (read-only archive)

**NEW** `ai-tracking/ecosystem-governance/reports/2026-09-01-gitnexus-reindex-incident.md`

- Table of failed runs + root cause (parse hang on impeccable scripts)
- Current `.gitnexusignore` exclusions with rationale
- Note: Cursor shell may mark long jobs `error` while analyze succeeds — not index corruption
- Link: `commands/gitnexus-test.ps1` as gate

### 2. Health test script

**NEW** `commands/gitnexus-test.ps1`

Pattern: `commands/rtk-test.ps1`, `commands/mcp-health.ps1`.

Checks (fail = exit 1):

1. `.gitnexus/run.cjs` exists
2. `node .gitnexus/run.cjs status` → parses "up-to-date" OR stale with indexedAt within doc tolerance; print indexed commit vs HEAD
3. `.gitnexusignore` contains required lines (substring match):
   - `blocks/design/skills/impeccable/scripts/`
   - `skills/_quarantine/`
   - `skills/skills-main-top-coding/`
4. Write `ai-tracking/gitnexus-health.json` with: `ok`, `indexedAt`, `indexedCommit`, `headCommit`, `stale`, `ignoreOk`, `timestamp`
5. If stale: print hint `powershell -File commands/gitnexus-reindex.ps1` and exit 1

Optional `-Json` switch like mcp-health.

### 3. Harden reindex script

**EDIT** `commands/gitnexus-reindex.ps1`

Minimal diff:

- Print expected duration (~3–5 min hub)
- Record start/end timestamps
- On non-zero exit: print last 20 lines of stderr if captured; exit with same code
- After success: call `gitnexus-test.ps1` (or inline same status check) — fail reindex if test fails
- Keep `--skip-agents-md --skip-skills`, `NODE_OPTIONS=4096`

Do not add parallel analyze runs.

### 4. Registry / discoverability

**EDIT** `SYSTEM-REGISTRY.md` — one row in commands/GitNexus section:

- `commands/gitnexus-test.ps1` — index freshness + ignore canon gate
- `commands/gitnexus-reindex.ps1` — rebuild (after Reload if MCP RAM heavy)

**EDIT** `ai-tracking/ecosystem-governance/registry.json` — bump `updatedAt`; optional `gitnexus` block:

```json
"gitnexus": {
  "test": "commands/gitnexus-test.ps1",
  "reindex": "commands/gitnexus-reindex.ps1",
  "ignore": ".gitnexusignore",
  "lastIncident": "ai-tracking/ecosystem-governance/reports/2026-09-01-gitnexus-reindex-incident.md"
}
```

### 5. Cross-ref adapters plan

**EDIT** `ai-tracking/ecosystem-governance/reports/2026-09-01-mattpocock-adapters-plan.md`

Add under Remediation closeout one line: GitNexus gate → this pipeplan + `gitnexus-test.ps1`.

## Verify (implementer runs)

```powershell
powershell -NoProfile -File commands/gitnexus-test.ps1
```

Exit 0 required. If stale only, run reindex once then test again.

Do **not** add gitnexus-test to task-router-test (unrelated).

## Parent verification (after implementer)

Boss agent runs:

1. Read all deliverable paths exist
2. `powershell -File commands/gitnexus-test.ps1` → exit 0
3. `gitnexus-health.json` fresh timestamp today
4. Incident md mentions impeccable hang + false shell errors
5. No edits to Matt adapter skills

Report: `READY_TO_COMMIT` only if all pass; else numbered MISS list.

## Ponytail

One test script, one incident md, small reindex.ps1 diff. No new agents, no WBS file.
