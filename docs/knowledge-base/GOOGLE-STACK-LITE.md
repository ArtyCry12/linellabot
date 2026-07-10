# Google Stack Lite (P1 substitute for Google Trio)

**Decision (2026-07-10):** Full Google Trio (Workspace + Cloud Toolbox + Maps MCP + OAuth) **deferred** — heavy setup, browser OAuth friction. Replaced with **lite stack** already in hub.

## Original REQ → Lite substitute

| Original (REQ) | Lite substitute | Where |
|----------------|-----------------|-------|
| Gmail / Drive / Calendar (015) | **gemini** MCP + **fetch** for public URLs; manual attach for files | `mcp.json` → `gemini` |
| Cloud DB / Toolbox (016) | **Supabase MCP** when DB task; else defer | plugin-supabase |
| Maps Code Assist (017) | **gemini** + web search; Maps MCP when project needs geo | on demand |
| OAuth Desktop JSON (018) | Saved at `ai-tracking/google-oauth-client.json` — **enable full trio later** one command | `commands/ensure-google-mcp.ps1` |
| PageSpeed (019) | `commands/pagespeed-audit.ps1` + PSI API in secrets | ✅ |
| Search Console (020) | **pagespeed** + **seo-geo** skills; GSC API when OAuth ready | P2 |
| GA4 | n8n / manual; full Google when OAuth | P2 |

## When to upgrade to full Trio

- Daily Gmail/Drive automation from agent
- GSC/GA4 pull into hub without copy-paste
- Cloud SQL via `@toolbox-sdk/server`

**Upgrade path:** Uncomment in `mcp.json.example` → `google-workspace`, `google-maps` → Reload → OAuth once.

## Routing (auto-orchestrator)

```
Google email/calendar/file  → defer OR gemini draft + user sends
Performance audit           → pagespeed-audit.ps1
SEO / GEO                   → seo-geo skill pack
Maps / local business       → gemini + Exa/fetch
Database                    → supabase MCP
```

## Credentials (gitignored)

- `ai-tracking/google-oauth-client.json` — ready for future trio
- `ai-tracking/secrets.local.json` — `PAGESPEED_API_KEY`
