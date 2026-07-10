# Post-reload bootstrap

Run after **Reload Window** when MCP config changed.

```powershell
powershell -File commands/post-reload-bootstrap.ps1
```

With auto-reload + 3 min wait:

```powershell
powershell -File commands/post-reload-bootstrap.ps1 -Reload -WaitMinutes 3
```

Then read: `docs/POST-RELOAD-GUIDE.md`
