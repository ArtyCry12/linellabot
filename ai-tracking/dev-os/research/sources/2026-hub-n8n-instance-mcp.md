---
source_id: 2026-hub-n8n-instance-mcp
title: Hub n8n-mcp instance configuration
url: file://C:/Users/Asus/.cursor/SYSTEM-REGISTRY.md
source_class: E
domain: automation
date_reviewed: 2026-07-01
confidence: high
---

# Source extraction card

## Summary

Production: HTTP n8n cloud MCP + JWT in mcp.json; utils scripts for health/descriptor sync; 33 tools manifest fallback when live list fails.

## Applicable to Cursor Dev OS?

Automation domain class E anchor; security: mcp.json gitignored, ship gates for prod workflows

## Why built this way

Instance-level MCP for event-driven ops complementary to Cursor agent hub
