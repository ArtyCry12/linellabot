---
source_id: 2026-n8n-mcp-build-workflows
title: n8n MCP Server — Build Workflows
url: https://blog.n8n.io/n8n-mcp-server/
source_class: B
domain: automation
date_reviewed: 2026-07-01
confidence: high
---

# Source extraction card

## Summary

Official n8n instance MCP: execute + build/update workflows from AI clients (Cursor). TypeScript SDK generation (not raw JSON) for type-check before deploy. Validate, test-run, self-fix loop.

## Applicable to Cursor Dev OS?

Hub `n8n-mcp` HTTP instance aligns — pair with offline `n8n-workflow` skill for expression/validation knowledge.

## Common failure modes

Over-engineering first draft; wrong node when options overlap; complex branching needs cleanup

## Why built this way

First-party integration beats third-party JSON hallucination; compile step = guardrail
