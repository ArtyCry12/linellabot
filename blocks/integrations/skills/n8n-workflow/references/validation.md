# n8n Validation — Rules and Loop

## Philosophy

**Validate early, validate often.** Expect **2–3** validate → fix cycles (~23s read errors, ~58s fix per cycle).

| Severity | Action |
|----------|--------|
| **Error** | Must fix before activation |
| **Warning** | Should fix; ~40% acceptable in context |
| **Suggestion** | Optional optimization |

## Profiles

| Profile | When |
|---------|------|
| `minimal` | Quick edit checks |
| `runtime` | **Default pre-deploy** |
| `ai-friendly` | AI-generated configs; fewer false positives |
| `strict` | Production hardening |

## Error types (fix order)

| Type | Meaning | Fix |
|------|---------|-----|
| `missing_required` | Field absent | `get_node` / schema → add field |
| `invalid_value` | Not in enum | Use allowed value from error |
| `type_mismatch` | string vs number | Coerce type |
| `invalid_expression` | Bad `{{ }}` | See `expressions.md` |
| `invalid_reference` | Bad `$node["Name"]` | Fix spelling / node exists |

## Three-layer workflow validation

1. **Nodes** — each `parameters` valid for resource+operation
2. **Connections** — no dangling targets; IF/Switch output counts match
3. **Expressions** — syntax + referenced nodes exist

## Workflow-level issues

| Issue | Fix |
|-------|-----|
| Broken connection | `cleanStaleConnections` or fix name |
| Circular dependency | Restructure graph |
| Multiple triggers | One trigger per workflow or split |
| Disconnected node | Wire or remove |
| Switch rules ≠ outputs | Align rule count and branches |

## Operator auto-sanitization (on save)

Automatically fixed on workflow update:

- Binary operators (`equals`, `contains`, …): remove erroneous `singleValue`
- Unary (`isEmpty`, …): add `singleValue: true`
- IF/Switch v2.2+: metadata on `conditions.options`

**Not** auto-fixed: broken connections, branch count mismatch, corrupt API state.

## IF / filter operator rules

```json
// Binary — two values, NO singleValue
{ "type": "boolean", "operation": "equals", "value1": "...", "value2": "..." }

// Unary — singleValue: true
{ "type": "boolean", "operation": "isEmpty", "singleValue": true }
```

## False positives (often OK)

- Missing error handling — dev/test workflows
- No retry — idempotent or manual triggers
- No rate limit — internal/low-volume APIs
- Unbounded SELECT — small tables

Use `ai-friendly` profile when warnings are noisy.

## Validation loop (mandatory)

```
configure → validate_node(runtime) → read errors → fix one class → repeat
→ assemble workflow → validate_workflow → deploy
```

Never activate on first draft without validation pass.

## patchNodeField failures

| Error | Cause | Fix |
|-------|-------|-----|
| find string not found | Typo or already changed | `get_workflow` inspect field |
| ambiguous match | Multiple occurrences | Narrow `find` or `replaceAll: true` |
| invalid regex | ReDoS-risk pattern | Simplify regex |

## Recovery strategies

1. **Start fresh** — minimal valid config, add fields incrementally
2. **Binary search** — remove half the nodes to isolate fault
3. **cleanStaleConnections** — after node deletes
4. **Autofix preview** — expression `=` prefix, typeVersion, webhook path UUID

## Pre-activation checklist

- [ ] `valid: true` on all nodes
- [ ] `validate_workflow` clean on errors
- [ ] Webhook paths static; credentials not in parameters
- [ ] Error Trigger or `errorWorkflow` for production
- [ ] Tested with pin data / manual execution
