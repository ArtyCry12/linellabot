# n8n Anti-Hallucination Playbook

Distilled from n8n-mcp README / Claude Project instructions. Apply on **every** workflow task.

## Safety

- **Never** edit production workflows with AI without copy + backup
- Test in dev; export JSON before bulk changes
- Activate only after validation passes

## Core principles

### 1. Silent execution (when using MCP tools)

Run discovery/validation tools first; present plan/results after — not narrate each tool call.

### 2. Parallel discovery

Independent `search_nodes` / `get_node` calls can run in parallel.

### 3. Templates first

Search templates before greenfield (thousands available). When using a template:

> Based on template by **Author Name** (@username). View at: [n8n.io URL]

### 4. Multi-level validation

```
validate_node(minimal) → validate_node(full, runtime) → validate_workflow
```

### 5. Never trust defaults

Explicitly set **all** parameters that affect runtime behavior. Missing `channelId`, `sendBody`, `select`, etc. causes silent or runtime failures.

## Process (8 phases)

| # | Phase | Action |
|---|-------|--------|
| 1 | Start | Read best-practices / SDK reference if building |
| 2 | Templates | `search_templates` by task, metadata, or node types |
| 3 | Nodes | `search_nodes` — clarify requirements first |
| 4 | Configure | `get_node` standard + `includeExamples` when available |
| 5 | Validate nodes | Fix **all** errors before assembly |
| 6 | Build JSON | Wire connections; explicit params; error handling |
| 7 | Validate workflow | Structure + expressions + AI tools |
| 8 | Deploy | Create inactive → test → activate |

## Node type formats

| Context | Format |
|---------|--------|
| Workflow JSON `type` | `n8n-nodes-base.slack` |
| MCP tool `nodeType` | `nodes-base.slack` |
| LangChain | `@n8n/n8n-nodes-langchain.*` |

Convert between formats — do not invent node type strings.

## Connection rules

- Keys: **source node name**
- `addConnection`: four params — `source`, `target`, `sourcePort`, `targetPort`
- IF: `branch: "true"` / `"false"` in partial ops
- AI: use `sourceOutput: "ai_languageModel"` etc.

## Expression rules (summary)

- Webhook: `$json.body.field`
- Cross-node: `$node["Exact Name"].json.field`
- Code node: no `{{ }}`

## What NOT to hallucinate

| Don't invent | Do instead |
|--------------|------------|
| Node `type` strings | `search_nodes` / docs |
| Parameter names | `get_node_types` / standard schema |
| `typeVersion` | From schema or examples |
| Credential IDs | User's n8n credential names |
| API field names | Node docs + examples |
| Expression v2 / mystery syntax | Classic `{{ }}` or official SDK |

## Iteration norm

Average workflow build: **multiple** edit cycles (~56s between edits). First draft is never final.

## Handoff checklist (agent output)

When delivering workflow JSON to user:

- [ ] Pattern named
- [ ] All nodes have explicit critical parameters
- [ ] Connections use names not IDs
- [ ] Webhook expressions use `.body`
- [ ] Validation status stated (or MCP validation run)
- [ ] Assumptions listed for unverified fields

## Related modules

- `validation.md`, `node-configuration.md`, `workflow-json.md`, `patterns.md`
