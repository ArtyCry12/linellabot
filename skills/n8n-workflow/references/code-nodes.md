# n8n Code Nodes — JavaScript and Python

Code nodes execute **real code** — not n8n expressions.

## JavaScript (Code node)

### Data access

```javascript
// Single item
const item = $input.first();
const email = item.json.body?.email;

// All items
const items = $input.all();

// Reference other node (by name)
const webhookData = $('Webhook').first().json;
```

### Return shape (required)

```javascript
return [
  { json: { key: "value", count: 42 } },
  { json: { key: "other" } }
];
```

Each output item must be `{ json: { ... } }`.

### Rules

| Do | Don't |
|----|-------|
| `$json.field` | `'={{$json.field}}'` |
| `$input.all()` for batch | Assume single item without check |
| `return [{ json: {...} }]` | Return raw object |
| Use `.body` for webhook data | `$json.email` on webhook payload |

### Static data (cross-execution)

```javascript
const data = $getWorkflowStaticData('global');
data.accumulator = data.accumulator || [];
data.accumulator.push($json.id);
return $input.all();
```

Use in batch loops to accumulate across SplitInBatches iterations.

### Built-ins

- Standard JS (ES6+ per n8n version)
- `$helpers`, Luxon via `$now` in expressions only — in Code use `Date` or imported patterns per n8n docs
- No `require()` of arbitrary npm unless n8n version allows

## Python (Code node)

- Access: `_input`, `_json` patterns per n8n Python runtime (check node docs for version)
- Return list of dicts with `json` key equivalent
- **No** `{{ }}` expressions
- Stdlib only — no pip install at runtime

Prefer JavaScript Code node unless user requires Python.

## When to use Code vs Set vs expressions

| Need | Use |
|------|-----|
| Simple field map | Set node |
| One-field transform in parameter | Expression `={{ }}` |
| Multi-item logic, API response shaping | Code node |
| Aggregate all items | Code node |

## Dry-run / disabled upstream

When API node disabled for test, downstream may receive request stub:

```javascript
const body = $input.first().json;
const looksLikeRequest = body.method && body.parameters && !body.status;
if (looksLikeRequest) {
  return [{ json: { status: 'SKIPPED', message: 'Upstream disabled' } }];
}
```

## Related

- `expressions.md` — when NOT to use expressions
- `patterns.md` — batch accumulation pattern
