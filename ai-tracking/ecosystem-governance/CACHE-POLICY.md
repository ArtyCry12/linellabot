# Cache policy

Canon for hub auto-sweep. Owner: Ecosystem Architect. Command: `commands/cache-auto-sweep.ps1`.
Do **not** call `commands/cursor-system-cleanup.ps1` from auto-sweep (it moves repos, may `takeown`).

Cadence: Architect health ~10 days; Windows idle (T0) + nightly ~03:00 (T0+T1). Scheduled **Apply** needs a separate Boss YES after the first dry-run report.

## Tiers

**T0 — obvious junk (safe while working)**

- Hub probe files, numeric / Temp folders under hub `projects/` (via `hub-safe-cleanup.ps1`)
- Old plugin hash folders: keep 2 newest per plugin id
- `__pycache__`, `.pytest_cache` under hub + `C:\Users\artyo\projects`
- `coverage`, `.nyc_output`, `playwright-report`, `test-results` older than 3 days
- `%LOCALAPPDATA%\npm-cache\_logs` older than 14 days (not the npm store)
- `%APPDATA%\Cursor\logs` files/folders older than 30 days, skip today's session folder
- `%TEMP%` names matching Cursor/agent, older than 24 hours, skip locked

**T1 — cold build artifacts (nightly; T0 plus this)**

- `.next`, `.turbo`, `node_modules/.cache` of a project that is **not hot**

**T2 — Architect / 10-day, not auto**

- MarkItDown `.cache/markitdown` by age — opt-in `-IncludeMarkitdownCache` on hub-safe-cleanup only
- Safe temp under `.cache` except `security-hub`

**T3 — never auto**

- Secrets, `.env`, lockfiles, `mcp.json`
- Live project `node_modules` (except `.cache` under it, T1 cold only)
- `.venv*`, GitNexus index / parse-cache without a reindex plan
- npm-cache wholesale / `_npx` wipe
- Current plugin version, `plugins/cache` as a whole
- Electron `CachedData` while Cursor is running
- `dist/`
- Aikido lock residue Boss left as non-essential

## Hot rule (do not break local builds)

A project is **hot** if any of:

1. A live process command line contains its path
2. `package.json`, `.git\HEAD`, `.git\index`, or `src` / `app` / `pages` / `apps` / `components` was written in the last 7 days

Hot projects: never delete `.next`, `.turbo`, `node_modules/.cache`. T0 junk (pyc, old reports) is still allowed.

## Processes

Report-only: `node` / `next` / `vite` / `turbo` / Playwright Chromium. **Never kill.**
File: `ai-tracking/ecosystem-governance/reports/orphan-processes-last.json`

## Circuit breakers

- Default is dry-run (`-Apply` required to delete)
- Skip locked paths; no `takeown` / `-Force`
- If Cursor started less than 10 minutes ago: report only, no deletes
- Budget: 2 GB deleted per run (then stop)
- Time: T0 ≤90 s, T1 ≤10 min
- Logs: `ai-tracking/ecosystem-governance/reports/cache-sweep-YYYY-MM-DD.md` and `cache-sweep-last.json`
