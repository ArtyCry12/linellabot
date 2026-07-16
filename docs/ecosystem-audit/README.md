# Ecosystem audit — localhost presentation

Browser version of the **full hub audit** + 3 quizzes (profile, fixes, automation) with direct hub ingest.

Full audit markdown: `ai-tracking/FULL-SYSTEM-AUDIT.md`

## Start server

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File commands/ecosystem-audit-server.ps1
```

Open: **http://localhost:8765/**

Custom port:

```powershell
powershell -File commands/ecosystem-audit-server.ps1 -Port 3000
```

## Quiz channel

`POST /api/quiz-ingest` writes to:

- `ai-tracking/user-profile/quiz-responses.jsonl`
- `ai-tracking/user-profile/profile.json`

Same backend as `commands/quiz-ingest.ps1`.

## Files

| File | Role |
|------|------|
| `docs/ecosystem-audit/index.html` | Presentation UI |
| `commands/ecosystem-audit-server.ps1` | Static host + ingest API |

Canvas version (IDE): `projects/c-Users-Asus-cursor/canvases/ecosystem-audit.canvas.tsx`
