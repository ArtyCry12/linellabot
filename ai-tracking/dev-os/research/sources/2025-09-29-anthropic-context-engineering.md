---
source_id: 2025-09-29-anthropic-context-engineering
title: Effective Context Engineering for AI Agents
url: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
source_class: C
domain: context-engineering
date_reviewed: 2026-07-01
confidence: high
---

# Source extraction card

## Summary

Context is finite resource; engineering = curating what enters the window — not just prompt wording. Covers compaction, tool result hygiene, memory injection.

## Architectural patterns observed

- Context as budgeted asset
- Selective retrieval vs full history
- Tool output shaping for LLM consumption

## Why built this way

Long contexts degrade coherence and increase cost; curation beats raw accumulation

## Applicable to Cursor Dev OS?

Core to hub design: on-demand rules/skills, Exa dedup, tiered memory, dev-os compression pipeline

## Conflicts with other sources

None — foundational for all other patterns
