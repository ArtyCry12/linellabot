# /route — preview task routing for a prompt

**Usage:** `/route <your task text>` or ask «куда роутится этот запрос?»

Runs `lib/task-router/Resolve-TaskRoute.ps1` and shows Primary/Secondary bundles (same as hook injects).

```powershell
powershell -File commands/task-router-test.ps1 -Prompt "ваш запрос"
```

**Manifest:** `lib/task-router/routes.json`  
**Always-on rule:** `rules/task-router.mdc`
