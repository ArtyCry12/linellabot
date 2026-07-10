# Google Search Console audit — stub (REQ-020)

> **Blocked** on GOOGLE-STACK-LITE until full Google Workspace OAuth is enabled.
> Re-enable: `commands/ensure-google-mcp.ps1` + `docs/knowledge-base/GOOGLE-STACK-LITE.md`

## Future flow

1. OAuth desktop client in `ai-tracking/google-oauth-client.json` (gitignored)
2. `pip install google-api-python-client google-auth-oauthlib` (or `uv pip install`)
3. Query Search Console API for property URL
4. Export to `ai-tracking/gsc-last.json`

## Manual workaround (now)

- Export GSC performance CSV from web UI
- Place in `ai-tracking/gsc-import/` — agent analyzes on request

## When unblocked

Replace this stub with `commands/gsc-audit.ps1` calling API.

*P2 · 2026-07-10*
