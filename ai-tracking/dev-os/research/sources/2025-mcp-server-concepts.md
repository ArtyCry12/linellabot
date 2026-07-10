---
source_id: 2025-mcp-server-concepts
title: Understanding MCP Servers
url: https://modelcontextprotocol.io/docs/learn/server-concepts
source_class: B
domain: mcp-ecosystem
date_reviewed: 2026-07-01
confidence: high
---

# Source extraction card

## Summary

Three server primitives: **Tools** (model-invoked actions), **Resources** (passive read-only context), **Prompts** (user-invoked templates). Real power = multiple servers composed through host.

## Architectural patterns observed

- Tools = write/action; Resources = read/context; Prompts = structured user workflows
- User consent before tool execution (control model)
- Multi-server composition via unified host interface

## Why built this way

Separates action from context from UX templates — avoids dumping everything as tools.

## Applicable to Cursor Dev OS?

Hub mostly uses tools; fetch/Exa = context retrieval. Consider resources for gitnexus:// URIs. Don't expose read-only data as write tools.

## Conflicts with other sources

None
