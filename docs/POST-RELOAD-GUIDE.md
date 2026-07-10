# Post-reload — start here

**After:** Developer → Reload Window (or `commands/cursor-reload-window.ps1`)

**Task Router (DEC-057):** after reload, every prompt auto-gets `[TASK ROUTE]` via `hooks/task-router.ps1`.

**Prompt Coach (DEC-058):** `hooks/prompt-coach-capture.ps1` копит ваши промты; статус: `prompt-coach-status.ps1`.

Test: `commands/task-router-test.ps1 -Prompt "ваш запрос"`.

---

## 1. MCP OAuth (one-time each)

| Server | Action |
|--------|--------|
| **apify** | Settings → MCP → Connect |
| **magnific** | Connect |
| **notion** | Connect if prompted |
| **google-workspace** | Connect → browser OAuth (Gmail/Drive/Calendar) |
| **figma** | Connect if using design |

`mcp.json` is local (gitignored). Example: `mcp.json.example`.

---

## 2. Automated verify (2 min)

```powershell
powershell -File commands/p3-final-audit.ps1
```

Or full bootstrap with wait:

```powershell
powershell -File commands/post-reload-bootstrap.ps1 -Reload -WaitMinutes 3
```

Expect **0 FAIL** in P3-READY and P3-SMOKE reports.

---

## 3. Quick feature smoke (10 min)

| # | Test |
|---|------|
| 1 | `!auto список slash-команд` |
| 2 | `/production-studio REF-16 hybrid` |
| 3 | `pagespeed-audit.ps1 -Url https://okara.ai/pricing` |
| 4 | Browser side panel → «snapshot» |
| 5 | Magnificent — один video prompt |
| 6 | `@design-stack cro-review hero SaaS` |
| 7 | `@clone-website` — skill loads |
| 8 | `seo-audit.ps1 -Url <site>` |
| 9 | Project Manager → open hub |
| 10 | `gsc-audit.ps1` after CSV in `ai-tracking/gsc-import/` |

---

## 4. Optional upgrades

| Need | Command |
|------|---------|
| Full Google check | `ensure-google-mcp.ps1` |
| Viral scripts | `USER-*.md` in `production-studio/refs/` |
| GSC CSV | Export from web UI → `gsc-import/` |

---

## 5. If something fails

Write in chat what broke — we fix without full re-audit.

**Status:** `ai-tracking/REQ-STATUS.md` · **Playbook:** `P3-MANUAL-TEST-PLAYBOOK.md`
