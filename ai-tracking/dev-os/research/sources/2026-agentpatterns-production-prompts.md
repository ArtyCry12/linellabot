---
source_id: 2026-agentpatterns-production-prompts
title: Production System Prompt Architecture
url: https://agentpatterns.ai/instructions/production-system-prompt-architecture/
source_class: D
domain: prompt-systems
date_reviewed: 2026-07-01
confidence: high
---

# Source extraction card

## Summary

Structured sections (XML/Markdown headers), cache-aware layering: static facts head, skill registry pointers (progressive disclosure), safety sections isolated, runtime params at tail.

## Applicable to Cursor Dev OS?

Validates hub: minimal always-on rules, skill registry, on-demand load — prefix stability for cache

## Why built this way

Prefix invalidation from reordering destroys cache — structure is performance + quality
