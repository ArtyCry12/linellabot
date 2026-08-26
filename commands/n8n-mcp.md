# n8n MCP (Instance-level)

n8n cloud **Instance-level MCP** exposes workflow automation tools to Cursor via HTTP + Bearer JWT.

## Config (`mcp.json`, gitignored)

```json
"n8n-mcp": {
  "url": "https://YOUR_INSTANCE.app.n8n.cloud/mcp-server/http",
  "headers": {
    "Authorization": "Bearer YOUR_N8N_MCP_JWT"
  }
}
```

Get URL + token: n8n → **Settings → Instance-level MCP** → Connection details.

Descriptor folder: `projects/c-Users-artyo-cursor/mcps/user-n8n-mcp/`

## Health check

```powershell
powershell -File commands/ensure-n8n.ps1
```

Or:

```bash
node commands/test-n8n-mcp.mjs
node commands/sync-n8n-mcp-descriptors.mjs
```

After config changes: **Reload Window** in Cursor (Tools & MCP).

## Routing

| Task | Use |
|------|-----|
| n8n workflows / Workflow SDK | **`n8n-mcp`** |
| Cross-app Zapier actions | `plugin-zapier-zapier` |

No name collision: `n8n-mcp` (user HTTP) vs `plugin-zapier-zapier` (plugin).

## Notes

- Response format is **SSE** (`event: message` + `data: {...}`).
- Token rotates in n8n UI — update `mcp.json` and re-run `ensure-n8n.ps1`.
- Do not commit `mcp.json`; use `mcp.json.example` placeholder only.
- If Cursor shows **errored** or **0 tools** after first add: **Reload Window** (token was fixed; stale session).
- CLI `tools/list` may reset from n8n cloud; descriptors sync uses manifest fallback (`commands/n8n-mcp-tools-manifest.json`).
- Fallback stdio bridge (if direct HTTP fails in Cursor): supergateway per [n8n community](https://community.n8n.io/t/introducing-instance-level-mcp-access-in-n8n-beta/223178) — ask before switching.
