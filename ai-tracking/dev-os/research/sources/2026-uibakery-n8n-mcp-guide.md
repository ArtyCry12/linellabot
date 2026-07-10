---
source_id: 2026-uibakery-n8n-mcp-guide
title: n8n MCP Guide (patterns + best practices)
url: https://uibakery.io/blog/n8n-mcp-guide
source_class: D
domain: automation
date_reviewed: 2026-07-01
confidence: medium
---

# Source extraction card

## Summary

Three MCP patterns: n8n as MCP server (expose workflows), MCP Client node (n8n calls external tools), third-party n8n-mcp knowledge tools. Best practice: start with narrow tested workflows; HITL for money/PII/production; separate run vs edit permissions.

## Applicable to Cursor Dev OS?

Event-driven automation layer under Squad execution; sensitive flows need human gate (autonomy DEC-005 escalation)

## Why built this way

MCP bidirectional — hub uses outbound (Cursor→n8n); n8n can also consume MCP tools internally
