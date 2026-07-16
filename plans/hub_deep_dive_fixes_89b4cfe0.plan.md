---
name: Hub Deep Dive Fixes
overview: "Post S1+S2 rebuild (Session 3): design matrix, route-echo, cleanup, dual-review, taxonomy, agency, digest — mostly DONE. Remaining optional: canvas ACTION_ITEMS + P3 backlog. No agents model lines, hooks.json, mcp secrets."
todos:
  - id: write-plan-md
    content: "plans/2026-07-16-hub-deep-dive-fixes.md (rebuilt Session 3)"
    status: completed
  - id: design-matrix
    content: "P0: full design matrix in squad-design + routes + design-stack"
    status: completed
  - id: route-echo
    content: "P0: rule-only echo Подключил in rules/task-router.mdc"
    status: completed
  - id: cleanup-safe
    content: "P0: hub-safe-cleanup dry-run → Apply (markitdown sacred)"
    status: completed
  - id: dual-review
    content: "P1: optional dual fanout in pr-review + squad-review protocol"
    status: completed
  - id: boss-guide
    content: "P1: Boss/Auto checklist in plan.md"
    status: completed
  - id: router-tests
    content: "P1: task-router-test + find-skills-test PASS"
    status: completed
  - id: taxonomy
    content: "P2: SYSTEM-TAXONOMY + skills-taxonomy-s2 ACTIVE/ON-DEMAND/ARCHIVE"
    status: completed
  - id: agency-ondemand
    content: "P2: agency rules alwaysApply false (66/66)"
    status: completed
  - id: chat-digest
    content: "P2: commands/chat-digest.ps1 without hooks.json"
    status: completed
  - id: deferred-checklist
    content: "P2: deferred refresh checklist in plan.md"
    status: completed
  - id: canvas-action
    content: "Optional: refresh canvas ACTION_ITEMS statuses"
    status: pending
  - id: final-summary
    content: "SESSION 3 COMPLETE marker + chat summary"
    status: completed
isProject: false
---

# Plan: Hub Deep Dive Fixes (rebuilt Session 3 · 2026-07-16)

## What changed since original plan

Sessions **1–2** already delivered find-skills wire, skills taxonomy/cleanup, MCP tiers, design + other Complement installs, LVM JSON, multi-commits.  
Session **3** closed remaining P0/P1/P2 from this plan (route-echo, design-stack matrix sync, cleanup Apply with markitdown protected, dual-review protocol, chat digest).

Authoritative execution record: [`plans/2026-07-16-hub-deep-dive-fixes.md`](plans/2026-07-16-hub-deep-dive-fixes.md) · re-audit: [`ai-tracking/SESSION-3-REAUDIT.md`](ai-tracking/SESSION-3-REAUDIT.md)

## Status board

| Priority | Item | Status |
|----------|------|--------|
| P0 | Design matrix (Stitch / shadcn / frontend-design / taste / impeccable / guidelines / huashu / …) | **DONE** |
| P0 | Route echo «Подключил: …» | **DONE** |
| P0 | Safe cleanup Apply (no markitdown unless opt-in) | **DONE** |
| P1 | Dual review optional | **DONE** |
| P1 | Boss/Auto guide | **DONE** |
| P1 | Router tests | **PASS** |
| P2 | Taxonomy | **DONE** |
| P2 | Agency on-demand | **DONE** |
| P2 | Chat digest | **DONE** |
| P2 | Deferred refresh checklist | **DONE** |
| Optional | Canvas ACTION_ITEMS | **OPEN** |
| P3 | Design refs / budget / Notion / model-map unlock | **BACKLOG** |

## Do not touch

- `hooks.json`, mcp secrets, markitdown venv  
- `agents/*.md` **model** lines / `model-map.md`  
- Client repos  

## Remaining optional work

1. Update canvas ACTION_ITEMS to match post-S2 reality (models-trim / explore already done by Boss).  
2. P3 backlog when Boss asks.

## Готово когда

- Rebuilt plan file exists  
- P0–P2 from original sprint closed or documented  
- Tests green  
- `SESSION 3 COMPLETE`
