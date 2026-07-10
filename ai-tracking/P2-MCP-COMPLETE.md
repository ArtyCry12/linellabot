# P2 Skills & Data — completion report

**Date:** 2026-07-10  
**Status:** P2 closed (with documented user-impact deferrals)

---

## Completed REQ (28 P2 items)

### Automation & system

| REQ | Item | Artifact |
|-----|------|----------|
| 004 | Task recognition | `auto-orchestrator.mdc` + P2 routes |
| 005 | Refresh pipeline | `commands/p2-refresh.ps1` + existing cursor-system-refresh |
| 076 | uv | ✅ 0.11.6 installed |
| 078 | Symbiosis | `SYMBIOSIS-AUDIT.md` |
| 079 | Pre-implementation | `PRE-IMPLEMENTATION-RULES.md` updated |
| 080 | SSOT | `SSOT-SYNC.md` + huashu-sync |

### MCP (011–014)

| REQ | Item | Artifact |
|-----|------|----------|
| 011 | shadcn full use | `design-stack` skill + 21st magic + plugin |
| 012 | iconify | `MCP-TOOL-STUDY.md` |
| 013 | context7 | `MCP-TOOL-STUDY.md` + mcp.json |
| 014 | Notion MCP | `notion-workspace` skill + rule + NOTION-TASK-UX |

### SEO (020–023)

| REQ | Item | Artifact |
|-----|------|----------|
| 020 | GSC auto | **Deferred** — `gsc-audit.STUB.md` (needs full Google OAuth) |
| 021 | SEO stack | `SEO-STACK.md` + npx lighthouse/htmlhint/eslint |
| 022 | AI SEO inspiration | Documented in SEO-STACK |
| 023 | GSC API / sitespeed | Stub + manual CSV path |

### Skills (025–029)

| REQ | Item | Artifact |
|-----|------|----------|
| 025 | Skills cleanup | `SKILLS-CLEANUP.md` (tiers, no mass delete) |
| 026–029 | Notion UX | skill + `NOTION-TASK-UX.md` |

### Subagents (032–038)

| REQ | Item | Artifact |
|-----|------|----------|
| 032–038 | Guardrails | `subagent-guardrails.mdc` + `templates/squad-handoff.md` |

### Notion (039–041)

| REQ | Item | Artifact |
|-----|------|----------|
| 039–041 | Structure + visibility | NOTION-TASK-UX + notion-workspace |

### Design (042–046)

| REQ | Item | Artifact |
|-----|------|----------|
| 042–045 | Stack manifest | `DESIGN-STACK-MANIFEST.md` + `design-stack` skill |
| 046 | Selling sites CRO | design-stack § CRO |

### Repos (060–064)

| REQ | Item | Artifact |
|-----|------|----------|
| 060–064 | Knowledge | `P2-REPOS.md` |

### Security (066–068)

| REQ | Item | Artifact |
|-----|------|----------|
| 066–068 | Awareness | `SECURITY-AI-CODING.md` + `ai-coding-security.mdc` |

### Learning (069–071)

| REQ | Item | Artifact |
|-----|------|----------|
| 069–071 | Prompt coach | `prompt-lessons/2026-07-10-*.md` + `PROMPT-HOOKS.md` |

---

## New commands

| Script | Purpose |
|--------|---------|
| `commands/seo-audit.ps1` | Lighthouse + PageSpeed report |
| `commands/p2-refresh.ps1` | Rules sync + skill index + P1 smoke |

---

## P1 tails (status)

| Item | Status |
|------|--------|
| Okara live audit | ✅ Done (moved to P3 REQ-059) |
| Reload Window (apify/magnific OAuth) | **User:** Reload once |
| Full Google Trio | **User:** `ensure-google-mcp.ps1` when needed |
| GSC auto | Blocked on OAuth |

---

## User impact needed

1. **Reload Window** — first connect apify + magnific OAuth  
2. **Optional:** Install VS Code **Project Manager** extension (REQ-061)  
3. **Optional:** Delete okara `example.com` test project  
4. **Optional:** Enable full Google Trio for GSC (REQ-020)

---

## Next: P3

Production Studio LVM · selling-sites video learning · REQ-006/007 system test post-reload

Run: `commands/p2-refresh.ps1`
