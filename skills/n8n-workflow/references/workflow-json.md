# n8n Workflow JSON — Structure Rules

Canonical shape for export/import and API `create_workflow` payloads.

## Top-level object

```json
{
  "name": "My Workflow",
  "nodes": [],
  "connections": {},
  "settings": {},
  "staticData": null,
  "meta": {},
  "pinData": {}
}
```

| Field | Required | Notes |
|-------|----------|-------|
| `name` | Yes | Human-readable workflow title |
| `nodes` | Yes | Array of node objects |
| `connections` | Yes | Object keyed by **source node name** |
| `settings` | Recommended | `executionOrder`, error workflow, timezone |
| `pinData` | Optional | Test fixtures for manual runs |

## Node object (every node)

```json
{
  "id": "uuid-or-stable-id",
  "name": "Webhook",
  "type": "n8n-nodes-base.webhook",
  "typeVersion": 2,
  "position": [250, 300],
  "parameters": {},
  "credentials": {},
  "disabled": false,
  "notes": ""
}
```

| Field | Rule |
|-------|------|
| `id` | Unique string; stable across updates |
| `name` | Unique in workflow; used in `connections` and `$node["Name"]` |
| `type` | Full type: `n8n-nodes-base.*` or `n8n-nodes-langchain.*` |
| `typeVersion` | Number; match node docs (see `versioned-nodes.md` in upstream) |
| `position` | `[x, y]` canvas coordinates |
| `parameters` | Node-specific; **never leave behavior fields at implicit defaults** |

### Type prefix cheat sheet

| Family | Prefix |
|--------|--------|
| Core nodes | `n8n-nodes-base.` |
| LangChain / AI | `@n8n/n8n-nodes-langchain.` or `n8n-nodes-langchain.` |

Short forms like `nodes-base.webhook` appear in MCP tools — expand to full `type` in JSON.

## Connections object

Keys are **source node names** (not IDs).

```json
{
  "Webhook": {
    "main": [
      [
        { "node": "Set", "type": "main", "index": 0 }
      ]
    ]
  }
}
```

### Main output topology

- `connections[Source].main[outputIndex][connectionIndex]`
- `outputIndex`: `0` = first output, `1` = second (IF false branch uses index 1)
- `index` on target: input index (usually `0`)

### IF node wiring

```
IF main[0] → true branch
IF main[1] → false branch
```

In partial-update APIs prefer `branch: "true"` / `branch: "false"` over ambiguous `sourceIndex`.

### AI connection types (non-main)

| `type` / port | From → To |
|---------------|-----------|
| `ai_languageModel` | Chat Model → AI Agent |
| `ai_tool` | Tool node → AI Agent |
| `ai_memory` | Memory → AI Agent |
| `ai_outputParser` | Parser → AI Agent |
| `ai_embedding` | Embeddings → Vector Store |
| `ai_vectorStore` | Vector Store → Retriever |
| `ai_document` | Document Loader → Vector Store |
| `ai_textSplitter` | Splitter → Document chain |

**Direction**: AI resources connect **into** the consumer (opposite of normal main flow). See `ai-agents.md`.

## Minimal examples

See `examples/minimal-workflows.json` in this skill.

## Settings worth setting explicitly

```json
{
  "executionOrder": "v1",
  "saveManualExecutions": true,
  "errorWorkflow": "optional-error-handler-workflow-id"
}
```

- `executionOrder: "v1"` — connection-based order (recommended)
- `errorWorkflow` — ID of workflow whose first node is **Error Trigger**

## Partial workflow updates (conceptual)

When using n8n API / instance MCP `update_workflow`, operations are atomic batches:

| Operation | Purpose |
|-----------|---------|
| `addNode` | Insert node with full parameters |
| `updateNodeParameters` | Patch `parameters` object |
| `setNodeParameter` | Single dot-path param |
| `addConnection` | Needs `source`, `target`, `sourcePort`, `targetPort` |
| `removeConnection` | Drop edge |
| `cleanStaleConnections` | Remove refs to deleted nodes |

`patchNodeField` is strict: exact `find` string, ambiguous match needs `replaceAll: true`.

## Common JSON mistakes

| Mistake | Fix |
|---------|-----|
| Connection key is node `id` | Use node `name` |
| Missing `typeVersion` | Always set from node schema |
| Duplicate node names | Rename; breaks `$node` refs |
| AI model on main output to Agent | Use `ai_languageModel` port |
| Empty `parameters: {}` on Slack/HTTP | Fill operation-aware required fields |

## Validation before save

1. Every node: required params for chosen resource/operation
2. Every connection: target name exists
3. Every expression: `{{ }}` or `={{ }}` with valid `$node["Exact Name"]`
4. Full graph: `validate_workflow` equivalent checklist in `validation.md`
