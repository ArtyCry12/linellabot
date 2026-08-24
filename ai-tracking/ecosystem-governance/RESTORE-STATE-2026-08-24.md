# Restore state — chat 66e654e8

**Restored:** 2026-08-24 from `exports/chat-66e654e8/FULL.md` + `subagent-*.md` + disk `ai-tracking/phase1-db/`.  
**Not used:** Past Chats UI for this UUID (missing blobs).

## Timeline (what the broken chat actually did)

| When | Track | Status |
|------|--------|--------|
| 2026-08-15 | Hub Load Optimization phases 0–5 | **Done** |
| 2026-08-15 | Closeout (plugins UI, Asus paths, cursorignore, GitNexus, Notion script) | **Done** (plan todos completed) |
| 2026-08-15 | GitNexus FTS repair attempt + dual-rules note | **Partial** (impact works; FTS still weak on Windows) |
| 2026-08-17 | Phase 1 Customize DB (inventory only) | **Done on disk**; chat died mid parent-fill |
| 2026-08-17 turn 307 | Workspace Disconnected → Conversation data missing | **Broken chat end** |

## Crash point

Parent was filling `plugins.json` / `junk-candidates.json` after some collectors errored. On disk today those files **exist** and `INDEX.md` + plan todos say **complete**. Boss-facing summary in chat never landed.

## Decisions already locked (do not re-ask unless conflict)

From hub-load + closeout:

- Live MCP profiles via `mcp-profile.ps1`; store = full catalog; bak = rollback.
- GitNexus heap **1536** in live; do not restore 4096 via careless full profile from old store without fixing store heap first.
- Do **not** delete hub `skills/` wholesale; slim `_INDEX.md` instead of deleting trees.
- Keep Task Router, Squad, MarkItDown hook, RTK, user-profile, memory MCP, GitNexus name `linellabot`.
- Zapier / GitLab / Harness: off in UI (verify after Reload).
- Aikido / Exa / team-kit: keep.
- Asus paths: fixed in 5 rules only; 34 skill files with Asus left alone.
- Dual `rules/` + `.cursor/rules/`: keep both; sync via huashu script.
- Phase 1 Customize: **candidates only**, no deletes applied.

## Live drift vs Phase 1 snapshot (2026-08-24 check)

| Item | Phase 1 (2026-08-17) | Now |
|------|----------------------|-----|
| Live MCP | design ×6 | **Same** design ×6 |
| Heap | 1536 | 1536 |
| Hub top-level `SKILL.md` dirs | (index 112) | **86** dirs with `SKILL.md` at `skills/<name>/` |
| Always-on hub rules | 7 | ~8 (`alwaysApply: true` hits) |
| Hub agents | 16 | 16 |
| Ecosystem Architect agent | absent | **still absent** |
| Quarantine tree | absent | **still absent** |
| MASTER target arch docs | absent | this folder (new) |

## Artifacts to trust

| Path | Role |
|------|------|
| `ai-tracking/phase1-db/INDEX.md` | Layer counts + stop gate |
| `ai-tracking/phase1-db/architecture.md` | Disk vs Customize vs hub docs |
| `ai-tracking/phase1-db/phase2-candidates.json` | Safe cleanup candidates (not applied) |
| `ai-tracking/phase1-db/verify-log.md` | Gaps / contradictions |
| `SYSTEM-VISIBILITY-MAP.md` | Hub-load map (partially stale vs design profile) |
| `plans/hub_load_optimization_40d45cab.plan.md` | Load optimization plan |
| `plans/phase_1_customize_db_55609dcf.plan.md` | Phase 1 plan (todos completed) |
| `plans/hub-followup-closeout.md` | Closeout (completed) |

## What remained unfinished at crash

1. Boss summary of Phase 1 in chat (counts / junk / stop).
2. Explicit **go / no-go** for Phase 2 candidates.
3. MASTER PROMPT track (architecture rebuild & governance) — **not started** as a governed program; only inventory exists.

## Do-not-touch (carry forward)

Task Router · Squad · MarkItDown · RTK · user-profile · memory MCP · GitNexus index `linellabot` · live secrets / `mcp.json` commits · wholesale skill deletion without quarantine+approval.
