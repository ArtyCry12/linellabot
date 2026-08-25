# n8n Workflow Skill — Module Index

Route to the **smallest** reference set that completes the task.

## By task

| Goal | Modules (read in order) |
|------|-------------------------|
| New workflow from scratch | `patterns.md` → `workflow-json.md` → `node-configuration.md` → `expressions.md` → `validation.md` |
| Fix expression errors | `expressions.md` → `validation.md` |
| Fix node config / missing_required | `node-configuration.md` → `validation.md` |
| AI agent / chatbot | `ai-agents.md` → `node-configuration.md` → `workflow-json.md` |
| Code node logic | `code-nodes.md` → `expressions.md` (contrast) |
| Review AI-generated JSON | `anti-hallucination.md` → `validation.md` → `workflow-json.md` |
| Property type confusion | `property-types.md` |

## By pattern

| Pattern | Primary module |
|---------|----------------|
| Webhook → process → respond | `patterns.md` § Webhook |
| REST API sync | `patterns.md` § HTTP API |
| DB ETL | `patterns.md` § Database |
| Scheduled report | `patterns.md` § Scheduled |
| Batch / pagination | `patterns.md` § Batch |
| AI agent + tools | `ai-agents.md` |

## Cross-links

| Topic | File |
|-------|------|
| JSON skeleton, connections, IF/Switch | `references/workflow-json.md` |
| `{{$json}}`, webhook `.body`, `$node` | `references/expressions.md` |
| Profiles, error types, validate loop | `references/validation.md` |
| displayOptions, operation-aware fields | `references/node-configuration.md` |
| 6 patterns + checklists | `references/patterns.md` |
| ai_languageModel reversed flow | `references/ai-agents.md` |
| `$input.all()`, return shape | `references/code-nodes.md` |
| 23 property types | `references/property-types.md` |
| Templates-first, never defaults | `references/anti-hallucination.md` |
| Golden minimal JSON | `examples/minimal-workflows.json` |

## MCP integration (optional)

When `n8n-mcp` is enabled in Cursor, run live validation/deploy **after** applying rules from this skill. Hub doc: `commands/n8n-mcp.md`.

## Upstream mapping

| This skill | n8n-mcp `data/skills/` |
|------------|-------------------------|
| expressions.md | `n8n-expression-syntax/` |
| validation.md | `n8n-validation-expert/` |
| node-configuration.md | `n8n-node-configuration/` |
| patterns.md | `n8n-workflow-patterns/` |
| code-nodes.md | `n8n-code-javascript/`, `n8n-code-python/` |
| anti-hallucination.md | `README.md` Claude Project block |
