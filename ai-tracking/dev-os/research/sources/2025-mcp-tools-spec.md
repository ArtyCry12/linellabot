---
source_id: 2025-mcp-tools-spec
title: MCP Tools Specification
url: https://modelcontextprotocol.io/specification/draft/server/tools
source_class: B
domain: mcp-ecosystem
date_reviewed: 2026-07-01
confidence: high
---

# Source extraction card

## Summary

Tools: schema-defined, JSON Schema validation, tools/list + tools/call. Deterministic tool ordering for client cache + LLM prompt cache. Stateful tools must return explicit handles (no implicit per-connection state). listChanged notifications when tool set changes.

## Architectural patterns observed

- Tool name + description + inputSchema (+ optional outputSchema)
- Per-request auth may filter tool list by scope
- x-mcp-header for HTTP routing of params to headers

## Why built this way

Deterministic ordering and clear schemas reduce agent confusion; stateless-by-default avoids hidden session bugs.

## Applicable to Cursor Dev OS?

Validates descriptor-first workflow, Stitch proxy pattern (strip outputSchema when harmful), n8n manifest fallback when tools/list fails.

## Conflicts with other sources

Anthropic tool-writing guidance complements (agent-shaped tools) — not conflicting
