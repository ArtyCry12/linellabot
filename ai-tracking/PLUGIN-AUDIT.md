# Plugin audit notes (REQ-075)

**Scan:** `commands/hub-supply-scan.ps1`  
**Output:** `ai-tracking/hub-supply-scan.json`

## Policy

- Keep Cursor marketplace plugins that appear in SYSTEM-REGISTRY
- Remove duplicates only after user confirms (no mass uninstall in autopilot)
- Prefer plugin MCP over duplicate Zapier actions when native server exists

## Last run

Re-run after major Cursor updates:

```powershell
powershell -File commands/hub-supply-scan.ps1
```

## Defer

Full plugin purge not required for P3 close — inventory is sufficient.
