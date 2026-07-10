# Apify spend policy (REQ-009, relaxed Jul 2026)

**Principle:** Apify is **allowed** when it is the best tool — cost-aware, not blocked by default.

## When to use without asking

| Scenario | Action |
|----------|--------|
| User mentions Apify, Actor, or scraping at scale | Use Apify |
| fetch + browser failed (login wall, heavy JS, anti-bot) | Apify as next step |
| Structured crawl / export (URLs, reviews, listings) | Apify if cheaper than manual loops |
| Task clearly needs Actor catalog (Instagram, maps, e-commerce) | Pick smallest fit Actor |

## When to ask first (one line)

| Scenario | Ask |
|----------|-----|
| Estimated run **> $1** or **> 1k results** | «Запускаю Actor X (~N credits), ок?» |
| Repeated runs in same session (2+) | Confirm batch |
| Exploratory «посмотри что есть» without task | Prefer Exa/fetch/browser first |

## Cost ladder (prefer top)

1. **Static / cache** — refs, local files, prior audit
2. **fetch MCP** — single URL, markdown
3. **Exa** — search + one fetch (when available)
4. **cursor-ide-browser** — logged-in UI, forms, okara-style audits
5. **Apify** — scale, resilience, structured datasets

## Guardrails (keep)

- One Actor per logical task; no blind retry loops
- Log run intent in `ai-tracking/` when spend likely
- After run: summarize output path + approximate cost if API returns it
- Never Apify for what browser already captured in-session

## Setup

Add Apify MCP to `mcp.json` when token available (plugin or `apify-mcp-server`). Agent may enable on first justified task.
