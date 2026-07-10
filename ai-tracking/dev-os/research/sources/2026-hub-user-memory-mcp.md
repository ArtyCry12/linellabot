---
source_id: 2026-hub-user-memory-mcp
title: Hub user-memory MCP + ai-tracking tiers
url: file://C:/Users/Asus/.cursor/SYSTEM-REGISTRY.md
source_class: E
domain: memory-systems
date_reviewed: 2026-07-01
confidence: high
---

# Source extraction card

## Summary

Current hub: user-memory (primary session facts), AGENTS.md, ai-tracking/, skills as skill memory. Obsidian demoted to optional PKM.

## Architectural patterns observed

- Layered memory without single vector DB
- squad-memory (Haiku) for promotion
- seo-geo HOT/WARM/COLD model as reference in skills library

## Applicable to Cursor Dev OS?

Baseline to evolve — Dev OS corpus adds research tier without replacing user-memory

## Why built this way

Minimize token load; avoid Obsidian REST fragility; git-tracked hub docs
