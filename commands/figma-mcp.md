# Figma MCP

Load when user asks about Figma, design-to-code, Code Connect, or `/figma-mcp`.

## Config (`mcp.json`)

```json
"figma": {
  "url": "https://mcp.figma.com/mcp"
}
```

Or install **Figma plugin** in Cursor: `/add-plugin figma`

## First connect

1. Run `commands\ensure-design-mcp.ps1`
2. **Reload Window** (`commands\cursor-reload-window.ps1`)
3. **Settings → MCP → figma → Connect** (OAuth, one-time)

## Verify

In chat: ask agent to call `whoami` on figma MCP.

Tool descriptors: `projects/.../mcps/plugin-figma-figma/tools/`

## vs Stitch

| Server | Role |
|--------|------|
| **figma** | Production design files, Code Connect, generate/adapt Figma |
| **stitch** | Fast UI mockups from text, Google Stitch projects |

Health: `commands\ensure-design-mcp.ps1`
