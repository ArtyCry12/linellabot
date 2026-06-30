# Gemini MCP (Google AI Studio)

Quick reference for the **`gemini`** MCP server in `mcp.json` (gitignored).

## What it is

| Item | Value |
|------|-------|
| MCP id | `gemini` |
| Package | `@anzchy/mcp-server-gemini` (stdio via `npx.cmd`) |
| API | `generativelanguage.googleapis.com` |
| Default model | `gemini-flash-latest` |
| Env | `GEMINI_API_KEY`, `GOOGLE_API_KEY` (same key) |

## Tools (6)

- Text generation (JSON mode, grounding, system instructions)
- Image / vision analysis
- List models
- Token count
- Embeddings
- Built-in help

## vs Stitch

| Server | Purpose | Endpoint |
|--------|---------|----------|
| **gemini** | LLM: text, vision, embed | `generativelanguage.googleapis.com` |
| **stitch** | UI design projects | `stitch.googleapis.com/mcp` |

Separate keys. No conflict.

## Test in chat

```
Use gemini MCP to list available models.
Use gemini MCP to explain how AI works in a few words.
```

## Geo / VPN

If API returns `User location is not supported`, enable VPN (EU/US) and retry. MCP config is still valid.

## Reload

After `mcp.json` change: **Cursor → Settings → MCP → Reload** or Reload Window.
