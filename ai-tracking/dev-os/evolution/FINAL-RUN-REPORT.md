# Final Run — Deferred Cleanup Instructions

After closing **Cursor completely**:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\Asus\.cursor\commands\cursor-system-refresh-deferred.ps1" -HubRoot "C:\Users\Asus\.cursor"
```

Or re-run full refresh (queues deferred if Cursor open):

```cmd
C:\Users\Asus\.cursor\commands\cursor-system-refresh.cmd
```

Then verify:

```cmd
node C:\Users\Asus\.cursor\commands\dev-os-status.mjs
```

**fetch MCP:** Cursor Settings → MCP → restart **fetch** server if tools show errored.

**gitnexus (optional):** `npx gitnexus analyze --skip-agents-md` from hub root; if crash on `design_system.py`, index may partial-stale — acceptable until upstream fix.
