# Cursor Hub hygiene execution

Timestamp: 2026-09-08 (UTC+3)
Branch: `main`
Baseline commit: `fa3704fcf9586db647f8f88f8b4df5a602e07b73`

## Safety gates

- Cleanup commit and push were performed only after explicit Boss approval.
- No GitHub, Vercel, or Supabase mutation performed.
- KEEP paths are an exclusion allowlist.
- Cursor transcript-bearing stubs require backup before deletion.
- OpenRouter usage baseline: `$0.070568304`.

## Model route

- R2 activated: DeepSeek V4 Flash, GLM 5.3 Flash, DeepSeek V4 Pro, GLM 5.3.
- R3 was replaced by economical R2 at Boss direction.
- Stage 1 parallel classification completed with DeepSeek V4 Flash and GLM 5.3 Flash.
- Stage 1 measured spend: `$0.003300580`.
- DeepSeek V4 Pro initially rejected staging because tracked, disk-absence, and clean-index evidence was incomplete.

## Manifests

### 1. Tracked Asus deletions

- Pathspec: `:(glob)projects/c-Users-Asus-*/**`
- Tracked paths: `6535`
- Working-tree deletions: `6535`
- Missing on disk: `6535`
- Present on disk: `0`
- Non-deletion statuses in set: `0`
- KEEP collisions: `0`
- Sorted path-list SHA-256: `334053b3684a2c1f74338fbf70bb8207f5e313111bf14e4f570f52df0ac02d64`

Top groups:

- `c-Users-Asus-cursor-projects-Fast-Money`: 1365
- `c-Users-Asus-cursor`: 1120
- `c-Users-Asus-cursor-projects-kirill-bassiki`: 590
- `c-Users-Asus-cursor-projects-c-Users-Asus-cursor-InCruises`: 548
- `c-Users-Asus-cursor-projects-Next-Level-video`: 538
- `c-Users-Asus-cursor-AiManager-project`: 415
- `c-Users-Asus-cursor-InCruises`: 401
- `c-Users-Asus-cursor-neo-car-site2`: 397
- `c-Users-Asus-cursor-trust-wallet-copy`: 388
- `c-Users-Asus-cursor-site-cloner-skill`: 312
- `c-Users-Asus-cursor-ai-website-cloner-template`: 267
- Remaining five groups: 194

### 2. Archive-related shadow stubs

These contain MCP caches and Cursor history. They are not part of the Asus staging pathspec.

- `projects/c-Users-artyo-cursor-projects-notice-me-local-system`
- `projects/c-Users-artyo-cursor-projects-prodazhniki-spich-plan`
- `projects/c-Users-artyo-cursor-projects-marusyasteam-aichatbot-instagramm`
- `projects/c-Users-artyo-cursor-projects-c-Users-Asus-cursor-projects-Self-Education-Courses`

### 3. Independent dirty groups

- Canon: `AGENTS.md`, `CLAUDE.md`, `SYSTEM-TAXONOMY.md`, `.gitignore`, `.gitnexusignore`
- `commands/`
- `skills-cursor/`
- `lib/`
- `ai-tracking/projects-map.json`

These must not enter the Asus-deletion commit.

### 4. KEEP exclusions

- Home projects: `neo-car-site2`, `Mini-system-of-search-leads`, `InCruises`
- Cursor projects: `burgman-site`, `numina-site-translate`, `Pateo-terra-md-chat-bot`, `agency-site-prod`, `Insta-automization-messages`, `Rabotamd-Automization-bot`, `voice agent-project`, `nlmedia-ugc1-video`, `patio-terra-privacy`
- All `projects/c-Users-artyo-*` mirrors remain excluded from the Asus deletion stage.

## Execution results

- DeepSeek V4 Pro gate: `APPROVE_STAGE`.
- Staged set: 6535 deletions, zero unexpected paths, manifest hash matched.
- Cleanup committed as `0061222` (`chore(hub): remove legacy Asus project metadata`) and pushed to `origin/main`.
- Four archive-related shadow stubs were backed up and removed.
- Backup: `C:/Users/artyo/_archive/2026-09/cursor-stubs-hygiene-2026-09-08.zip`
- Backup contents: 1863 files, 7,792,396 uncompressed bytes.
- Backup SHA-256: `5fa6349a6d7109cb7f63eb6d41cf01d295529cb4eae1575b62590d3e906dff63`
- `projects/empty-window` retained: 365 files, eight transcript files, recent activity on 2026-09-08.
- UUID temp stub retained: 540 files, no transcripts, last activity on 2026-08-03.

## Independent-group review

GLM 5.3 classified the groups as follows:

- Canon/config portability: separate reviewed commit.
- `skills-cursor/`: separate sync commit after confirming the `babysit` deletion.
- Modified OpenRouter tests: separate tested commit.
- Untracked command scripts: retain untracked until reference and secret checks pass.
- `lib/ecc-src` and `lib/n8n-templates-src`: retain as nested libraries, never mass-stage.
- `ai-tracking/projects-map.json`: preserve because RESTORE docs reference it; handle in a separate commit.
- `agents/_archive/`: retain as archive after checking that live routing does not target it.

Governance fixes applied:

- Removed positive live routing to archived Project Squad roles.
- Updated stale GitNexus tool names to `detect_changes()`.
- Added `lib/LIBRARY-INDEX.md`.
- Regenerated `lib/task-router/capabilities.generated.json`: 80 routes, zero warnings.
- Capability index check and task-router contract test passed.
- Root `.cursorignore` already excludes `lib/ecc-src`.
- Added `lib/n8n-templates-src/` to root `.cursorignore` through an idempotent owner-authorized write after confirming OS Full Control and no ReadOnly attribute.
- `.cursorignore` backup: `C:/Users/artyo/_archive/2026-09/cursorignore-before-n8n-2026-09-08.bak`.
- Readback confirmed exactly one exclusion line. Cursor Reload Window is required for the index exclusion to take effect.

## Verification

- KEEP local paths: 12/12.
- Wave1 archive: 13/13.
- Archive-related shadow stubs remaining: 0.
- GitHub KEEP/archive/delete: 6/5/7.
- Hub counts: MCP 2, rules 40, active skills 19, hooks 10, active agents 8, archived agents 11, blocks 8.
- GitNexus structural check: clean, zero cycles.
- Unstaged GitNexus impact: low, 137 symbols, zero affected processes.
- Vercel verified read-only in the authenticated dashboard:
  - `flash-tokens-trust-mainnet-20260528`, `web`, and `self-education-courses` show `503 DEPLOYMENT_PAUSED` and `Resume Project`;
  - KEEP `neocar-site-main`, `burgman-site`, and `numina-site-translate` do not show the paused banner.
- Supabase verified read-only after manual Boss sign-in:
  - organization name is `NL Media`;
  - `nlmedia-melo` is active;
  - Self-Education ref `fxvadvghuazroltnhgaj` and `Trust-Wallet-Tokens` are paused;
  - Insta ref `nawwn…` is not available in the accessible organizations, as expected.

## Approval gates

- Boss explicitly approved commit, merge, and deploy.
- Cleanup commit is synchronized with `origin/main`; no merge was required because the branch was already `main`.
- No deploy was required because Cursor Hub has no applicable runtime deployment target.

## Final verdict

`COMPLETE`

- DeepSeek V4 Pro and GLM 5.3 independently returned `COMPLETE`.
- R1 parent integrated the local, GitHub, Vercel, Supabase, GitNexus, and model evidence.
- Total OpenRouter execution spend: `$0.082189406`, below the `$1.05` working limit.
- No unresolved verification blockers remain.
