# n8n Expressions — Authoring Rules

Classic n8n expression syntax for **parameter fields** (not Code nodes).

> **Expressions v2**: [czlonkowski/n8n-mcp](https://github.com/czlonkowski/n8n-mcp) documents classic `{{ }}` syntax only. There is no separate "v2" pack in that repo. For **Workflow SDK** (TypeScript) authoring via official n8n instance MCP, call `get_sdk_reference` — do not mix SDK and raw JSON semantics in one artifact.

## Format

```
{{ expression }}
```

Field mode prefix for expression fields:

```
={{ $json.field }}
```

| Pattern | Valid? |
|---------|--------|
| `{{$json.email}}` | Yes |
| `$json.email` in parameter | No — literal text |
| `{{$json.field name}}` | No — use `{{$json['field name']}}` |
| `{{{$json.x}}}` | No — no nested braces |

## Core variables

| Variable | Meaning |
|----------|---------|
| `$json` | Current item JSON |
| `$node["Name"]` | Another node's output (name case-sensitive, quoted if spaces) |
| `$input` | All input items (in some contexts) |
| `$now` | Current time (Luxon) |
| `$env.VAR` | Env var (may be blocked by `N8N_BLOCK_ENV_ACCESS_IN_NODE`) |
| `$workflow`, `$execution` | Workflow/run metadata |

## Webhook rule (most common bug)

Webhook output structure:

```json
{
  "headers": {},
  "params": {},
  "query": {},
  "body": { "email": "user@example.com" }
}
```

| Wrong | Right |
|-------|-------|
| `{{$json.email}}` | `{{$json.body.email}}` |
| `{{$json.name}}` | `{{$json.body.name}}` |

## Cross-node references

```javascript
{{$node["HTTP Request"].json.data.items[0].id}}
{{$node["Webhook"].json.body.email}}
```

Node name must match workflow **exactly** (case-sensitive).

## When NOT to use expressions

| Context | Use instead |
|---------|-------------|
| **Code node** | `$json.email`, `$input.all()`, `$input.first()` |
| Webhook `path` | Static string only |
| Credentials | n8n credential system |
| Code node assignment | `const x = $json.field` — never `'={{$json.x}}'` |

## Code node contrast

```javascript
// WRONG in Code node
const email = '={{$json.email}}';

// CORRECT
const email = $json.body.email;
const items = $input.all();
return items.map(item => ({ json: { ...item.json, processed: true } }));
```

Return shape: `[{ json: { ... } }]` per item.

## Validation checklist

- [ ] Wrapped in `{{ }}` (or `={{ }}` for whole field)
- [ ] Webhook fields use `.body`
- [ ] Node names quoted: `$node["HTTP Request"]`
- [ ] Bracket notation for keys with spaces/special chars
- [ ] No expressions inside Code node JS/Python
- [ ] Expression prefix `=` where n8n expects expression mode

## Common errors

| Message / symptom | Fix |
|-------------------|-----|
| Literal `{{$json.x}}` shown in output | Add/fix braces or `=` prefix |
| Cannot read property of undefined | Wrong path; check `.body` for webhooks |
| Node does not exist | Typo in `$node["Name"]` |
| Expression in Code node fails | Remove `{{ }}`; use `$json` |

## Luxon / string helpers (in expressions)

```javascript
{{$now.toFormat('yyyy-MM-dd')}}
{{$json.email.toLowerCase()}}
{{$json.status === 'active' ? 'Yes' : 'No'}}
{{$json.price * 1.1}}
```

## Related

- `workflow-json.md` — where expressions appear in export JSON
- `code-nodes.md` — Code node data access
- `validation.md` — `invalid_expression` errors
