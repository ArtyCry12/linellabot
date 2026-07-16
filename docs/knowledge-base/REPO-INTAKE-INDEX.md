# Repo intake index — uploaded / referenced repositories

**Updated:** 2026-07-13 · Hub Phase C-D-E

| Repo | URL | Decision | Hub artifact |
|------|-----|----------|--------------|
| ECC | https://github.com/affaan-m/ECC | **archived + on-demand** | Private: `ArtyCry12/cursor-hub-archive` · restore via `ensure-ecc.ps1` |
| playwright-mcp | https://github.com/microsoft/playwright-mcp | **install** | `mcp.json` → `playwright` |
| markitdown | https://github.com/microsoft/markitdown | **hook + MCP** | hook + `markitdown-mcp` |
| chrome-devtools-mcp | https://github.com/ChromeDevTools/chrome-devtools-mcp | **install** | `mcp.json` |
| Understand-Anything | https://github.com/Egonex-AI/Understand-Anything | **complement** | skill on-demand |
| ruflo | https://github.com/ruvnet/ruflo | **patterns** | `RUFLO-SQUAD-BRIDGE.md` |
| vllm | https://github.com/vllm-project/vllm | **reference-only** | AI-STACK-MAP |
| n8n-templates-src | (embedded) | **archived** | `ArtyCry12/cursor-hub-archive` / `n8n-templates-src` |

## Intake workflow

1. User attaches repo summary → `hooks/repo-intake.ps1`
2. Classify per table above
3. Update this file + `SYSTEM-REGISTRY.md` when installed

## Do not embed

Full clones stay in `lib/ecc-src/` (gitignored) or external install — not duplicated in skills/.
