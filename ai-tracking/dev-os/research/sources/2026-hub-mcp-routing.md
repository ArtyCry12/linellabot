---
source_id: 2026-hub-mcp-routing
title: Hub MCP routing and registry audit
url: file://C:/Users/Asus/.cursor/rules/mcp-routing.mdc
source_class: E
domain: mcp-ecosystem
date_reviewed: 2026-07-01
confidence: high
---

# Source extraction card

## Summary

Production hub pattern: 8+ MCP servers in mcp.json; plugin MCP on-demand; Exa primary for web; one provider per research thread; descriptor JSON before first call; Obsidian demoted to optional PKM; n8n-mcp HTTP instance server for automation.

## Architectural patterns observed

- Tiered MCP: user MCP (always configured) vs plugin MCP (task-triggered)
- Web dedup: Exa → fetch → Tavily fallback only
- Naming map: mcp.json id ↔ mcps/ descriptor folder

## Why built this way

Too many always-loaded tools pollute context; routing table reduces conflicts (Zapier lifecycle, browser vs web search).

## Applicable to Cursor Dev OS?

**Primary class E evidence** for mcp-ecosystem domain — Dev OS research should audit registry before proposing new servers.

## Conflicts with other sources

Spec allows many servers; hub policy intentionally limits concurrent web providers — local optimization
