# n8n Node Property Types

Reference for **parameter JSON shapes** (from n8n-workflow NodePropertyTypes). Use when validation reports type errors.

## Primitives

| Type | JS type | Notes |
|------|---------|-------|
| `string` | string | Expressions allowed; may be empty |
| `number` | number | Not string `"100"` |
| `boolean` | boolean | `true`/`false`, not `"true"` |
| `dateTime` | string ISO | `2024-01-20T10:30:00Z`, `{{ $now }}` |
| `color` | string | `#RRGGBB` hex |
| `json` | string | JSON **string**; parse in Code if needed |

## Complex

| Type | Shape | Notes |
|------|-------|-------|
| `collection` | `{ [key]: value }` | Nested object params |
| `fixedCollection` | `{ [group]: [ items ] }` | Repeatable groups (e.g. headers list) |
| `options` | string \| string[] | Must match allowed option values |
| `multiOptions` | string[] | Subset of allowed values |
| `resourceLocator` | `{ mode, value, __rl? }` | URL/id/list modes — use `explore_node_resources` for dynamic lists |
| `resourceMapper` | mapping object | Column/field mapping UIs |
| `filter` | conditions tree | IF/Switch; mind unary vs binary operators |
| `assignmentCollection` | Set node assignments | `{ assignments: [{ name, type, value }] }` |
| `credentialsSelect` | credential ref | By name/type — not raw secrets |

## Special UI types

| Type | Purpose |
|------|---------|
| `notice` | Read-only UI hint — omit from generated JSON |
| `hidden` | Internal — often auto-set |
| `button` | UI action — not a data field |

## Validation hints

- **Expressions**: allowed on most `string`/`number`/`json` fields unless `noDataExpression`
- **resourceLocator**: wrong `mode` → invalid_value at runtime
- **filter**: binary ops need two values; unary need `singleValue: true`
- **options**: case-sensitive match to schema enum

## Common type_mismatch fixes

| Error | Fix |
|-------|-----|
| Expected number, got string | Remove quotes: `100` not `"100"` |
| Expected boolean | `true` not `"true"` |
| Invalid option | Pick from schema enum exactly |
| Invalid resourceLocator | Set `mode` + `value` per schema |

## Related

- `node-configuration.md` — operation-aware fields
- `validation.md` — `type_mismatch` errors
