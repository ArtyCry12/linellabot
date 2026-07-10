# n8n Workflow Skill

Offline knowledge for building correct n8n workflow JSON — no MCP server required.

## Invoke

```
@n8n build webhook to Slack for form submissions
@n8n fix validation errors in this workflow JSON
```

## Location

| Item | Path |
|------|------|
| Main skill | `skills/n8n-workflow/SKILL.md` |
| Module index | `skills/n8n-workflow/skill-index.md` |
| References | `skills/n8n-workflow/references/` |
| Examples | `skills/n8n-workflow/examples/minimal-workflows.json` |
| Rule (on-demand) | `rules/n8n-workflow.mdc` |

## With n8n instance MCP

Combine skill rules + live tools:

1. Apply anti-hallucination rules from skill
2. `search_nodes` / `get_node_types` / `validate_workflow` via `n8n-mcp`
3. Deploy with `create_workflow_from_code` when ready

Hub MCP doc: `commands/n8n-mcp.md`

## Source

Knowledge distilled from [czlonkowski/n8n-mcp](https://github.com/czlonkowski/n8n-mcp) `data/skills/` (MIT). Clone: `ai-tracking/n8n-mcp-src/`.

Refresh: re-clone upstream and diff `data/skills/` against `skills/n8n-workflow/references/`.
