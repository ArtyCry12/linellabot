# n8n AI Agents — Connection and Build Rules

## Architecture

```
[Trigger] --main--> [AI Agent] --main--> [Output]
                        ↑
        ┌───────────────┼───────────────┐
        │               │               │
   [Chat Model]    [Tools...]     [Memory]
   ai_languageModel  ai_tool      ai_memory
```

## Critical: reversed connection direction

Standard n8n: `[Source] --main--> [Target]`

AI pattern: **resource connects INTO consumer**

```
[OpenAI Chat Model] --ai_languageModel--> [AI Agent]
[HTTP Request Tool] --ai_tool-----------> [AI Agent]
[Window Buffer Memory] --ai_memory----> [AI Agent]
```

In partial-update APIs use `sourceOutput: "ai_languageModel"` (not default `main`).

## Connection types

| Port | From | To |
|------|------|-----|
| `ai_languageModel` | OpenAI, Anthropic, etc. | AI Agent / Chain |
| `ai_tool` | Any tool-capable node | AI Agent |
| `ai_memory` | Buffer / Postgres memory | AI Agent |
| `ai_outputParser` | Structured Output Parser | AI Agent |
| `ai_embedding` | Embeddings node | Vector Store |
| `ai_vectorStore` | Vector Store | Retriever / Agent |
| `ai_document` | Document Loader | Vector Store |
| `ai_textSplitter` | Text Splitter | Loader chain |

## Tool nodes

- **Any node** can be attached as AI tool (not only nodes marked "AI tool")
- Tool must expose usable operations for the agent
- Connect tool → agent on `ai_tool` port

## Minimal agent JSON (conceptual)

```json
{
  "nodes": [
    { "name": "Chat Trigger", "type": "@n8n/n8n-nodes-langchain.chatTrigger", "typeVersion": 1, "parameters": {}, "position": [0, 0] },
    { "name": "AI Agent", "type": "@n8n/n8n-nodes-langchain.agent", "typeVersion": 1, "parameters": { "text": "={{ $json.chatInput }}" }, "position": [300, 0] },
    { "name": "OpenAI Model", "type": "@n8n/n8n-nodes-langchain.lmChatOpenAi", "typeVersion": 1, "parameters": { "model": "gpt-4o-mini" }, "position": [300, 200] }
  ],
  "connections": {
    "Chat Trigger": { "main": [[{ "node": "AI Agent", "type": "main", "index": 0 }]] },
    "OpenAI Model": { "ai_languageModel": [[{ "node": "AI Agent", "type": "ai_languageModel", "index": 0 }]] }
  }
}
```

(Adjust `type`/`typeVersion` from live `get_node_types` — do not copy blindly.)

## Streaming mode

When AI Agent uses **streaming**:

- **No main output** connections from Agent (conflicts with stream)
- Response via trigger's streaming channel

## Validation failures (AI)

| Problem | Fix |
|---------|-----|
| Agent has no model | Add `ai_languageModel` edge |
| Model on main port | Move to `ai_languageModel` |
| Streaming + main out | Remove main outputs from Agent |
| Tool not visible | `ai_tool` connection + valid tool config |

## Build order

1. `get_workflow_best_practices` for technique (chatbot, RAG, …)
2. `get_sdk_reference` if using Workflow SDK path
3. `search_nodes` for agent, model, tools, memory
4. `get_node_types` for exact parameter names
5. Wire AI ports before main downstream
6. `validate_workflow` with AI connection checks

## RAG pattern (sketch)

```
Loader → Splitter → Embeddings → Vector Store
Retriever + Model → AI Agent ← Memory
User message via Trigger
```

## Related

- `workflow-json.md` — AI port names in `connections`
- `node-configuration.md` — per-node parameters
- `validation.md` — workflow-level AI validation
