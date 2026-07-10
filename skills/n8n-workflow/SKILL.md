---
name: n8n-workflow
description: >-
  Build and validate n8n workflow JSON without hallucinations — node schemas,
  connections, expressions, validation profiles, AI agent wiring, and architectural
  patterns. Use for @n8n, n8n workflow, automate with n8n, webhook workflow,
  n8n JSON export, node parameters, expressions, validate workflow, AI agent n8n,
  or when user has n8n-mcp / instance MCP connected. Knowledge distilled from
  czlonkowski/n8n-mcp (MIT); no MCP server required to apply rules.
argument-hint: "[goal e.g. webhook to Slack | fix validation errors | AI agent with tools]"
user-invocable: true
---

# n8n Workflow Authoring (Cursor)

Autonomous knowledge skill for **generating correct n8n workflow JSON** — distilled from [czlonkowski/n8n-mcp](https://github.com/czlonkowski/n8n-mcp) `data/skills/` (MIT). **Not** an MCP server; pure authoring rules.

| Resource | Path |
|----------|------|
| Skill root | `C:/Users/Asus/.cursor/skills/n8n-workflow/` |
| Module index | [skill-index.md](skill-index.md) |
| Source clone (read-only) | `C:/Users/Asus/.cursor/ai-tracking/n8n-mcp-src/` |
| Live n8n instance MCP | `n8n-mcp` in `mcp.json` — use for deploy/search when connected |

## When to load

| User says | Read first |
|-----------|------------|
| `@n8n` + build/design/fix | This file → route via [skill-index.md](skill-index.md) |
| Expressions / `{{}}` / webhook data | [references/expressions.md](references/expressions.md) |
| Validation errors | [references/validation.md](references/validation.md) |
| Node params / defaults trap | [references/node-configuration.md](references/node-configuration.md) |
| Pattern choice (webhook, API, AI…) | [references/patterns.md](references/patterns.md) |
| AI Agent / LangChain nodes | [references/ai-agents.md](references/ai-agents.md) |
| Workflow JSON shape | [references/workflow-json.md](references/workflow-json.md) |
| Code node JS/Python | [references/code-nodes.md](references/code-nodes.md) |

## Non-negotiable rules (anti-hallucination)

1. **Never trust default parameter values** — explicit config for every behavior-controlling field.
2. **Never edit production workflows directly** — copy → dev → validate → deploy.
3. **Connection keys = source node `name` strings**, not IDs.
4. **Node `type` prefixes**: core `n8n-nodes-base.*`, LangChain `n8n-nodes-langchain.*` (or `@n8n/n8n-nodes-langchain.`).
5. **Webhook payload** lives under `$json.body`, not root.
6. **Code nodes** use `$json` / `$input` — no `{{}}` expressions.
7. **IF branches**: use explicit `branch: "true"` / `"false"` in partial updates; don't rely on `sourceIndex` alone.
8. **Validate iteratively** — expect 2–3 `validate_node` → fix cycles before `validate_workflow`.

Full playbook: [references/anti-hallucination.md](references/anti-hallucination.md).

## Authoring pipeline (always follow order)

```
Plan pattern → Discover nodes → get_node(standard) per node → Configure ALL params
  → validate_node(runtime) each → Assemble workflow JSON
  → validate_workflow → (optional) n8n-mcp deploy tools
```

### With n8n instance MCP connected

Prefer live tools over guessing:

| Step | Tool (n8n-mcp) |
|------|----------------|
| SDK / patterns | `get_sdk_reference`, `get_workflow_best_practices` |
| Find nodes | `search_nodes` |
| Schema | `get_node_types` |
| Validate | `validate_node`, `validate_workflow` |
| Deploy | `create_workflow_from_code`, `update_workflow` |

### Without MCP (JSON-only)

Use this skill's references + [examples/minimal-workflows.json](examples/minimal-workflows.json). State assumptions; flag unverified node params.

## Expressions note

This pack documents **classic n8n expressions** (`={{ }}` / `{{ }}`). The upstream repo does **not** ship separate "Expressions v2" docs — if the user uses **n8n Workflow SDK** (official instance MCP), follow `get_sdk_reference` instead of inventing JSON. See [references/expressions.md](references/expressions.md).

## Deliverables

- Workflow JSON in user's project (not inside this skill folder).
- Node names human-readable and unique.
- Short data-flow comment in chat; optional `settings` / `meta` notes.

## License

Knowledge adapted from [czlonkowski/n8n-mcp](https://github.com/czlonkowski/n8n-mcp) (MIT). Upstream skills: `data/skills/*`.
