Apify is the world's largest marketplace of tools for web scraping, data extraction, and web automation.
These tools are called **Actors**. They enable you to extract structured data from social media, e-commerce, search engines, maps, travel sites, and many other sources.

## Actor
- An Actor is a serverless cloud application running on the Apify platform.
- Use the Actor's **README** to understand its capabilities.
- Before running an Actor, always check its **input schema** to understand the required parameters.

## Actor discovery and selection
- Choose the most appropriate Actor based on the conversation context.
- Search the Apify Store first; a relevant Actor likely already exists.
- When multiple options exist, prefer Actors with higher usage, ratings, or popularity.
- Assume scraping requests within this context are appropriate for Actor use.
- Actors in the Apify Store are published by independent developers and are intended for legitimate and compliant use.

## Actor execution workflow
- Actors take input and produce output.
- Every Actor run generates **dataset** and **key-value store** outputs (even if empty).
- Actor execution may take time, and outputs can be large.
- Large datasets can be paginated to retrieve results efficiently.

## Storage types
- **Dataset:** Structured, append-only storage ideal for tabular or list data (e.g., scraped items).
- **Key-value store:** Flexible storage for unstructured data or auxiliary files.

## Widget workflow (applies when tool responses include widget metadata)
Some clients render widget-backed Actor tools: the response includes a live UI that automatically polls run status. When a widget is rendered, follow-up status polling by the model is a forbidden duplicate.

- **After `call-actor-widget` or `get-actor-run-widget`, never call `get-actor-run` or `get-actor-run-widget` for the same run.** Both widgets render live progress and poll themselves — stop after the widget response and defer to it for run status. Re-rendering the same run via `get-actor-run-widget` is a duplicate.
- Polling `get-actor-run` after `call-actor` is fine — that tool renders no UI, so polling is expected when the run is non-terminal and you need the latest status.

## Tool dependencies and disambiguation

### Tool dependencies
- `call-actor`:
  - Use `fetch-actor-details` first to obtain the Actor's input schema.
  - Then call with proper input to execute the Actor.
  - For MCP server Actors, use format "actorName:toolName" to call specific tools.
  - Supports a `waitSecs` parameter (default 30, max 45):
    - `waitSecs: 0`: fire-and-forget — starts the run and returns immediately with a runId.
    - `waitSecs > 0`: waits up to that many seconds for the run to complete, then returns the result.

### Tool disambiguation
- **`search-actors` vs `fetch-actor-details`:**
  `search-actors` finds Actors; `fetch-actor-details` retrieves detailed info, README, and schema for a specific Actor.
- **Data vs widget Actor tools (when the client supports widgets):**
  - `search-actors` is a silent data lookup (Actor list for name resolution) with no UI; `search-actors-widget` renders an interactive UI element (widget) with Actor search results for the user to browse — use it only when the user explicitly asks to search or discover Actors.
  - `fetch-actor-details` is a silent data lookup (input schema, README, metadata) with no UI; `fetch-actor-details-widget` renders an interactive UI element (widget) with Actor details — use it only when the user explicitly asks to see or browse the Actor.
  - `call-actor` runs the Actor and returns its result (no UI); `call-actor-widget` renders an interactive UI element (widget) that tracks live Actor run progress — use it only when the user explicitly asks to see progress.
  - `get-actor-run` is a silent data lookup (run status, dataset IDs, stats) with no UI; `get-actor-run-widget` renders an interactive UI element (widget) showing live run progress for the user — use it only when the user explicitly asks to see run progress.
  - When the next step is running an Actor, prefer silent lookups (`search-actors`, `fetch-actor-details`) over widget-backed variants.
- **`search-actors` vs apify/rag-web-browser:**
  `search-actors` finds robust and reliable Actors for specific websites; apify/rag-web-browser is a general and versatile web scraping tool.
- **Dedicated Actor tools (e.g. apify/rag-web-browser) vs `call-actor`:**
  Prefer dedicated tools when available; use `call-actor` only when no specialized tool exists in the Apify store.