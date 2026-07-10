---
source_id: 2025-09-11-anthropic-writing-tools-mcp
title: Writing Effective Tools for AI Agents (MCP)
url: https://www.anthropic.com/engineering/writing-tools-for-agents
source_class: C
domain: context-engineering
date_reviewed: 2026-07-01
confidence: high
---

# Source extraction card

## Summary

MCP tools should be agent-shaped: clear names, minimal parameters, consolidated operations, responses optimized for model parsing. Hundreds of tools possible if well-designed.

## Architectural patterns observed

- Tool design as context engineering
- Consolidation vs fragmentation
- Error messages as agent guidance

## Applicable to Cursor Dev OS?

Explains Stitch proxy (strip outputSchema), MCP routing table, descriptor-first workflow in hub

## Why built this way

Bad tools pollute context and cause misuse; tool surface is part of prompt
