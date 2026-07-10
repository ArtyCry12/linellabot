---
source_id: 2026-cursor-changelog-2-4
title: Cursor 2.4 Changelog — Subagents, Skills, MCP
url: https://cursor.com/changelog/2-4
source_class: E
domain: ai-dev-environments
date_reviewed: 2026-07-01
confidence: high
---

# Source extraction card

## Summary

Cursor 2.4: custom subagents (parallel, own context, custom prompts/models), Agent Skills in editor+CLI, MCP definitions as JSON in `.cursor` loaded on-demand to save tokens. Skills preferred over always-on rules for dynamic/procedural work.

## Architectural patterns observed

- Lazy MCP discovery (JSON descriptors, load when needed)
- Default subagents: explore, bash, browser — context isolation by design
- Skills vs rules: dynamic discovery vs declarative always-on

## Why built this way

Token economy at platform level — same thesis as Dev OS orchestrator and descriptor-first MCP workflow.

## Applicable to Cursor Dev OS?

Explains why hub uses `projects/.../mcps/` descriptors + mcp-routing dedup. Custom agents (`squad-*`, `dev-os-research`) align with 2.4 subagent model.

## Conflicts with other sources

None
