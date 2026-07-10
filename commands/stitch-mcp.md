# Stitch MCP (Google UI Design)

Load when user asks about Stitch, UI mockups from Google, or `/stitch-mcp`.

## Why a local proxy?

Direct URL `https://stitch.googleapis.com/mcp` shows **Connected** in Cursor but **0 tools** — `tools/list` is ~315 KB (huge `outputSchema`). Cursor silently drops it.

**Fix:** stdio proxy strips schemas → ~43 KB → **14 tools** register.

| Item | Path |
|------|------|
| Proxy | `commands/stitch-mcp-proxy.mjs` |
| Health check | `commands/ensure-stitch.ps1` |
| Descriptors sync | `commands/sync-stitch-mcp-descriptors.mjs` |
| MCP config | `mcp.json` → `command` + `STITCH_API_KEY` |
| Tool JSON | `projects/.../mcps/user-stitch/tools/` |

## mcp.json (required shape)

```json
"stitch": {
  "command": "node",
  "args": ["C:/Users/Asus/.cursor/commands/stitch-mcp-proxy.mjs"],
  "env": {
    "STITCH_API_KEY": "YOUR_STITCH_API_KEY"
  }
}
```

**Do not** use remote `url` only — breaks in Cursor.

## Tools (14)

`list_projects`, `get_project`, `create_project`, `list_screens`, `get_screen`, `generate_screen_from_text`, `edit_screens`, `generate_variants`, `upload_design_md`, `create_design_system`, `create_design_system_from_design_md`, `update_design_system`, `list_design_systems`, `apply_design_system`

## Verify

```powershell
C:\Users\Asus\.cursor\commands\ensure-stitch.ps1
# or both Stitch + Figma:
C:\Users\Asus\.cursor\commands\ensure-design-mcp.ps1
```

Then **Reload Window** (`commands\cursor-reload-window.ps1`) → Settings → MCP → stitch should show **14 tools**.

## Test in chat

```
Use stitch MCP: list_projects
```

## vs Gemini MCP

| Server | Role |
|--------|------|
| stitch | UI design projects, screens, design systems |
| gemini | LLM text/vision/embed (AI Studio key) |

Separate keys from [Stitch Settings](https://stitch.withgoogle.com) vs [AI Studio](https://aistudio.google.com/app/apikey).
