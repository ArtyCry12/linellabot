---
source_id: 2025-mcp-architecture-spec
title: MCP Architecture Specification
url: https://modelcontextprotocol.io/specification/2025-11-25/architecture
source_class: B
domain: mcp-ecosystem
date_reviewed: 2026-07-01
confidence: high
---

# Source extraction card

## Summary

Host-client-server: host coordinates multiple clients; each client 1:1 with a server. JSON-RPC, stateful sessions, capability negotiation at init. Servers expose resources/tools/prompts; security boundaries between servers.

## Architectural patterns observed

- Host = IDE (Cursor); clients = MCP connectors; servers = specialized capability providers
- Capability negotiation — features only if declared
- Inspired by LSP — standardized integration pattern

## Why built this way

Isolation + explicit capabilities prevent tool sprawl and unsafe cross-server leakage.

## Applicable to Cursor Dev OS?

Maps to hub: Cursor host, many MCP servers (memory, gitnexus, exa plugins), orchestrator picks one web provider. Security: never commit mcp.json secrets.

## Conflicts with other sources

None
