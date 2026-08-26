# Foundation Refresh — knowledge base & taxonomy update

Run after studying external repos or adding hub routing.

## Steps

1. Read `docs/knowledge-base/FOUNDATION-REPOS.md` if repos changed
2. Update `SYSTEM-TAXONOMY.md` domain row if new skill/MCP added
3. Update `SYSTEM-REGISTRY.md` table (one line per component)
4. Run quick refresh:

```powershell
C:\Users\artyo\.cursor\commands\cursor-system-refresh-quick.cmd
```

5. Optional: regenerate skill index only

```powershell
node C:\Users\artyo\.cursor\commands\generate-skill-index.mjs
```

## Selective external installs (manual)

| Repo | Command |
|------|---------|
| agency-agents | `commands/install-agency-agents.ps1` (66 rules → `rules/agency/`) |
| karpathy | `rules/karpathy-guidelines.mdc` (installed) |
| prompts.chat MCP | in `mcp.json` — Reload Window |
| bumblebee | `commands/bumblebee-scan.ps1` (WSL) or `hub-supply-scan.ps1` |

## DEC log

Record major routing changes in `ai-tracking/DEC-010-foundation-refresh.md`.
