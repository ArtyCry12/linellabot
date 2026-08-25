# n8n Node Configuration — Operation-Aware Rules

## Golden rule

**Default parameter values are the #1 source of runtime failures.**

Always set every field that controls behavior — especially `resource`, `operation`, and operation-specific IDs.

### Slack example

```json
// FAILS at runtime
{ "resource": "message", "operation": "post", "text": "Hello" }

// WORKS
{
  "resource": "message",
  "operation": "post",
  "select": "channel",
  "channelId": "C1234567890",
  "text": "Hello"
}
```

## Operation-aware required fields

Required fields depend on **`resource` + `operation`** — not static per node type.

| Slack op | Extra required |
|----------|----------------|
| `post` | `channel` / `channelId`, `text` |
| `update` | `messageId`, `text` (not channel) |

Same pattern for HTTP (method → `sendBody` → `body`), databases (operation → table/columns), etc.

## displayOptions / dependencies

Fields show/hide based on other parameter values.

**HTTP Request**:

| method | Visible params |
|--------|----------------|
| GET | `url`, headers — no body |
| POST | `sendBody: true` → `body` required |

Always configure the **visible** branch completely.

## Discovery order (no guessing)

1. Identify `nodeType` + intended resource/operation
2. Load schema at **standard** detail (required + common fields)
3. Configure required fields only → validate
4. Search properties if stuck (`auth`, `body`, `channel`, …)
5. Full schema only if standard insufficient

## Progressive disclosure

| Level | Use |
|-------|-----|
| minimal | Trigger type check |
| **standard** | **95% of configs** |
| full | Edge cases, rare properties |
| search_properties | Find one field by name |
| docs | Human-readable node readme |

## Configuration workflow

```
Identify op → standard schema → minimal params → validate_node
  → fix missing_required → add optional → validate again → add to workflow JSON
```

## Node naming

- Unique, descriptive: `Fetch GitHub Issues` not `HTTP Request 1`
- Names used in `$node["Fetch GitHub Issues"]` — keep stable when using expressions

## Credentials

- Store in n8n **Credentials**, reference by ID/name in node
- Never put API keys in `parameters` literals

## typeVersion

- Always set explicitly in JSON
- Multi-version nodes (Webhook, HTTP Request): pick version matching parameter shape
- Upgrading version may require parameter migration — validate after change

## Set node (v2) shape

```json
{
  "mode": "manual",
  "assignments": {
    "assignments": [
      { "name": "field", "type": "string", "value": "={{ $json.body.email }}" }
    ]
  }
}
```

## Common configuration mistakes

| Mistake | Fix |
|---------|-----|
| Only `operation` set | Fill all required fields for that operation |
| POST without body | `sendBody: true` + `body` |
| Channel name vs ID | Use correct field per `select` mode |
| Expression in wrong mode | String field may need `={{ }}` prefix |
| Copy config from different operation | Re-validate for new operation |

## Surgical edits

Prefer `updateNodeParameters` / `setNodeParameter` over delete+re-add node (preserves AI sub-node attachments on agents).

## Related

- `property-types.md` — JSON shapes per field type
- `validation.md` — error interpretation
- `workflow-json.md` — node object in export
