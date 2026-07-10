# Source and Refresh

| Field | Value |
|-------|-------|
| Upstream | https://github.com/czlonkowski/n8n-mcp |
| License | MIT |
| Extracted from | `data/skills/*`, `README.md` workflow rules, `src/constants/type-structures.ts` (types only), `src/mcp/workflow-examples.ts`, `src/mcp/tool-docs/guides/ai-agents-guide.ts` (knowledge text) |
| Ignored | TypeScript server code, Docker, transports, tests |
| Local clone | `C:/Users/Asus/.cursor/ai-tracking/n8n-mcp-src/` |

## Refresh procedure

```bash
cd C:/Users/Asus/.cursor/ai-tracking/n8n-mcp-src
git pull
```

Diff `data/skills/` against `skills/n8n-workflow/references/` and merge new rules.

## Expressions v2 note

Upstream n8n-mcp documents **classic** `{{ }}` expressions only. Official n8n **Workflow SDK** (instance MCP `get_sdk_reference`) is a separate authoring path — not vendored in czlonkowski/n8n-mcp.

## Pairing with n8n-mcp

| Layer | Role |
|-------|------|
| This skill | Rules + JSON shape + anti-hallucination |
| `n8n-mcp` MCP | Live node DB, validate, deploy to instance |
