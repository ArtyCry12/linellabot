# Sentry MCP (ops / qa) — not Always-On

**Status:** wired into profiles + store catalog (2026-08-25).  
**Auth:** Boss completes OAuth / token in live `mcp.json` after `mcp-profile.ps1 -Name ops` (or `qa`).

## Recommended config (remote OAuth — preferred in Cursor)

```json
"sentry": {
  "url": "https://mcp.sentry.dev/mcp"
}
```

Alternate stdio (token in env, never commit):

```json
"sentry": {
  "command": "npx.cmd",
  "args": ["-y", "mcp-remote@latest", "https://mcp.sentry.dev/mcp"]
}
```

## Profiles

| Profile | Includes sentry? |
|---------|------------------|
| core | no |
| design | no |
| ops | **yes** |
| qa | **yes** |
| full | yes (via store) |

## Activate

```powershell
powershell -File commands/mcp-profile.ps1 -Name ops
# Reload Window → complete Sentry OAuth if prompted
```

## Policy

- Never core / never always-on default.
- Use when debugging production errors or project security sessions need live issues.
