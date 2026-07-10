# n8n Workflow Patterns

Six patterns cover most automation. Pick one before adding nodes.

## 1. Webhook processing (most common)

```
Webhook → Validate/Set → Transform → Respond OR Notify
```

- Trigger: `n8n-nodes-base.webhook`
- Data: `$json.body.*`
- Often ends with `respondToWebhook` for sync HTTP response

## 2. HTTP API integration

```
Trigger → HTTP Request → Transform → Action → (Error branch)
```

- Pagination: loop with `id_from` / cursor until empty
- Auth via credentials, not parameters
- Rate limit: `Wait` node between calls

## 3. Database operations

```
Schedule → Query → Transform → Write → Verify
```

- Parameterize queries; avoid unbounded SELECT in production
- Transaction semantics depend on node — validate per DB node

## 4. AI agent workflow

```
Trigger → AI Agent ← (Model, Tools, Memory, Parser)
       → Output / Response
```

See `ai-agents.md` for connection direction.

## 5. Scheduled tasks

```
Schedule → Fetch → Process → Deliver → Log
```

- Cron on Schedule Trigger
- Pair with Error Trigger workflow for failures

## 6. Batch processing

```
Prepare → SplitInBatches → Process (loop main[1]) → Done (main[0]) → Limit 1 → Aggregate
```

### SplitInBatches outputs

| Output | Behavior |
|--------|----------|
| `main[1]` | Each batch (loop body) |
| `main[0]` | Once when all batches done |

Always **Limit 1** after done output before aggregate.

### Cross-batch accumulation

`$('Node In Loop').all()` after loop = **last batch only**. Use `$getWorkflowStaticData('global')` in Code node to accumulate.

### Nested loops

Outer categories × inner pagination: inner `done[0]` → back to **outer** loop input; outer `done[0]` → final aggregate.

## Data flow shapes

| Shape | Use |
|-------|-----|
| Linear | Simple pipelines |
| Branching | IF / Switch |
| Parallel | Split → Merge |
| Loop | SplitInBatches |
| Error handler | Separate workflow with Error Trigger |

## Creation checklist

### Plan
- [ ] Pattern selected
- [ ] Nodes listed (search, don't invent types)
- [ ] Error strategy defined

### Build
- [ ] Trigger configured
- [ ] All parameters explicit (no defaults trap)
- [ ] Credentials referenced
- [ ] Expressions use `.body` for webhooks

### Validate
- [ ] Per-node validation
- [ ] Full workflow validation
- [ ] Sample execution / pin data

### Deploy
- [ ] `active: false` until tested
- [ ] Activate after successful test
- [ ] Monitor first runs

## Integration gotchas

### Google Sheets
- Avoid `append` on formula columns — use API `values.update`
- Write numbers as numbers for formulas
- Node runs per item — aggregate in Code for bulk write

### Google Drive
- `convertToGoogleDocument` creates Doc, not Sheet
- CSV download: `https://drive.google.com/uc?id={id}&export=download`

### Threshold checks
Use `Math.abs(diff) > threshold` for bidirectional alerts.

## Template-first

Before greenfield build: search templates by task (`webhook_processing`, `slack`, etc.). Attribute template authors when adapting.

## Related

- `workflow-json.md` — wire patterns in JSON
- `anti-hallucination.md` — process discipline
- `validation.md` — pre-deploy gate
