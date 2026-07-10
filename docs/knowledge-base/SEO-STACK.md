# SEO & Performance Stack (REQ-020–023)

**Hub scripts:** `commands/seo-audit.ps1` · `commands/pagespeed-audit.ps1`  
**Skill pack:** `skills/seo-geo/` (20 skills)

---

## Installed / available via npx (P2)

| Tool | Version checked | Role |
|------|-----------------|------|
| lighthouse | 13.x | Full Lighthouse audit CLI |
| htmlhint | 1.9.x | HTML lint |
| eslint | 10.x | JS/TS lint |
| stylelint | via npx | CSS lint |
| @lhci/cli | via npx | CI budgets (optional) |

Run without global install: `npx --yes <package>`.

## PageSpeed Insights (REQ-019) — P1 ✅

`commands/pagespeed-audit.ps1` — key in `ai-tracking/secrets.local.json`.

## Search Console (REQ-020) — blocked lite

Full auto-connect needs **Google Workspace MCP** OAuth.  
**Current:** GOOGLE-STACK-LITE — manual GSC export or enable `ensure-google-mcp.ps1` when ready.

**Stub:** `commands/gsc-audit.ps1` documents future `google-api-python-client` flow.

## SEO libraries (REQ-021)

| Package | Use |
|---------|-----|
| web-vitals | RUM in Next.js apps |
| schema-dts | Type-safe JSON-LD |
| ehmicky/seo | Inspiration — meta/structure helpers |

Install per-project when building sites, not in hub root.

## AI SEO inspiration (REQ-022)

langchain / AutoGPT / babyagi — **patterns only** for automation loops:

- Planner → executor → critic (maps to Squad phases)
- Scheduled refresh (maps to seo-geo `alert-manager`)

No local install required in hub.

## Advanced perf (REQ-023)

| Tool | When |
|------|------|
| sitespeed.io | Deep waterfall — Docker or CI |
| WebPageTest API | Third-party key |
| google-api-python-client | GSC API when OAuth live |

## Recommended audit order

1. `seo-audit.ps1 -Url <site>` (Lighthouse + PSI)
2. seo-geo `/aaron:audit` for content/CORE-EEAT
3. GSC when connected

---

*P2 · 2026-07-10*
