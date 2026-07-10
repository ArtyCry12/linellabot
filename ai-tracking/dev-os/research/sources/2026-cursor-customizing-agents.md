---
source_id: 2026-cursor-customizing-agents
title: Customizing Agents (Cursor Learn)
url: https://cursor.com/learn/customizing-agents
source_class: E
domain: ai-dev-environments
date_reviewed: 2026-07-01
confidence: high
---

# Source extraction card

## Summary

Cursor documents three customization layers: **rules** (always-on static context), **skills** (dynamic on-demand workflows), **MCP** (external tools). CLI tools work without MCP. Official guidance: keep rules minimal; put occasional content in skills.

## Architectural patterns observed

- Rules = onboarding baseline; skills = specialized procedures; MCP = external capability bridge
- `/skill-name` invocation for repeatable workflows
- Rule pointing agent at CLI tools (gh, docker, kubectl)

## Why built this way

Always-on rules consume context every turn; skills defer cost until relevant — matches context-as-budget research from Sprint 1.

## Common failure modes

Over-engineering rules; documenting everything in always-on rules instead of skills

## Applicable to Cursor Dev OS?

**Validates hub design:** on-demand rules (dev-os.mdc), skills/ tree, orchestrator routing, minimal always-on (00-agent-orchestrator only).

## Conflicts with other sources

None — aligns with Anthropic context engineering and Phase 3 module map
