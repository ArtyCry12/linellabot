# Sentry MCP — activation log

**Date:** 2026-08-25  
**Action:** `powershell -File commands/mcp-profile.ps1 -Name ops` — **OK**

Live `mcp.json` servers: memory, gitnexus, notion, n8n-mcp, google-workspace, **sentry**  
Sentry URL: `https://mcp.sentry.dev/mcp` (OAuth)

## OAuth result (2026-08-25)

| Surface | Status |
|---------|--------|
| `plugin-sentry-sentry` (Cursor plugin) | **Authenticated** — `find_organizations` → org **`nlmedia`** (`https://nlmedia.sentry.io`, region `de`) |
| `user-sentry` (ops `mcp.json` URL `https://mcp.sentry.dev/mcp`) | discovery **error** — duplicate of plugin; safe to ignore or remove from ops later |

Working path for tools: **plugin-sentry-sentry** (not the broken user-sentry duplicate).
