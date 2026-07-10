# Domain: MCP Ecosystem

**Scope:** Model Context Protocol architecture, tools/resources/prompts, hub integration patterns.

## Findings summary (Sprint 2)

1. **Host-client-server topology:** Cursor = host; each MCP connection = isolated client session; servers expose capabilities with negotiated features at init.
2. **Three primitives:** Tools (actions), Resources (read-only context), Prompts (user templates) — hub primarily uses tools; gitnexus resources are underused opportunity.
3. **Tool design spec:** JSON Schema, deterministic tools/list order, stateful tools need explicit handles — aligns with descriptor-first + manifest fallback (n8n).
4. **Hub production pattern:** tier user MCP vs plugin MCP; Exa-only web research per thread; registry + mcp-routing as class E source of truth.
5. **No new MCP servers in Sprint 2** — existing stack (memory, gitnexus, exa, n8n, stitch, etc.) sufficient for Dev OS; add only when research proves gap.

## Comparative notes

| Approach | Pros | Cons | When |
|----------|------|------|------|
| Many specialized servers | Full capability | Context + auth overhead | Task-triggered plugins |
| Consolidated server | Simpler auth | Less modular | Solo tools |
| HTTP remote MCP (n8n) | Cloud automation | SSE/connection fragility | Workflow execution |
| stdio local MCP | Reliable local | Process management | memory, gitnexus, stitch |
| CLI instead of MCP | Zero MCP cost | No schema for agent | gh, npm scripts |

## Open gaps

- MCP resources vs tools for dev-os corpus (read findings as resources?)
- n8n-mcp long-term reliability (SSE vs supergateway proxy)

## Sources

| ID | Title | URL | Confidence |
|----|-------|-----|------------|
| 2025-mcp-architecture-spec | MCP Architecture | https://modelcontextprotocol.io/specification/2025-11-25/architecture | high |
| 2025-mcp-tools-spec | MCP Tools Spec | https://modelcontextprotocol.io/specification/draft/server/tools | high |
| 2025-mcp-server-concepts | Server Concepts | https://modelcontextprotocol.io/docs/learn/server-concepts | high |
| 2026-hub-mcp-routing | Hub MCP routing | file://rules/mcp-routing.mdc | high |
