# Naming / structure dry-run (NO FIXES beyond approved session scope)

**Date:** 2026-08-26  
**Policy:** inventory only for mass rename. Mass rename **after** this session only if Boss says yes.  
**Already fixed in-session (approved):** sync rename + Asus hardcode removed from sync; CLAUDE/AGENTS/orchestrators → real open-design paths; huashu skill/rule → bridge stubs; nested `.cursor/.cursor/.cursor` quarantined to trash-candidates.

## A. Intentional leftovers

| Item | Why keep |
|------|----------|
| `@huashu` alias | Boss legacy |
| `huashu-sync-workspace-rules.py` shim | Compat |
| `skills/_archive/huashu-design/` | Archive |
| `huashu-design-USER-RULES.txt` stub | Restore docs |

## B. Residual naming debt (POST-SESSION if Boss yes)

| Area | Examples |
|------|----------|
| `commands/*.md` docs | clone-website.md, seo-geo.md, foundation-refresh.md, stitch-mcp.md still Asus paths |
| `commands/install-agency-agents.ps1`, `hub-supply-scan.ps1`, `bumblebee-scan.ps1`, `cursor-system-cleanup.ps1`, `cursor-system-audit.ps1` | Asus roots |
| `commands/prompt-lesson-tts.ps1` | huashu voiceover fallback path |
| Prose in `blocks/design/skills/*` | many “huashu” mentions in skill bodies |

## C. Asus path debt outside sync (POST-SESSION)

Listed under B. Sync script itself: **clean**.

## D. Session verification

| Check | Result |
|-------|--------|
| Sync Asus hardcode | absent |
| Sync run | 23→11 workspaces; hub skipped |
| Prompt coach Flags test | OK |
| Nested rules dump | moved to `ai-tracking/trash-candidates/nested-cursor-rules-20260826/` |
| open-design path in AGENTS/CLAUDE | `blocks/design/skills/open-design/SKILL.md` |
